# Maxwell from MySQL to Stdout

## Usage

To start the containers:

```bash
docker-compose up -d mysql
```

Then once its up start maxwell:

```bash
docker-compose up --build -d maxwell
```

## MySQL

We will open 2 terminals:
- one for running mysql commands
- one for tailing the maxwell container to view the events

To exec into mysql to run mysql commands:

```bash
docker exec -it mysql mysql -u root -ppassword
mysql>
```

To tail the maxwell logs:

```bash
docker logs -f maxwell
```

Create table statement:

```sql
CREATE TABLE domains (
  id INT(10) NOT NULL AUTO_INCREMENT,
  domain varchar(50) NOT NULL,
  owner  varchar(50),
  year_registered int(4),
  PRIMARY KEY (id)
);
```

Create table event:

```
2022-12-08 15:51:56 INFO  AbstractSchemaStore - storing schema @Position[BinlogPosition[master.000003:44923], lastHeartbeat=1670514713808] after applying "CREATE TABLE domains (   id INT(10) NOT NULL AUTO_INCREMENT,   domain varchar(50) NOT NULL,    owner  varchar(50),   year_registered int(4),   PRIMARY KEY (id)  )" to foo, new schema id is 3
```

Insert statement:

```sql
INSERT INTO domains (domain,owner,year_registered) VALUES("example.com", "John", 2019);
```

Insert event:

```json
{
  "database":"foo",
  "table":"domains",
  "type":"insert",
  "ts":1670514791,
  "xid":698,
  "commit":true,
  "primary_key":[1],
  "data":{
    "id":1,
    "domain":"example.com",
    "owner":"John",
    "year_registered":2019
  }
}
```

Update statement:

```sql
UPDATE domains SET owner = "Frank", year_registered = "2022" WHERE id = 1;
```

Update event:

```json
{
  "database":"foo",
  "table":"domains",
  "type":"update",
  "ts":1670514862,
  "xid":878,
  "commit":true,
  "primary_key":[1],
  "data":{
    "id":1,
    "domain":"example.com",
    "owner":"Frank",
    "year_registered":2022
  },
  "old":{
    "owner":"John",
    "year_registered":2019
  }
}
```

Delete statement:

```sql
DELETE from domains WHERE id = 1;
```

Delete event:

```json
{
  "database":"foo",
  "table":"domains",
  "type":"delete",
  "ts":1670514920,
  "xid":1030,
  "commit":true,
  "primary_key":[1],
  "data":{
    "id":1,
    "domain":"example.com",
    "owner":"Frank",
    "year_registered":2022
  }
}
```
