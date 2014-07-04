#!/bin/bash
#created by black @ LET
#MIT license, please give credit if you use this for your own projects
#A modification to the original sendmail script, this takes a file name as the 3rd argument
#depends on curl

key="" #your maildrill API key
from_email="" #who is sending the email
reply_to="$from_email" #reply email address
from_name="curl sender" #from name

if [ $# -eq 3 ]; then
	while read -r line
	do
    		content="$content$line\n";
	done < "$3"
	
	msg='{ "async": false, "key": "'$key'", "message": { "from_email": "'$from_email'", "from_name": "'$from_name'", "headers": { "Reply-To": "'$reply_to'" }, "return_path_domain": null, "subject": "'$2'", "text": "'$content'", "to": [ { "email": "'$1'", "type": "to" } ] } }'

	results=$(curl -A 'Mandrill-Curl/1.0' -d "$msg" 'https://mandrillapp.com/api/1.0/messages/send.json' -s 2>&1);
	echo "$results" | grep "sent" -q;
	if [ $? -ne 0 ]; then
		echo "An error occured: $results";
		exit 2;
	fi
else
echo "$0 requires 3 arguments - to address, subject, content";
echo "Example: ./$0 \"to-address@mail-address.com\" \"test\" \"somefile.txt\""
exit 1;
fi
