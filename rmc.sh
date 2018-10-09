#!/bin/bash
#importing file
source mainLibrary.sh

if [ -z "$1" ] || [ "$1" == "" ]; then
	echo -e "\nPlease call '$1 <argument>' to run this command!\n"
    exit 1
fi

if [ -z "$2" ] || [ "$2" == "" ]; then
	echo -e "\nPlease call '$1 <argument>' to run this command!\n"
    exit 1
	fi
#Get url current repository
urlRespository=$(git remote get-url origin)
currentPath=$(pwd)

create_folders
#Copy repositories
copy_reposity $urlRespository $1 $2
echo "End cloning repository"
echo "Changing to Path:"
cd "$currentPath"
echo $(pwd)
cd "temporaly/firstVersionRepository"
echo "Generate file: listofClassTest.txt in the path" $(pwd)
#Search if realm object has children #recursily until find all
main_method "Object" | class_file_parameters_pipelines > listofClassTest.txt
cd "../.."
cd "temporaly/secondVersionRepository"
echo "Generate file: listofClassTest.txt in the path" $(pwd)
#Search if realm object has children #recursily until find all
main_method "Object" | class_file_parameters_pipelines > listofClassTest.txt
cd "$currentPath"
#Seach if the folder have changed
diff $TEMPORAL_FOLDER/$FOLDER_REPOSITORY_FIRST_COMPARATION_FOLDER"/listofClassTest.txt"  $TEMPORAL_FOLDER/$FOLDER_REPOSITORY_SECOND_COMPARATION_FOLDER"/listofClassTest.txt"
diff $TEMPORAL_FOLDER/$FOLDER_REPOSITORY_FIRST_COMPARATION_FOLDER"/listofClassTest.txt"  $TEMPORAL_FOLDER/$FOLDER_REPOSITORY_SECOND_COMPARATION_FOLDER"/listofClassTest.txt" > diffFile.txt
[[ -s diffFile.txt ]] && exit 1 || exit 0
rm -rfd temporaly
