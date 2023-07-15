#!/bin/bash

whoami
date

#####################################################Function Bodies######################################
# A function to display the date and time
getCurrentDate() {
  # Display the current date and time
  today=$(date +"%m-%d-%y")
  echo -e "Today's date: $today"
}

# A function to display the IP addresses and ports on this machine
getIpPorts() {
  # Display private IP address using hostname
  echo -e "My private IP address: "
  hostname -I

  # Display public IP address using ifconfig.me
  echo -e "\nMy public IP address: "
  curl ifconfig.me

  # Disply open ports using nmap
  echo -e "\nOpen ports: "
  nmap scanme.nmap.org
  echo -e "\n"
}

# A function to encrypt and decrypt a string usng a simple Caesar cipher. Modified to take in any right/left shift from 1-10
cipher() {
  while :; do  # loop structure to validate user input. Numeric and Range checks
    read -p "Enter a number from 1-10 (inclusive): " number  # user input for a number between 1-10
    [[ $number =~ ^[0-9]+$ ]] || { echo "Enter a valid number"; continue; }  # use regex to ensure input is numeric
    if ((number >= 1 && number <= 10)); then  # range check
      # User input shift<<right>> for the Caesar Cipher.  Limit to 10 for this exercise.
      setRightShiftPositions
      # Shift <<left>> for the Caesar Cipher.
      setLeftShiftPositions
      break  # leave the loop structure.  Input is valid
    else
      echo "number out of range, try again"  # notify user to try again
    fi
  done  # end of loop structure

  # Calling cipher function
  echo -e "We will ask the user for a string, and then encrypt/decrypt that string.\n"  # echo instructions
  run=true  # setting a loop control variable
  while $run; do  # begin loop structure with control variable 
    read -p "Let's encrypt a string!  Enter a string of your choice (or '0' to quit): " input # prompt user input
    if [[ "$input" == "0" ]]; then #  check if a "0" was entered
      echo "Thank you!  Bye!!"  # then echo an exit message
      run=false  # set loop control variable to false to exit the loop structure
    else
      encryptDecryptInput  # call function to do the encrypt/decrypt work
    fi done   # end
}

# Capture right shift positions for start/end positions
setRightShiftPositions() {
  chars=( {a..z} )  # load alphabet into an array
  for ((i=number-1; i<=number; i++))  # 'for' loop structure. Only letters needed for Casesar Cipher are the letters at 'index' and 'index+1'
  do
    a1[i]=${chars[i]}  # save to array. Will use only two array locations
  done
  echo -e "\nShift Right Start: '${a1[number-1]}', Shift Right End: '${a1[number]}'"  # check the two array locations
}

# Capture left shift positions for start/end positions
setLeftShiftPositions() {
  srahc=( {z..a} )  # load reverse alphabet into an array
  for ((i=number-1; i<=number; i++))  # 'for' loop structure. Only letters neede for Caesar Cipher are the letters at 'index' and 'index-1'
  do
    a2[i]=${srahc[i]}  # save to array. Will use only two array locations
  done
  echo -e "Shift Left  Start: '${a2[number-1]}', Shift Left  End: '${a2[number]}'\n"  # check the two array locations
}

encryptDecryptInput() {
  # Function for encrypting/decrypting the input. Will do a Caesar cipher of shift right <<number>>  via regex pattern
  # and do a translation of the input string then pipe it to the regex
  # then decrypt of shift left <<number>> via translation pattern

  p1=${a1[number]}    # start pos right shift
  p2=${a1[number-1]}  # end   pos right shift
  q1=${a2[number]}    # start pos left  shift
  q2=${a2[number-1]}  # end   pos left  shift

  # Note:  The '^^' characters will be used to do an uppercase, where needed
  encrypted=$(echo "$input" | tr 'a-zA-Z' ${p1}'-za-'${p2}${p1^^}'-ZA-'${p2^^}) decrypted=$(echo "$encrypted" | tr 'a-zA-Z' ${q2}'-za-'${q1}${q2^^}'-ZA-'${q1^^})
  echo "Encrypted: $encrypted"  # echo encrypted input
  echo "Decrypted: $decrypted"  # echo decrypted input
}

#####################################################Function Calls#######################################
# Displays the formatted date and time
getCurrentDate

# Displays public/private IP addresses and ports in use
getIpPorts

# Encrypts and decrypts a user string
cipher
