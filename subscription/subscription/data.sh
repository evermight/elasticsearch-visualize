#!/bin/bash

startYear=2020
startMonth=4
numberOfMonths=36
numberOfCustomers=3

for ((c=0; c<$numberOfCustomers; c++))
do
  for ((d=0; d<$numberOfMonths; d++))
  do
    currentMonth=$(printf "%02d" $(((($startMonth+$d)%12)+1)))
    currentYear=$(($startYear+($startMonth+$d)/12))
    echo "$c - $currentYear-$currentMonth"
  done
done
