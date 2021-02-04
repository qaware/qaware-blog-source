---
title: "How to dispatch flux to worker in Reactor"
date: 2019-03-11T10:07:32+02:00
draft: false
author: Andreas Grub
tags: [Flux, Reactor, Java, Reactive]
aliases:
    - /posts/2019-03-11-dispatch-flux-in-reactor/
summary: This post shows how to dispatch a flux of items to services of separated functional domains when using Reactor in Java.
---

This post shows how to dispatch a flux of items to services of separated functional domains when using [Reactor](https://projectreactor.io/) in Java. The author encountered this problem while developing a larger reactive application, where a strict separation of different domains of the application is key to maintain a clean architecture.

Reactor is a library for developing reactive applications and its [reference guide](https://projectreactor.io/docs/core/release/reference/) is a good read to understand the basic principles of reactive programming.

The examples the author found for Reactor, or for other reactive libraries, show how to deal with a flux of items without mentioning how to dispatch and share this flux among separated functional domains. When mapping a flux to one functional domain, there is no obvious way to obtain the original flux to map it to another function domain. In the following, an example will detail the problem and present a solution for the Reactor library.

## An example application
This section introduces an example application which will be transformed later to a reactive one. It will dispatch some deletion tasks to independent services, which is a common feature of larger software systems.
A customer is represented by (the usual Java boiler plate such as `getters, setters, equals, hashCode, toString` is omitted)

```java
public class Customer {
    CustomerId id;
    AccountId account;
    Set<InvoiceId> invoices;
}
```

A customer has its own account and a set of associated invoices. The classes `CustomerId, AccountId, InvoiceId` here are simple wrapper classes to uniquely identify the corresponding entities.

A service supposed to delete a set of customers has the interface

```java
public interface CustomerService {
    void deleteCustomers(Set<CustomerId> customerIds)
}
```

An implementation of CustomerService should take care of deleting the account and the invoices as well.

```java
public class CustomerServiceImpl {
  @Override
  public void deleteCustomers(Set<CustomerId> customerIds) {
      Set<Customer> deletedCustomers = customerRepository
               .deleteCustomersByIds(customerIds);
      Set<AccountId> toBeDeletedAccounts = deletedCustomers.stream()
              .map(Customer::getAccount)
              .collect(Collectors.toSet());
      Set<InvoiceId> toBeDeletedInvoices = deletedCustomers.stream()
              .flatMap(customer -> customer.getInvoices().stream())
              .collect(Collectors.toSet());
      accountService.deleteAccounts(toBeDeletedAccounts);
      invoiceService.deleteInvoices(toBeDeletedInvoices);
  }
}
```

The deletion of the customers itself is delegated to an underlying `customerRepository`, which returns a collection of the deleted customers for further processing (this "find and delete" pattern is common for NoSQL databases, such as MongoDB).

Furthermore, the deletion of the associated accounts and invoices are delegated to the respective `accountService` and `invoiceService`, which have the following interface:

```java
public interface AccountService {
    void deleteAccounts(Set<AccountId> accountIds);
}

public interface InvoiceService {
    void deleteInvoices(Set<InvoiceId> invoiceIds);
}
```

Note that this example application has clearly separated domains, which are the customers, the invoices and the accounts.

## Reactive interfaces
Turning the service interfaces into reactive services is straight forward:

```java
public interface ReactiveAccountService {
    Mono<Void> deleteAccounts(Flux<AccountId> accountIds);
}

public interface ReactiveInvoiceService {
    Mono<Void> deleteInvoices(Flux<InvoiceId> invoiceIds);
}

public interface ReactiveCustomerRepository {
    Flux<Customer> deleteCustomersByIds(Set<CustomerId> customerIds);
}

public interface ReactiveCustomerService {
    Mono<Void> deleteCustomers(Set<CustomerId> customerIds);
}
```

Note that returning a `Mono<Void>` is the reactive way of telling the caller that the requested operation has completed (with or without errors). Also note that the input to the `ReactiveCustomerRepository` stays non-reactive, as we want to focus on the reactive implementation of the `CustomerService` in combination with `ReactiveAccountService` and `ReactiveInvoiceService`.

## Reactive implementation
### A first attempt
A first attempt to implement `CustomerService` reactively could lead to the following code

```java
@Override
public Mono<Void> deleteCustomers(Set<CustomerId> customerIds) {
    Flux<Customer> deletedCustomers = reactiveCustomerRepository
            .deleteCustomersByIds(customerIds);

    Flux<AccountId> toBeDeletedAccounts = deletedCustomers
            .map(Customer::getAccount);
    Mono<Void> accountsDeleted = reactiveAccountService
            .deleteAccounts(toBeDeletedAccounts);

    Flux<InvoiceId> toBeDeletedInvoices = deletedCustomers
            .flatMap(customer -> Flux.fromIterable(customer.getInvoices()));
    Mono<Void> invoicesDeleted = reactiveInvoiceService
            .deleteInvoices(toBeDeletedInvoices);

    return Flux.merge(accountsDeleted, invoicesDeleted).then();
}
```

However, when using the following dummy implementation for the `reactiveCustomerRepository`,

```java
@Override
public Flux<Customer> deleteCustomersByIds(Set<CustomerId> customerIds) {
    Flux<Integer> generatedNumbers = Flux.generate(
            () -> 0,
            (state, sink) -> {
                System.out.println("Generating " + state);
                sink.next(state);
                if (state == customerIds.size() - 1)
                    sink.complete();
                return state + 1;
            });
    return generatedNumbers
            .doOnSubscribe(subscription -> {
                System.out.println("Subscribed to repository source");
            })
            .map(i -> {
                CustomerId id = new CustomerId("Customer " + i);
                return createDummyCustomerFromId(id);
            });
}
```

the following output is obtained:

```plaintext
Subscribed to repository source
Generating 0
Deleting account AccountId[id=Account CustomerId[id=Customer 0]]
Generating 1
Deleting account AccountId[id=Account CustomerId[id=Customer 1]]
Generating 2
Deleting account AccountId[id=Account CustomerId[id=Customer 2]]
Subscribed to repository source
Generating 0
Deleting invoice InvoiceId[id=Invoice CustomerId[id=Customer 0]]
Generating 1
Deleting invoice InvoiceId[id=Invoice CustomerId[id=Customer 1]]
Generating 2
Deleting invoice InvoiceId[id=Invoice CustomerId[id=Customer 2]]
```

This might be surprising as the `reactiveCustomerRepository` is requested twice to generate the customer. If the repository wasn’t a dummy implementation here, the account deletion would have consumed all those `deletedCustomers`, and the subsequent invoice deletion would have worked on a completed stream (meaning doing nothing at all). This is certainly undesired behavior.

### Handling multiple subscribers

The reference documentation has an answer to this problem: Broadcasting to multiple subscribers with `.publish()`. The failing attempt should thus be modified as follows

```java
@Override
public Mono<Void> deleteCustomers(Set<CustomerId> customerIds) {
    Flux<Customer> deletedCustomers = reactiveCustomerRepository
            .deleteCustomersByIds(customerIds);

    deletedCustomers = deletedCustomers.publish().autoConnect(2);
    Flux<AccountId> toBeDeletedAccounts = deletedCustomers
            .map(Customer::getAccount);
    Mono<Void> accountsDeleted = reactiveAccountService
            .deleteAccounts(toBeDeletedAccounts);
    deletedCustomers = Flux.merge(deletedCustomers, accountsDeleted)
            .map(customer -> (Customer)customer);

    deletedCustomers = deletedCustomers.publish().autoConnect(2);
    Flux<InvoiceId> toBeDeletedInvoices = deletedCustomers
            .flatMap(customer -> Flux.fromIterable(customer.getInvoices()));
    Mono<Void> invoicesDeleted = reactiveInvoiceService
            .deleteInvoices(toBeDeletedInvoices);
    deletedCustomers = Flux.merge(deletedCustomers, invoicesDeleted)
            .map(customer -> (Customer)customer);

    return deletedCustomers.then();
}
```

As `.autoConnect(2)` is used, the subscription to the repository publisher only happens if two subscriptions have happened downstream. This requires the `reactiveAccountService` and `reactiveInvoiceService` to return a `Mono<Void>` which completes once the given input flux is consumed completely, which ensures one subscription. The second subscription is achieved by merging the output together with original input flux.

The output is then as expected

```plaintext
Subscribed to repository source
Generating 0
Deleting invoice InvoiceId[id=Invoice CustomerId[id=Customer 0]]
Deleting account AccountId[id=Account CustomerId[id=Customer 0]]
Generating 1
Deleting invoice InvoiceId[id=Invoice CustomerId[id=Customer 1]]
Deleting account AccountId[id=Account CustomerId[id=Customer 1]]
Generating 2
Deleting invoice InvoiceId[id=Invoice CustomerId[id=Customer 2]]
Deleting account AccountId[id=Account CustomerId[id=Customer 2]]
```

At this point, the `reactiveAccountService` and `reactiveInvoiceService` could now also decide to .buffer their own given flux if they wanted to delete the given accounts or invoices in batch. Each implementation is free to choose a different buffer (or batch) size on its own. This is an advantage over the non-reactive implementation, where all items have been collected in one large list beforehand and are then given in bulk to the `accountService` and `invoiceService`.

### Introducing a utility method
The above working solution has already been written such that a generic utility method can be extracted

```java
public class ReactiveUtil {
    private ReactiveUtil() {
        // static methods only
    }

    public static <T> Flux<T> dispatchToWorker(Flux<T> input,
                                               Function<Flux<T>,
                                               Mono<Void>> worker) {
        Flux<T> splitFlux = input.publish().autoConnect(2);
        Mono<Void> workerResult = worker.apply(splitFlux);
        return Flux.mergeDelayError(Queues.XS_BUFFER_SIZE, workerResult,
                                    splitFlux)
                .map(ReactiveUtil::uncheckedCast);
    }

    @SuppressWarnings("unchecked")
    private static <T> T uncheckedCast(Object o) {
        return (T)o;
    }
}
```

Instead of `Flux.merge`, `Flux.mergeDelayError` is used which handles the situation better if the worker returns an error for completion. In this particular use case, it’s desired that deletion continues even if one worker fails to do so. The worker is also expected to return a `Mono<Void>` which completes once the input flux is consumed. The simplest worker function would thus be `Flux::then`.

The unchecked cast could not be removed, but in this circumstance it should never fail as the merged flux can only contain items of type `T`, as the `Mono<Void>` just completes with no items at all.

A usage example in a more reactive style of coding would be

```java
return reactiveCustomerRepository.deleteCustomersByIds(customerIds)
        .transform(deletedCustomers -> ReactiveUtil.dispatchToWorker(
                deletedCustomers,
                workerFlux -> {
                    Flux<AccountId> toBeDeletedAccounts = workerFlux
                            .map(Customer::getAccount);
                    return reactiveAccountService
                            .deleteAccounts(toBeDeletedAccounts);
                }
        ))
        .transform(deletedCustomers -> ReactiveUtil.dispatchToWorker(
                deletedCustomers,
                workerFlux -> {
                    Flux<InvoiceId> toBeDeletedInvoices = workerFlux
                            .flatMap(customer -> Flux.fromIterable(customer.getInvoices()));
                    return reactiveInvoiceService
                            .deleteInvoices(toBeDeletedInvoices);
                }
        ))
        .then();
```

Note the pattern of using `.transform` together with the utility function. The output is the same as the working example above.

## Conclusion
Reactive applications should still follow the overall architecture of larger applications, which are usually split into several components for each functional domain. This approach clashes with reactive programming, where usually one stream is mapped with operators and dispatching work to other services is not easily supported. This post shows a solution, although usage in Java of the presented utility function is still somewhat clumsy.

In Kotlin, the usage of extension functions would make this utitilty easier to use without the rather clumsy `.transform` pattern above.

It’s also open if there’s a better solution for the presented problem. Comments welcome!
