```
bash-3.2$ export HOST_KEY=endpoint

bash-3.2$ export DB=my-db

bash-3.2$ export PGUSER=$(kubectl --namespace a-team \
    get secret $DB --output jsonpath="{.data.username}" \
    | base64 -d)
bash-3.2$ echo $PGUSER
masteruser

bash-3.2$ export PGPASSWORD=$(kubectl --namespace a-team \
>     get secret $DB --output jsonpath="{.data.password}" \
>     | base64 -d)

bash-3.2$ export PGHOST=$(kubectl --namespace a-team \
>     get secret $DB --output jsonpath="{.data.$HOST_KEY}" \
>     | base64 -d)

bash-3.2$ kubectl run postgresql-client --rm -ti --restart='Never' \
>     --image docker.io/bitnami/postgresql:16 \
>     --env PGPASSWORD=$PGPASSWORD --env PGHOST=$PGHOST \
>     --env PGUSER=$PGUSER --command -- sh

If you don't see a command prompt, try pressing enter.

$ psql --host $PGHOST -U $PGUSER -d postgres -p 5432
psql (16.4, server 13.15)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, compression: off)
Type "help" for help.

postgres=> \l
                                                          List of databases
   Name    |   Owner    | Encoding | Locale Provider |   Collate   |    Ctype    | ICU Locale | 
ICU Rules |     Access privileges     
-----------+------------+----------+-----------------+-------------+-------------+------------+-
----------+---------------------------
 my-db     | masteruser | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            | 
          | 
 postgres  | masteruser | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            | 
          | 
 rdsadmin  | rdsadmin   | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            | 
          | rdsadmin=CTc/rdsadmin
 template0 | rdsadmin   | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            | 
          | =c/rdsadmin              +
           |            |          |                 |             |             |            | 
          | rdsadmin=CTc/rdsadmin
 template1 | masteruser | UTF8     | libc            | en_US.UTF-8 | en_US.UTF-8 |            | 
          | =c/masteruser            +
           |            |          |                 |             |             |            | 
          | masteruser=CTc/masteruser
(5 rows)
exit
$ 
pod "postgresql-client" deleted
bash-3.2$ exit
exit
```
