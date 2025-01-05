#!/bin/bash

PORT=5353

handler=$(cat "main_code.sh")

echo "Starting web server on port $PORT..."
echo "Visit http://localhost:$PORT to view the website."

while true; do
    ncat -l -p $PORT -c "$handler"
done