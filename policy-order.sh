#!/bin/bash

## Populate parameter 4 with the policy IDs or their custom triggers
## Add them in the exact order (first to last) that you want them to run in

## Check to make sure we received at least one item in parameter 4
if [ -z "$4" ]; then
    echo "No items were passed to parameter 4. Add at least one or more policy ids and/or custom triggers to it for this script to work."
    exit 1
fi

## Add Param 4 to a POLICY_IDS array
POLICY_IDS=($4)
POLICY_COUNT=$(echo ${#POLICY_IDS[*]})
DEPLOG="/var/tmp/depnotify.log"

if [[ -e "${DEPLOG}" ]]; then
    	rm -rf ${DEPLOG}
    else
		echo "Command: DeterminateManual: ${POLICY_COUNT}" >> ${DEPLOG}
		echo "Staus: Parsing ${POLICY_COUNT} Policies" >> ${DEPLOG}
    fi


## Establish a pattern to check for integer or standard string
patt='^[0-9]+$'

## Loop over the IDS/triggers and...
while read POLICY_ID; do
    ## check each to see if it's an integer or a string
    if [[ "$POLICY_ID" =~ $patt ]]; then
        ## If an integer, set the trigger to -id
        TRIG="-id"
    else
        ## If a string, set the trigger to -event
        TRIG="-event"
    fi
    ## Run the policy
    /usr/local/bin/jamf policy $TRIG $POLICY_ID
done < <(printf '%s\n' "${POLICY_IDS[@]}")
/bin/sleep 5
echo "Command: Quit" >> ${DEPLOG}
exit 0
