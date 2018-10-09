#!/bin/bash

#######################################
# Global variable

# Description:
#   TEMPORAL_FOLDER: Folder to save temporaly repositories
#   FOLDER_REPOSITORY_FIRST_COMPARATION_FOLDER: 
#   FOLDER_REPOSITORY_SECOND_COMPARATION_FOLDER: 
# Returns:
#   None
#######################################
readonly TEMPORAL_FOLDER="temporaly"
readonly FOLDER_REPOSITORY_FIRST_COMPARATION_FOLDER="firstVersionRepository"
readonly FOLDER_REPOSITORY_SECOND_COMPARATION_FOLDER="secondVersionRepository"

#output main class of object
####################################### 
#Show all children class of current class

# Arguments:
#   $1: Name of class to extract
# Returns:
#   None
#######################################
children_class() {
	class_to_search_childrens=""
	if [ -z "$1" ] || [ $1 == "" ]; then
    	class_to_search_childrens="Object"
    else 
    	class_to_search_childrens=$1
	fi
	find . -iname "*.swift" -exec grep 'class \w*: '$class_to_search_childrens {} \; | cleanHeaderOfClassFromPipeline $1
}

##########################################################

####################################### 
#filter line of class to object name

# Arguments:
#   $1: string with line definition class
#   $2:	name of class to extract
# Returns:
#   None
#######################################
cleanHeaderOfClass() {
	clasToRemplace="Object"

	if [ -z "$1" ] || [ "$1" == "" ]; then
    	echo -e "\nPlease call '$1 <argument>' to run this command!\n"
    	exit 1
	fi

	if [ -z "$2" ] || [ $2 == "" ]; then
    	classToRemplace="Object"
    else
    	classToRemplace=$2
	fi
	string_to_filter=$1
	string_to_filter=${string_to_filter#'open '}
	string_to_filter=${string_to_filter#'public '}
	string_to_filter=${string_to_filter#'class '}
	string_to_filter=${string_to_filter#'final '}
	string_to_filter=${string_to_filter#'extension '}
	string_to_filter=${string_to_filter#'class '}
	
	
	# string_to_filter=${string_to_filter%': '$classToRemplace' {'}
	# string_to_filter=${string_to_filter%': '$classToRemplace', Mappable {'}
	# string_to_filter=${string_to_filter%': '$classToRemplace', Searchable, Mappable {'}
	# string_to_filter=${string_to_filter%': '$classToRemplace', Searchable {'}
	# string_to_filter=${string_to_filter%': '$classToRemplace', Searchable {'}
	string_to_filter=${string_to_filter//: [a-zA-Z]*/}
	echo $string_to_filter
}

cleanHeaderOfClassFromPipeline() {
	#read from pipeline 
	while read data; do
      cleanHeaderOfClass "$data" $1
  	done
}
####################################### 
#Show stout hashsum and path of class passed by parameters

# Arguments:
#   $1: class to search shasum and path
# Returns:
#   None
#######################################
class_file_parameters() {
	if [ -z "$1" ]; then
    	echo -e "\nPlease call '$1 <argument>' to run this command!\n"
    	exit 1
	fi
	output=$(find . -iname "*.swift" | tr '\n' '\0' | xargs -0 grep 'class '$1': ')
	if [[ $output == "" ]]; then
 		echo "hasNotClass"
 	else 
 		shasum5.18  "$(echo $output |  cut -d ':' -f1 )"
 	fi
}
####################################### 
#Enable pipeline form method class_file_parameters

# Arguments:
#   read from stins
# Returns:
#   None
#######################################
class_file_parameters_pipelines() {
	while read data; do
      clases=$data
      class_file_parameters "$clases"
  	done
}

##########################################################

#######################################
#Display list of class hiearchy

# Arguments:
#   $1: class to search hiearchy
# Returns:
#   None
#######################################
main_method() {
	if [ -z "$1" ] || [ $1 == "" ]; then
		echo "entré vide"
		echo -e "\nPlease call '$1 <argument>' to run this command!\n"
    	exit 1
	fi
	childrenClassList=$(children_class $1)
	echo $1
	if [[ -n $childrenClassList ]]; then
		for i in $(echo $childrenClassList | tr " " "\n")
		do
	  		main_method $i
		done
	fi
}

#######################################
#Donwload create folder and dowload repositories

# Arguments:
#   $1: url to clone project
#   $2: sha of commit 1
#   $3: sha of commit 2
# Returns:
#   None
#######################################
copy_reposity() {
	if [ -z "$1" ]; then
    	echo -e "\nPlease call '$1 <argument>' to run this command!\n"
    	exit 1
	fi

	if [ -z "$2" ]; then
    	echo -e "\nPlease call '$2 <argument>' to run this command!\n"
    	exit 1
	fi

	if [ -z "$3" ]; then
    	echo -e "\nPlease call '$3 <argument>' to run this command!\n"
    	exit 1
	fi
	cd $TEMPORAL_FOLDER/$FOLDER_REPOSITORY_FIRST_COMPARATION_FOLDER
	clone_and_checkout_respository $1 $2
	cd ../../..
	cd $TEMPORAL_FOLDER/$FOLDER_REPOSITORY_SECOND_COMPARATION_FOLDER
	clone_and_checkout_respository $1 $3
	cd ../../..
}

#######################################
# Clone and checkout repository git

# Arguments:
#   $1: repository to commit
#   $2: commit sha string
# Returns:
#   None
#######################################
clone_and_checkout_respository() {
	if [ -z "$1" ]; then
    	echo -e "\nPlease call '$1 <url commit>' to run this command!\n"
    	exit 1
	fi
	if [ -z "$2" ]; then
    	echo -e "\nPlease call '$2 <argument>' to run this command!\n"
    	exit 1
	fi
	git clone $1
	cd *
	git checkout $2
}

#######################################
# Create folder necesary to develop script
# Returns:
#   None
#######################################
create_folders() {
	rm -rfd $TEMPORAL_FOLDER
	mkdir -p $TEMPORAL_FOLDER/{$FOLDER_REPOSITORY_FIRST_COMPARATION_FOLDER,$FOLDER_REPOSITORY_SECOND_COMPARATION_FOLDER}
}
