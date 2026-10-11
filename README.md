# ai_agent_x402_datasource
ver1.1

Commands to start/stop services
------
nohup uvicorn main:app --host 0.0.0.0 --port 8000 --reload > uvicorn.log 2>&1 &
tail -f uvicorn.log
kill -9 $(lsof -t -i:8000)