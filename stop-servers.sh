#!/bin/bash
for i in {1..5}; do
    kill -9 "$(lsof -i tcp:808"$i" -t)"
done
