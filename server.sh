#!/bin/bash

PORT=5353
code=$(cat "server_code.sh")

echo "Starting web server on port $PORT..."
echo "Visit http://localhost:$PORT to view the website."

while true; do
    ncat -l -p $PORT -c "$code"
done
