#!/bin/bash
sleep 0.2
echo "*****************************************************************************"
echo "                   Welcome to MilkSafe - Milk Proteome Evaluation Tool"
echo "                                Version: 1.0"
echo "*****************************************************************************"
echo ""


while getopts ":i:d:" opt; do
	case $opt in

		i)	      
		input=$OPTARG 
      if [[ -f "$input" ]]; then
			sleep 0.1;
		else
			echo "Error: The specified input file '$input' does not exist or is not accessible."
		fi       
       ;;
       
		d)
		data=$OPTARG 
		if [[ -f "$data" ]]; then
			sleep 0.1;			
		else
			echo "Error: The specified input file '$data' does not exist or is not accessible."
		fi
		;;
		
		*)
		echo "Usage:   milksafe.sh [options]"
		echo ""
		echo "Available Parameters:"
		echo -e "-d <protein table> \t Specify the protein database for the analysis."
		echo -e "-i <input file> \t Specify the input file containing a protein list."
		echo ""
		;;		
	esac  
done

if [ $OPTIND -eq 1 ]; then 
	echo "Usage:   milksafe.sh [options]"
	echo ""
	echo "Available Parameters:"
	echo -e "-d <protein table> \t Specify the protein database for the analysis."
	echo -e "-i <input file> \t Specify the input file containing a protein list."
	echo ""
fi


commands() {

echo "Reading data from: $input"
sleep 0.2;	
echo "The input file contains $(wc -l $input |  cut -d ' ' -f1) lines which are considered as protein entries"
sleep 0.2;	
echo "Reading the protein source data for the analysis: $data"
sleep 0.2;	
echo " - Total proteins in $data: $(wc -l $data | cut -d ' ' -f1)"
sleep 0.2;	

overlap=$(grep -w -f <(tr '-' '_' < $input) <(tr '-' '_' < $data) | tr '_' '-')
other=$(grep -v -w -f <(tr '-' '_' < $input) <(tr '-' '_' < $data) | tr '_' '-')

### calculate exosomic score & n of exosomic proteins
scores=$(echo "$overlap" | awk 'NR>1 { 
	OFS="\t";
	if($6+$7+$8 == 0 && $2+$3+$4+$5 > 0 ) {
		sum += $2+$3+$4+$5;
		total ++ 1;
	}
	}
	END{
	print sum, total;
}')

### Total number of proteins for each species
h=$(awk '{if($2=="1") sum += 1}END{print sum}' $data)
b=$(awk '{if($3=="1") sum += 1}END{print sum}' $data)
g=$(awk '{if($4=="1") sum += 1}END{print sum}' $data)
d=$(awk '{if($5=="1") sum += 1}END{print sum}' $data)


echo "Comparing two files:"
sleep 0.2;	
echo " - Proteins present in both files: $(echo "$overlap" | wc -l)"
echo " - Newly introduced proteins: $(comm -13 <(echo "$overlap" | cut -f1 | sort) <(sort $input) | wc -l)"
sleep 0.2;	

echo " "
echo "---------------------------------------"

echo "$overlap" | awk -v h=$h -v b=$b -v g=$g -v d=$d '{
	OFS="\t";
	human += $2;
	bovine += $3;
	goat += $4;
	donkey += $5;
	}
	END{
	print "Human:", 100*human/h"%   [" human"/"h"]";
	print "Bovine:", 100*bovine/b"%   [" bovine"/"b"]";
	print "Goat:", 100*goat/g"%   [" goat"/"g"]";
	print "Donkey:", 100*donkey/d"%   [" donkey"/"d"]";
	
}'
echo "---------------------------------------"
sleep 0.2;	
proteins_N=$(echo "$overlap" | awk 'NR>1 {
	OFS="\t"; 
	if($2+$3+$4+$5 == 1 && $2 == 1)  {
		human += 1;
	} else
	if($2 == 0 && ($3 == 1 && $4 == 1 && $5 == 1) ) {
		animals_I += 1;
	} else
	if($2 == 0 && ($3 == 1 || $4 == 1 || $5 == 1) ) {
		animals_U += 1;
	}
}
	END {
		print human, animals_U, animals_I;
	}
')

echo " "
echo "Number of detected proteins: "
sleep 0.2;	
echo " - Human-Specific: $(echo "$proteins_N" | cut -f1)"
echo " - Animal-Specific (union): $(echo "$proteins_N" | cut -f2)"
echo " - Animal-Specific (intersection): $(echo "$proteins_N" | cut -f3)"
echo " "
sleep 0.2;	
echo "Proteins characterized as exosomic: $(echo "$scores" | cut -f2)"
echo "Exosomic score: $(echo "$scores" | cut -f1)"
echo " "
sleep 0.1;	
Rscript script.R $data $input

### Extract proteins that are present
echo "Writing a table with proteins detected in exosome samples: exosome_proteins.tsv "
cat \
<(echo "gene	human	bovine	goat	donkey	score") \
<(echo "$overlap" | awk '{OFS="\t"; if($2+$3+$4+$5 >0) print $1, $2, $3, $4, $5, $2+$3+$4+$5}') > exosome_proteins.tsv
sleep 0.1
echo "Writing a table with proteins detected in milk samples: milk_proteins.tsv "
cat \
<(echo "gene	human_milk	bovine_milk	goat_milk	score") \
<(echo "$overlap" | awk '{OFS="\t"; if($6+$7+$8 > 0) print $1, $6, $7, $8, $6+$7+$8}') > milk_proteins.tsv
sleep 0.1

### Extract proteins that are missing
echo "Writing a table with proteins non detected in exosome samples: miss_exosome_proteins.tsv "
cat \
<(echo "gene	human	bovine	goat	donkey	score") \
<(echo "$other" | awk 'NR>1 {OFS="\t"; if($2+$3+$4+$5 > 0) print $1, $2, $3, $4, $5, $2+$3+$4+$5}') > miss_exosome_proteins.tsv
echo "Writing a table with proteins non detected in milk samples: miss_milk_proteins.tsv "
sleep 0.1
cat \
<(echo "gene	human_milk	bovine_milk	goat_milk	score") \
<(echo "$other" | awk 'NR>1 {OFS="\t"; if($6+$7+$8 > 0) print $1, $6, $7, $8, $6+$7+$8}') > miss_milk_proteins.tsv
sleep 0.1

echo ""
echo "*****************************************************************************"
echo "                         $(date)"
echo "*****************************************************************************"
echo ""
}

if [[ -f "$input" && -f "$data" ]]; then
	commands
fi
