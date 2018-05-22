#!/bin/bash

# Check that .git and .gituntrack exist
if [ ! -d .git ]; then
    echo "Not a git directory. Exiting gituntrack"; exit 1;
fi
if [ ! -f ./.gituntrack ]; then
    echo "File .gituntrack not found. Exiting gituntrack"; exit 1;
fi

while IFS='' read -r line || [[ -n ${line} ]]; do
    if [ -f ${line} ] || [ -d ${line} ]; then
	# remove file from repository (stop tracking)
	git rm -rf --cached ${line};
	git commit -m "dummy commit to be removed from history"
	# remove file from history
	git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch ${line}" --prune-empty -f HEAD;
	# add file back to repository
	git add ${line};
	git commit -m "Untrack: ${line}";
	echo "Untrack: ${line}";
    else
	echo "${line} is not a valid file or directory"
    fi
done < ./.gituntrack
echo "Clean up..."; git gc;
# git push -f origin master
