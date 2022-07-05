## MySql Shell - Utility
https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-utilities-dump-instance-schema.html

## Basic usage
`util.dumpInstance(outputUrl[, options])`\
`util.dumpSchemas(schemas, outputUrl[, options])`\
`util.dumpTables(schema, tables, outputUrl[, options])`\

### Dump instance
- `$> mysqlsh`
- `shell-py> shell.connect("root@localhost")`
- `shell-py> util.dump_instance("/home/backup")`
- `shell-py> util.dump_instance("/var/lib/mysql-files")`

### Dump schemas
- `shell-py> util.dump_schemas(["sandbox_db", "test_db"], "/home/backup")`

### Dump tables
- `shell-py> util.dump_tables("sandbox_db", ["users", "products"], "/home/backup")`
