---
title: "HikariCP on Jakarta EE"
date: 2020-11-17
lastmod: 2020-11-21
author: "[Sascha Böhme](https://github.com/boehme-qaware)"
type: "post"
image: "hikari.png"
tags: ["Jakarta EE", "Java EE", "HikariCP", "Connection Pool", "Payara"]
aliases:
    - /posts/2020-11-17-hikaricp-on-jakarta-ee/
summary: Examples for an implementation of an efficient JDBC connection pool using Jakarta EE on Payara.
draft: false
---

## Motivation

A JDBC connection pool is essential for application servers where several parallel requests need access to a database. Especially on high load, an efficient JDBC connection pool is important to avoid locked threads, delayed request processing or partial service interruptions.

Payara, closely related to the GlassFish reference implementation of Jakarta EE (JEE), comes with its own implementation of a JDBC connection pool. Under high load our application experienced locking deficiencies when it comes to high load. Fortunately, this implementation can be replaced with a custom connection pool using standard means of Jakarta EE. [HikariCP](https://github.com/brettwooldridge/HikariCP) offers a fast, reliable and small implementation of a connection pool without further dependencies.

## Data source definition

Jakarta EE provides the annotation `DataSourceDefinition` to declare a data source. This annotation can be used to inject HikariCP into the application server. The following example class `WrappedDataSource.java` shows how to proceed:

```java
package full.pkg.name;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.postgresql.ds.PGSimpleDataSource;

import javax.annotation.sql.DataSourceDefinition;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
 
@DataSourceDefinition(
    name = "java:app/jdbc/DefaultDb",  // the JNDI name referenced in the persistence.xml
    className = "full.pkg.name.WrappedDataSource"
)
public class WrappedDataSource implements DataSource {
 
    private final HikariDataSource hikariDataSource;
 
    /**
     * Creates a new {@link WrappedDataSource}.
     */
    public WrappedDataSource() {
        // set-up the underlying JDBC datasource for accessing the database (PostgreSQL, Oracle)
        PGSimpleDataSource ds = ...;
 
        HikariConfig hc = new HikariConfig();
        hc.setDataSource(ds);
    
        // configure HikariCP as needed
        hc.setMinimumIdle(...);  
        hc.setMaximumPoolSize(...);
        hc.setConnectionTimeout(...);
        hc.setIdleTimeout(...);
        hc.setRegisterMbeans(...);
 
        hikariDataSource = new HikariDataSource(hc);
    }
 
    @Override
    public Connection getConnection() throws SQLException {
        return hikariDataSource.getConnection();
    }
 
    @Override
    public Connection getConnection(String username, String password) throws SQLException {
        return hikariDataSource.getConnection(username, password);
    }
 
    @Override
    public PrintWriter getLogWriter() throws SQLException {
        return hikariDataSource.getLogWriter();
    }
 
    @Override
    public void setLogWriter(PrintWriter out) throws SQLException {
        hikariDataSource.setLogWriter(out);
    }
 
    @Override
    public void setLoginTimeout(int seconds) throws SQLException {
        hikariDataSource.setLoginTimeout(seconds);
    }
 
    @Override
    public int getLoginTimeout() throws SQLException {
        return hikariDataSource.getLoginTimeout();
    }
 
    @Override
    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
        return hikariDataSource.getParentLogger();
    }
 
    @Override
    public <T> T unwrap(Class<T> iface) throws SQLException {
        return hikariDataSource.unwrap(iface);
    }
 
    @Override
    public boolean isWrapperFor(Class<?> iface) throws SQLException {
        return hikariDataSource.isWrapperFor(iface);
    }
}
```

Thanks to the class annotation, the application server discovers this class on start-up and initializes HikariCP. The data source can thus be referenced in the JPA configuration file `persistence.xml` by the declared JNDI name:

```xml
<persistence xmlns="http://xmlns.jcp.org/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/persistence http://xmlns.jcp.org/xml/ns/persistence/persistence_2_1.xsd"
             version="2.1">
    <persistence-unit name="Default" transaction-type="JTA">
        <jta-data-source>java:app/jdbc/DefaultDb</jta-data-source>
 
        <!-- further configuration -->
    </persistence-unit>
</persistence>
```

This results in HikariCP providing all JDBC connections required by `@Transactional` annotations for JTA.

Alternatively, direct access to the data source is possible via injection into CDI beans:

```java
import javax.annotation.Resource;
import javax.enterprise.context.ApplicationScoped;
import javax.sql.DataSource;

@ApplicationScoped
public class SomeClass {

    @Resource(lookup = "java:app/jdbc/DefaultDb")
    private DataSource dataSource;

}
```

These examples have been tested on Payara. Since the `DataSourceDefinition` annotation is part of Jakarta EE, the shown example code should be applicable to any application server which implements Jakarta EE.
