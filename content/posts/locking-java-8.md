---
title: "Locking Alternatives in Java 8"
date: 2016-06-15T10:39:32+02:00
draft: false
author: Stefan Billet
tags: [Java, Locking, Memory, Performance]
aliases:
    - /posts/2016-06-15-locking-java-8/
summary: To provide synchronized data cache access, I discuss three alternatives in Java 8.    
---
# Abstract
To provide synchronized data cache access, I discuss three alternatives in Java 8: [synchronized() blocks](https://docs.oracle.com/javase/tutorial/essential/concurrency/locksync.html), [ReadWriteLock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReadWriteLock.html) and [StampedLock](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/StampedLock.html) (new in Java 8). I show code snippets and compare the performance impact on a real world application.

# The Use Case
Consider the following use case: A data cache that holds key-value pairs and needs to be accessed by several threads concurrently.

One option is to use a synchronized container like [`ConcurrentHashMap`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentHashMap.html) or [`Collections.synchronizedMap(map)`](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#synchronizedMap-java.util.Map). Those have their own [considerations](http://stackoverflow.com/questions/510632/whats-the-difference-between-concurrenthashmap-and-collections-synchronizedmap), but will not be handled in this article.

In our use case, we want to store arbitrary objects into the cache and retrieve them by Integer keys in the range of 0..n. As memory usage and performance is critical in our application, we decided to use a good, old array instead of a more sophisticated container like a Map.

A naive implementation allowing multi-threaded access without any synchronization can cause subtle, hard to find data inconsistencies:

* Memory visibility: Threads may see the array in different states (see [explanation](http://tutorials.jenkov.com/java-concurrency/java-memory-model.html#visibility-of-shared-objects)).
* Race conditions: Writing at the same time may cause one thread's change to be lost (see [explanation](http://tutorials.jenkov.com/java-concurrency/java-memory-model.html#race-conditions))

Thus, we need to provide some form of synchronization.

To fix the problem of memory visibility, Java's `volatile` keyword seems to be the perfect fit. However, making an array volatile has not the [desired effect](http://jeremymanson.blogspot.de/2009/06/volatile-arrays-in-java.html) because it makes accesssing the array variable atomic, but not accessing the arrays _content_.

In case the array's payload is Integer or Long values, you might consider [AtomicIntegerArray](http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicIntegerArray.html) or [AtomicLongArray](http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/atomic/AtomicLongArray.html). But in our case, we want to support arbitrary values, i.e. Objects.

Traditionally, there are two ways in Java to do synchronization: [`synchronized()` blocks](https://docs.oracle.com/javase/tutorial/essential/concurrency/locksync.html) and [`ReadWriteLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReadWriteLock.html). Java 8 provides another alternative called [`StampedLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/StampedLock.html). There are propably more exotic ways, but I will focus on these three relatively easy to implement and well understood ways.

For each approach, I will provide a short explanation and a code snippet for the cache's read and write methods.

# Synchronized
[`synchronized`](https://docs.oracle.com/javase/tutorial/essential/concurrency/locksync.html) is a Java keyword that can be used to restrict the execution of code blocks or methods to one thread at a time. Using synchronized is straight forward - just make sure to not miss any code that needs to be synchronized. The downside is, you can't differentiate between read and write access (the other two alternatives will). If one thread enters the synchronized block, everyone else will be locked. On the upside, as a core language feature, it is well optimized in the JVM.

```java
public class Cache {
  private Object[] data;
  private final Object lock = new Object();

  public Object read(int key) {
    synchronized (lock) {
      if (data.length <= key) {
        return null;
      }

      return data[key];
    }
  }

  public void write(int key, Object value) {
    synchronized (lock) {
        ensureRange(key); // enlarges the array if necessary
        data[key] = value;
    }
  }
}
```

# ReadWriteLock
[`ReadWriteLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReadWriteLock.html) is an interface. If I say ReadWriteLock, I mean its only standard library implementation [`ReentrantReadWriteLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantReadWriteLock.html). The basic idea is to have two locks: one for write access and one for read access. While writing locks out everyone else (like synchronized), multiple threads may read concurrently. If there are more readers than writers, this leads to less threads being blocked and therefor better performance.

```java
public class Cache {
  private Object[] data;
  private final ReadWriteLock lock = new ReentrantReadWriteLock();

  public Object read(int key) {
    lock.readLock().lock();
    try {
      if (data.length <= key) {
        return null;
      }

      return data[key];
    } finally {
      lock.readLock().unlock();
    }
  }
 
public void write(int key, Object value) {
  lock.writeLock().lock();
    try {
      ensureRange(key); // enlarges the array if necessary
      data[key] = value;
    } finally {
      lock.writeLock().unlock();
    }
  }
}
```

# StampedLock
[`StampedLock`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/StampedLock.html) is a new addition in Java 8. It is similiar to `ReadWriteLock` in that it also has separate read and write locks. The methods used to aquire locks return a "stamp" (long value), that represents a lock state. I like to think of the stamp as the "version" of the data in terms of data visibility. This makes a new locking strategy possible: the "optimistic read". An optimistic read means to aquire a stamp (but no actual lock), read without locking and afterwards validate the lock, i.e. check if it was ok to read without a lock. If we were too optimistic and it turns out someone else wrote in the meantime, the stamp would be invalid. In this case, we have no choice but to acquire a real read lock and read the value again.

Like `ReadWriteLock`, `StampedLock` is efficient if there is more read than write access. It can save a lot overhead to not have to acquire and release locks for every read access. On the other hand, if reading is expensive, reading twice from time to time may also hurt.

```java
public class Cache {
  private Object[] data;
  private final StampedLock lock = new StampedLock();

  public Object read(int key) {
    long stamp = lock.tryOptimisticRead();

    // Read the value optimistically (may be outdated).
    Object value = null;
    if (data.length > key) {
      value = data[key];
    }

    // Validate the stamp - if it is outdated,
    // acquire a read lock and read the value again.
    if (lock.validate(stamp)) {
      return value;
    } else {
      stamp = lock.readLock();

      try {
        if (data.length <= key) {
          return null;
        }

        return data[key];
      } finally {
        lock.unlock(stamp);
      }
    }
  }

  public void write(int key, Object value) {
    long stamp = lock.writeLock();
    try {
      ensureRange(key); // enlarges the array if necessary
      data[key] = value;
    } finally {
      lock.unlock(stamp);
    }
  }
}
```

# Benchmark
All three alternatives are valid choices for our cache use case, because we expect more reads than writes. To find out which is best, I ran a benchmark with our application. The test machine is a Intel Core i7-5820K CPU which has 6 physical cores (12 logical cores with hyper threading). Our application spawns 12 threads that access the cache concurrently. The application is a "loader" that imports data from a database, makes calculations and stores the results into a database. The cache is not under stress 100% of the time. However it is vital enough to show a significant impact on the application's overall runtime.

As benchmark I executed our application with reduced data. To get a good average, I ran each locking strategy three times. Here are the results:

![](/images/Laufzeit_DemandLoader.png)

In our use case, `StampedLock` provides the best performance. While 15% difference to `synchronized` and 24% difference to `ReadWriteLock` may not seem much, it is relevant enough to make the difference between making the nightly batch time frame or not (using full data). I want to stress that by no means this means that `StampedLock` is *the* best option in all cases. [Here](http://www.javacodegeeks.com/2014/06/java-8-stampedlocks-vs-readwritelocks-and-synchronized.html) is a good article that has more detailed benchmarks for different reader/writer and thread combinations. Nevertheless I believe measuring the actual application is the best approach.
