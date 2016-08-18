#!/bin/sh
SOURCE_FILE=$1
perl -p -e 's/\"/\\"/g;' "${SOURCE_FILE}"            |  # Escape of "
perl -p -e 's/^(.*)$/"\1\\n",/g;'                    ;  # Add a " at the beginning of each lines + Add a " at the end of each lines \n",
echo '""'  
