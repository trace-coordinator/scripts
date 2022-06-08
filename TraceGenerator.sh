#!/bin/bash
for i in 1 2 5 7 10 15 20 30 50 70 100; do
    lttng create benchmark-"$i" --output=/home/baby/lttng-traces/big-traces/benchmark-"$i"
    lttng enable-event --kernel --all
    lttng start
    sleep $((60*$i))
    lttng stop
    lttng destroy
done
