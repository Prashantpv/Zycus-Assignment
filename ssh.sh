#!/bin/bash                         
          		    # taking comma separated hostnames as user input and saving them in an array with , as Input field separator 
IFS=, read -ra vals <<< $@
echo "Please tell the command that you want to execute  over ssh"


                           # reading the command as an argument 
read command

                           #Iterating the loop on all the hosts so as to make ssh connection and execute the command followed by capturing the output
for i in "${vals[@]}" 
    do
    RESULTS=$(ssh -i /tmp/devops.pem -oStrictHostKeyChecking=no "ubuntu@$i" "$command")
    echo "$i ${RESULTS[@]}"
done

