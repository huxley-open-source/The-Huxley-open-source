dataSource {
    pooled = true
    driverClassName = "com.mysql.jdbc.Driver"
    dialect = "org.hibernate.dialect.MySQL5InnoDBDialect"
    //dialect = "org.hibernate.dialect.MySQLMyISAMDialect"
    username = ""
    password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
}
// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "validate" // one of 'create', 'create-drop', 'update', 'validate'
            url = "jdbc:mysql://localhost/huxley-prod?autoReconnect=true&useUnicode=yes&characterEncoding=UTF-8"
        }
    }
    test {
        dataSource {
            dbCreate = "validate"
            url = "jdbc:mysql://localhost/huxley-prod?autoReconnect=true&useUnicode=yes&characterEncoding=UTF-8"
        }
    }
    production {
        dataSource {
            url = "jdbc:mysql://localhost/huxley-prod?autoReconnect=true&useUnicode=yes&characterEncoding=UTF-8"
            pooled = true
            properties {
               maxActive = -1
               minEvictableIdleTimeMillis=1800000
               timeBetweenEvictionRunsMillis=1800000
               numTestsPerEvictionRun=3
               testOnBorrow=true
               testWhileIdle=true
               testOnReturn=true
               validationQuery="SELECT 1"
            }
        }
    }
}
