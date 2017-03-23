#!/bin/bash

cd CartoDB-SQL-API
echo | node app.js development &
sleep 10
tail -f /CartoDB-SQL-API/logs/cartodb-sql-api.log
