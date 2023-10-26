#!/bin/bash
sleep 0.2
echo "*****************************************************************************"
echo "                   Welcome to MilkSafe - Milk Proteome Evaluation Tool"
echo "                                Version: 1.0"
echo "*****************************************************************************"
echo ""


while getopts ":m:e:d:" opt; do
	case $opt in
  
		m)
		sleep 0.2      
       inputM=$OPTARG 
       if [[ -f "$inputM" ]]; then
			echo "Reading data from: $inputM"
			echo "The input file contains $(wc -l $inputM |  cut -d ' ' -f1) lines which are considered as protein entries"
		else
			 echo "Error: The specified input file '$inputM' does not exist or is not accessible."
		fi
       ;;
       
		e)
		sleep 0.2       
       inputE=$OPTARG 
       if [[ -f "$inputE" ]]; then
			echo "Reading data from: $inputE"
			echo "The input file contains $(wc -l $inputE |  cut -d ' ' -f1) lines which are considered as protein entries"
		else
			 echo "Error: The specified input file '$inputE' does not exist or is not accessible."
		fi       
       ;;
       
		d)
		sleep 0.2
		data=$OPTARG 
		if [[ -f "$data" ]]; then
			echo "Reading the protein source data for the analysis: $data"
			
		else
			 echo "Error: The specified input file '$data' does not exist or is not accessible."
		fi
 
       ;;       
		*)
		echo " "
		echo "Usage:   milksafe.sh [options]"
		echo ""
		echo "Available Parameters:"
		echo -e "-d <protein table> \t Specify the protein database for the analysis."
		echo -e "-m <input file> \t Specify the input file containing a protein list (milk sample)."
		echo -e "-e <input file> \t Specify the input file containing a protein list (exosome sample)."
		echo ""
       ;;
	esac
  
done

### Total number of proteins for each species
h=$(awk '{if($2=="1") sum += 1}END{print sum}' $data)
b=$(awk '{if($3=="1") sum += 1}END{print sum}' $data)
g=$(awk '{if($4=="1") sum += 1}END{print sum}' $data)
d=$(awk '{if($5=="1") sum += 1}END{print sum}' $data)

#echo "$h $b $g $d"
echo " "
grep -w -f $inputE $data | awk -v h=$h -v b=$b -v g=$g -v d=$d '{
	OFS="\t";
	human += $2;
	bovine += $3;
	goat += $4;
	donkey += $5;
	}
	END{
	print "Human:", human"/"h" " , "---> " 100*human/h"%";
	print "Bovine:", bovine"/"b , "---> " 100*bovine/b"%";
	print "Goat:", goat"/"g" " , "---> " 100*goat/g"%";
	print "Donkey:", donkey"/"d" " , "---> " 100*donkey/d"%";
	
}'

echo " "

Rscript script.R $data $inputE

### Extract proteins that are present
echo "Writing a table with proteins detected in exosome samples: exosome_proteins.tsv "
cat \
<(echo "gene	human	bovine	goat	donkey	score") \
<(grep -w -f $inputE $data | awk '{OFS="\t"; if($2+$3+$4+$5 >0) print $1, $2, $3, $4, $5, $2+$3+$4+$5}') > exosome_proteins.tsv
sleep 0.1
echo "Writing a table with proteins detected in milk samples: milk_proteins.tsv "
cat \
<(echo "gene	human_milk	bovine_milk	goat_milk	score") \
<(grep -w -f $inputE $data | awk '{OFS="\t"; if($6+$7+$8 > 0) print $1, $6, $7, $8, $6+$7+$8}') > milk_proteins.tsv
sleep 0.1

### Extract proteins that are missing
echo "Writing a table with proteins non detected in exosome samples: miss_exosome_proteins.tsv "
cat \
<(echo "gene	human	bovine	goat	donkey	score") \
<(grep -w -v -f $inputE $data | awk 'NR>1 {OFS="\t"; if($2+$3+$4+$5 > 0) print $1, $2, $3, $4, $5, $2+$3+$4+$5}') > miss_exosome_proteins.tsv
echo "Writing a table with proteins non detected in milk samples: miss_milk_proteins.tsv "
sleep 0.1
cat \
<(echo "gene	human_milk	bovine_milk	goat_milk	score") \
<(grep -w -v -f $inputE $data | awk 'NR>1 {OFS="\t"; if($6+$7+$8 > 0) print $1, $6, $7, $8, $6+$7+$8}') > miss_milk_proteins.tsv
sleep 0.1

echo ""
echo "*****************************************************************************"
echo "                         Thu 26 Oct 2023 03:04:34 EEST"
echo "*****************************************************************************"
echo ""

