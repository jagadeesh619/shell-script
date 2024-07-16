str1="jagadeesh"
count=0

for  (( i=0 ; i<${#str1} ; i++ ));  do
    char=${str1:$i:1}
    if [[ "$char" == "a" || "$char" == "e" || "$char" == "i" || "$char" == "o" || "$char" == "u" ]]; then
        count=$((count+1))
    fi
done

date=$(date)
echo "${date}"
echo "count of vowels is : $count "