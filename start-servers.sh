#!/bin/bash
for i in {1..5}; do
    if [ ! -d "trace-compass-server_$i" ]; then
        cp -r trace-compass-server trace-compass-server_"$i"
        sleep 1
    fi
    ./trace-compass-server_"$i"/tracecompass-server -vmargs -Dtraceserver.port=808"$i" &
done

# To stop any server, just run the following command:
# kill -9 $(lsof -i tcp:port -t)
# example, to stop the server on the port 8082, just run :
# kill -9 $(lsof -i tcp:8082 -t)
