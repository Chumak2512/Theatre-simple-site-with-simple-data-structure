#!/bin/bash

USER="theater_guests"
PWD="1111"
HOST="localhost"
DB="theater_guests"

REQUEST_DATA=""
read REQUEST_DATA

ROUTE_ARGS=$(echo "$REQUEST_DATA" | awk "{print \$2}")
ROUTE="${ROUTE_ARGS%%\?*}"
ARGS="${ROUTE_ARGS#*\?}"

case "$ROUTE" in
    "/")
        FILE="html/index.html"
        STATUS="200 OK"
        ;;
    "/add_show")
        FILE="html/add_show.html"
        STATUS="200 OK"

        today=$(date +"%Y-%m-%d")

        SQL="SELECT id FROM shows;"
        db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)
        
        events=""
        for i in $db_resp; do
            
            SQL="SELECT name, price, show_date, available_seats FROM shows WHERE id=$i;"
            db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)
            
            name=$(echo "$db_resp" | awk -F'\t' '{print $1}')
            price=$(echo "$db_resp" | awk -F'\t' '{print $2}')
            date=$(echo "$db_resp" | awk -F'\t' '{print $3}')
            available_seats=$(echo "$db_resp" | awk -F'\t' '{print $4}')
            events="${events}<tr><td>$i</td><td>$name</td><td>$date</td><td>$available_seats</td><td>$price</td>
            <td><form action="delete_show"><input type="hidden" id="id" name="id" value=$i><input type="submit" value="Delete"></form></td></tr>"
    
        done

        ;;
    "/delete_show")
        FILE="html/delete_show.html"
        STATUS="200 OK"

        IFS="&" 
        for pair in $ARGS; do
            key="${pair%%=*}"     
            value="${pair#*=}"    
            
            case $key in
                id) id="$value" ;;
            esac
        done

        SQL="SELECT name, price, show_date, available_seats FROM shows WHERE id=$id; DELETE FROM shows WHERE id=$id;"
        db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)

        show_name=$(echo "$db_resp" | awk -F'\t' '{print $1}')
        date=$(echo "$db_resp" | awk -F'\t' '{print $3}')
        
        ;;
    "/buy_ticket")
        FILE="html/buy_ticket.html"
        STATUS="200 OK"

        IFS="&" 
		for pair in $ARGS; do
		    key="${pair%%=*}"      
		    value="${pair#*=}"     
		    
		    case $key in
                id) id="$value" ;;
    			show_name) show_name="$value" ;;
    			date) date="$value" ;;
    			available_seats) available_seats="$value" ;;
    			price) price="$value" ;;
		    esac
        done
        ;;
    "/guest_list")
        FILE="html/guest_list.html"
        STATUS="200 OK"

        SQL="SELECT id FROM tickets;"
        db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)
        
        tickets=""
        for i in $db_resp; do
            
            SQL="SELECT show_id, customer_name, number_of_tickets FROM tickets WHERE id=$i;"
            db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)
            
            show_id=$(echo "$db_resp" | awk -F'\t' '{print $1}')
            customer_name=$(echo "$db_resp" | awk -F'\t' '{print $2}')
            number_of_tickets=$(echo "$db_resp" | awk -F'\t' '{print $3}')

            SQL2="SELECT name, price, show_date, available_seats FROM shows WHERE id=$show_id;"
            db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL2" -N)
           
            name=$(echo "$db_resp" | awk -F'\t' '{print $1}')
            price=$(echo "$db_resp" | awk -F'\t' '{print $2}')
            date=$(echo "$db_resp" | awk -F'\t' '{print $3}')
            available_seats=$(echo "$db_resp" | awk -F'\t' '{print $4}')

            total_amount=$(($price * $number_of_tickets))

            tickets="${tickets}<tr><td>$i</td><td>$customer_name</td><td>$name</td><td>$date</td><td>$number_of_tickets</td><td>$price</td><td>$total_amount</td></tr>"
        
        done
        ;;
    
    "/confirm_buy_ticket")
    	FILE="html/confirm_buy_ticket.html"
    	STATUS="200 OK"
    	
        IFS="&" 
		for pair in $ARGS; do
		    key="${pair%%=*}"      
		    value="${pair#*=}"     
		    
		    case $key in
    			show_id) show_id="$value" ;;
    			customer_name) customer_name="$value"
                               customer_name=$(echo "$customer_name" | sed 's/+/ /g') ;;
    			number_of_tickets) number_of_tickets="$value" ;;
		    esac
        done
        
        SQL="INSERT INTO tickets (show_id, customer_name, number_of_tickets ) VALUES (\"$show_id\", \"$customer_name\" , \"$number_of_tickets\"); SELECT LAST_INSERT_ID();"
	    db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)

        SQL2="UPDATE shows SET available_seats = available_seats - $number_of_tickets WHERE id = $show_id;"
        mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL2"
	
        confirm_id=$(echo "$db_resp" | awk -F'\t' '{print $1}')	
        ;;
    "/confirm_part")
    	FILE="html/confirm_part.html"
    	STATUS="200 OK"
    	
        IFS="&" 
		for pair in $ARGS; do
		    key="${pair%%=*}"    
		    value="${pair#*=}"    
		    
		    case $key in
    			show_name) show_name="$value"
                           show_name=$(echo "$show_name" | sed 's/+/ /g') ;;
    			date) date="$value" ;;
    			available_seats) available_seats="$value" ;;
    			price) price="$value" ;;
		    esac
        done
        
        SQL="INSERT INTO shows (name, price, show_date, available_seats ) VALUES (\"$show_name\", \"$price\" , \"$date\", \"$available_seats\"); SELECT LAST_INSERT_ID();"
	    db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)
	
        confirm_id=$(echo "$db_resp" | awk -F'\t' '{print $1}')
        ;;
    "/events_list")
        FILE="html/events_list.html"
        STATUS="200 OK"

        current_date=$(date +%Y%m%d)
        
        SQL="SELECT id FROM shows;"
        db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)
        
        events=""
        for i in $db_resp; do
            
            SQL="SELECT name, price, show_date, available_seats FROM shows WHERE id=$i;"
            db_resp=$(mysql -u $USER -p$PWD -h $HOST -D $DB -e "$SQL" -N)
            
            name=$(echo "$db_resp" | awk -F'\t' '{print $1}')
            price=$(echo "$db_resp" | awk -F'\t' '{print $2}')
            date=$(echo "$db_resp" | awk -F'\t' '{print $3}')
            available_seats=$(echo "$db_resp" | awk -F'\t' '{print $4}')

            show_date=$(echo $date | sed 's/-//g')

            if [ "$show_date" -ge "$current_date" ]; then
                if [ "$available_seats" -gt 0 ]; then
                    button_html="<input type='submit' value='Buy ticket'>"
                else
                    button_html="<h3>Sold out</h3>"
                fi

                events="${events}
                <form action="buy_ticket">
                    <input type="hidden" id="id" name="id" value=$i>

                    <div>Name of the performance: $name</div>
                    <input type="hidden" id="show_name" name="show_name" value=$name>

                    <div>Date of the event: $date</div>
                    <input type="hidden" id="date" name="date" value=$date>

                    <div>Available seats: $available_seats</div>
                    <input type="hidden" id="available_seats" name="available_seats" value=$available_seats>

                    <div>Price: $price</div>
                    <input type="hidden" id="price" name="price" value=$price>

                    $button_html
                    <div>______________________________</div><br />
                </form>"
            fi
        
        done
        ;;
    *)
        FILE="html/404.html"
        STATUS="404 Not Found"
        ;;
esac

if [ -f "$FILE" ]; then
    RESPONSE_BODY=$(cat "$FILE")
    RESPONSE_BODY=$(eval "echo \"$RESPONSE_BODY\"")
else
    RESPONSE_BODY="<html><body><h1>404 Not Found</h1></body></html>"
fi

echo "HTTP/1.1 $STATUS\r"
echo "Content-Type: text/html\r"
echo "Connection: close\r"
echo "\r"
echo "$RESPONSE_BODY"
