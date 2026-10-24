# ai_agent_x402_datasource
ver1.1

Commands to start/stop services
------
source ./venv/bin/activate
nohup uvicorn main:app --host 0.0.0.0 --port 8000 --reload > uvicorn.log 2>&1 &
tail -f uvicorn.log
kill -9 $(lsof -t -i:8000)

Commands to start/stop redis
------
redis-server --daemonize yes
redis-cli shutdown


Command to dump DB
------
pg_dump -U username -h localhost -p 5432 -d database_name -f backup_file.sql



Command to flush Redis DB
------
redis-cli FLUSHDB