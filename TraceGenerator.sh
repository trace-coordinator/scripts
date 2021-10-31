#!/bin/bash
for i in {0..899}; do
    lttng create benchmark_"$i" --output=/home/baby/lttng-traces/1000traces/benchmark_"$i"
    lttng enable-event -a -k
    lttng start
    sleep 10
    lttng stop
    lttng destroy
done
