#!/bin/bash

# create a folder for all the results
folder=seedsSafeLists
#rm -r $folder
#mkdir $folder

echo 'Start extracting the lists'
echo "Extracting set 1"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out1.txt >> logger_03102020_1.txt
echo "Extracting set 2"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out2.txt >> logger_03102020_2.txt
echo "Extracting set 3"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out3.txt >> logger_03102020_3.txt
echo "Extracting set 4"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out4.txt >> logger_03102020_4.txt
echo "Extracting set 5"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out5.txt >> logger_03102020_5.txt
echo "Extracting set 6"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out6.txt >> logger_03102020_6.txt
echo "Extracting set 7"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out7.txt >> logger_03102020_7.txt
echo "Extracting set 8"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out8.txt >> logger_03102020_8.txt
echo "Extracting set 9"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out9.txt >> logger_03102020_9.txt
echo "Extracting set 10"
./RSS3_1_extract_mustBsafe_list.sh gcc-7 ../../Data/seeds_good/seeds_out10.txt >> logger_03102020_10.txt
