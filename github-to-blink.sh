#!/bin/bash
# Makes your Blink(1) blink when a commit happens to a repository 
#
# Note: Requires curl

BLINK=`which blink1-tool`

COLOR_PASS="0,200,50" # Mostly green

SLEEPTIME=10  # Time to wait between checking git
let COUNT=10  # Num of times to blink

# Inspired by the gmail example
cleanup()
{
    # Turn the Blink(1) off
    $BLINK --off > /dev/null 2>&1
    exit $?
}
trap cleanup SIGINT SIGTERM

while true; do
    resp=$(curl -s https://gerrit.wikimedia.org/r/changes/?q=(+project:mediawiki/extensions/Wikibase+OR+project:mediawiki/extensions/Diff+OR+project:mediawiki/extensions/DataValues+OR+project:mediawiki/extensions/WikibaseSolr+OR+project:mediawiki/extensions/Ask+)+status:merged+-age:10s&n=1)
    if (("${#resp}">25))
    then
        echo "Commit found!"
        $BLINK --rgb $COLOR_PASS --blink $COUNT > /dev/null 2>&1
        #$BLINK --random $COUNT > /dev/null 2>&1
    else
        echo "Waiting..."
        $BLINK --off > /dev/null 2>&1
        sleep $SLEEPTIME
    fi
done
