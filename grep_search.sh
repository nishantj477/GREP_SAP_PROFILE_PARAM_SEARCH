# Program written by Nishant Joshi (R63056).
#This program searches for the patterns in files.
#Inputs
#1. Multiline File that has the pattern(s) to be searched. One pattern per line.
#2. number of files that need to be searched for the pattern with their absolute/relative path.
#Output
#Text file with details of the search. Location of the output file is: $HOME/output_file-$current_date.txt

#!/usr/bin/env bash
current_date=$(date +"%Y-%m-%d-%H:%M:%S")
output_file="$HOME/output_file-$current_date.txt"
search_files=""

# Function to validate file existence
validate_file_existence() {
    local file_path="$1"

    while [ ! -e "$file_path" ]; do
        echo "File does not exist: $file_path"
        echo "Enter a valid file path/file, or press Ctrl+Z to exit."
        read -p "Enter valid file: " file_path
    done
    
    if [ $flag -eq 1 ]; then
        pattern_file=$file_path
    else
    	file_input=$file_path
    fi
}

read -p "Enter the file that has the pattern(s) to be searched: " pattern_file
flag=1
validate_file_existence "$pattern_file"

read -p "Enter the number of file(s) you want to search for the pattern(s): " num_files
# read the files and validate their existence.
flag=2
for i in $(seq 1 $num_files); do
    read -p "Enter file$i: " file_input
    validate_file_existence "$file_input"
    search_files+="$file_input "
done

echo -e "\nThe output file is: $output_file"
echo -e "\n\nPattern file is: $pattern_file" | tee -a $output_file
echo -e "\nFiles to search are: $search_files\n" | tee -a $output_file

total=0
found=0
not_found=0
found_list=()
notfound_list=()
for param in $(cat $pattern_file); do
 ((total++))
 echo "$total. Searching parameter: "$param"" | tee -a $output_file
# output=$(grep -iln "$param" $profile_file1 $profile_file2 $profile_file3)
 output=$(grep -iln "$param" $search_files)
 output_length=${#output}
 if [ $output_length -lt 1 ]; then
     echo ""$param" not found." | tee -a $output_file
     notfound_list+=("$param")
     ((not_found++))
 else
     echo -e ""$param" found.\n$output" | tee -a $output_file
     found_list+=("$param"" in: \n""$output""\n*****************")
     ((found++))
 fi
echo "............................" | tee -a $output_file
done

echo -e "\n\n*****************************************************************
**********SUMMARY************************************************
*****************************************************************" | tee -a $output_file
echo -e "\nTotal $total parameters were searched." | tee -a $output_file
echo -e "$found parameters found." | tee -a $output_file
echo -e "$not_found parameters not found." | tee -a $output_file

echo "............................" | tee -a $output_file
echo -e "PARAMETERS FOUND ARE:\n*************" | tee -a $output_file
for item in "${found_list[@]}"; do
    #echo -e "******************" | tee -a $output_file
    echo -e "$item" | tee -a $output_file
    #echo -e "******************" | tee -a $output_file
done

echo "............................" | tee -a $output_file
echo -e "PARAMETERS NOT FOUND ARE:" | tee -a $output_file
for item in "${notfound_list[@]}"; do
    echo -e "$item" | tee -a $output_file
done
echo -e "\nThe output file is: $output_file"
