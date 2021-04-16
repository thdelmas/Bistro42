#!/bin/bash

while [ ! "$login" ]
do
printf "What's your login ?    "
read login
done
echo Welcome $login '!'
