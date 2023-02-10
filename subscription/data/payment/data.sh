#!/bin/bash

earliestSignupYear=2020
earliestSignupMonth=4
signupDurationMonths=13
maximumActiveMonths=36
numberOfCustomers=234

echo 'subscriber_id,pay_date' > data.csv
for ((c=1; c<=$numberOfCustomers; c++))
do
  signupMonth=$(($earliestSignupMonth+($signupDurationMonths-$earliestSignupMonth)*$RANDOM/32767))
  activeMonths=$(($maximumActiveMonths*$RANDOM/32767))
  for ((d=0; d<$activeMonths; d++))
  do
    currentMonth=$(printf "%02d" $(((($signupMonth+$d)%12)+1)))
    currentYear=$(($earliestSignupYear+($signupMonth+$d)/12))
    echo "$c,$currentYear-$currentMonth-01" >> data.csv
  done
done
