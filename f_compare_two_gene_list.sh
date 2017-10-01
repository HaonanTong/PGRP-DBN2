############################################
# Analysis of two gene list
# Nan
# @PGRP
############################################
# chmod -x f_compare_two_gene_list.sh
# f_compare_two_gene_list.sh ANan-DEGs.txt EIN3-R.txt OverProfiles kat-rpkm-expression.csv 

echo "############################################"
echo Totally $# arguments input: $@
if [ "$#" != "3" ] && [ "$#" != "4" ]; then
    echo "Error: illegal number of parameters!"
    echo -e "Should be 3 or 4 arguments!\n \
    \$1 and \$2: Two gene lists of interest(without header)\n \
    \$3: Mode of comparison(\"Overlapping\",\"Exhausted Analyzing\",\"OverProfiles\")\n \
    Optional input \$4: Expression Profile(.csv with header)"
    echo -e "Example:\n \
     f_compare_two_gene_list.sh ANan-DEGs.txt EIN3-R.txt OverProfiles kat-rpkm-expression.csv "
    echo Exiting...
    echo "############################################"

    exit
fi

echo Two gene list file $1 and $2 
echo Comparison in mode of \"$3\"
echo Initializing...

str1=`echo $1 | awk -F. '{print $1}'`;
str2=`echo $2 | awk -F. '{print $1}'`;
str3=$3;

if [ "$str3" == "Overlapping" ] || [ "$str3" == "OverProfiles" ]; then
	echo "Analyzing two gene files for Overlapping genes"
fi

if [ "$str3" == "Exhausted Analyzing" ]; then
	echo "Analyzing two gene files in any possible perspectives";
fi

str="$str1-$str2"

cat $1 | sort -u > file1_sorted_tmp;
cat $2 | sort -u > file2_sorted_tmp;
# # of genes in list1
awk 'END{print NR}' file1_sorted_tmp > "Num-$str1.txt";
echo "Number of genes in list1: `awk 'END{print NR}' file1_sorted_tmp`"

# # of genes in list2 
awk 'END{print NR}' file2_sorted_tmp > "Num-$str2.txt";
echo "Number of genes in list2: `awk 'END{print NR}' file2_sorted_tmp`"

# genes Overlapping
GeneOverlappingfile="Genes-Overlapping-$str.txt"
echo -e "Exporting overlapping genes of two files into \n$GeneOverlappingfile ..."
grep -f file1_sorted_tmp file2_sorted_tmp | sort -u > tmp;
sed -E 's/[[:space:]]+//g' tmp > "$GeneOverlappingfile"
rm tmp
echo "Success!"


GeneOverlappingNumfile="Num-Genes-Overlapping-$str.txt"
echo -e "Exporting overlapping genes of two files into \n$GeneOverlappingNumfile ..."
awk 'END{print NR}' "Genes-Overlapping-$str.txt" > "$GeneOverlappingNumfile"
echo "Number of overlapping genes: `awk 'END{print NR}' "Genes-Overlapping-$str.txt"`"

if [ "$str3" == "OverProfiles" ]; then
	echo "Extracting profiles of Overlapping genes..."
	head -1 $4 > "Profiels-Overlapping-$str.csv"
	grep -f "$GeneOverlappingfile" $4 >> "Profiels-Overlapping-$str.csv"
	nl=`wc -l < "Profiels-Overlapping-$str.csv"`
	count=$((nl-1))
	echo Number of profiles extracted: $count
fi

echo "Success!"

###########################################################################
########################## More Tedious Analysis ##########################
###########################################################################
if [ "$str3" != "Exhausted Analyzing" ]; then
	rm file1_sorted_tmp
	rm file2_sorted_tmp
	echo Exiting...
	echo Done!
	echo "############################################" 
	exit;
fi

# in list1 not list 2
     	# diff -f "Genes-Overlapping-$str.txt" file1_sorted_tmp > tmp
     	# awk '{if ($2 ~/AT/) print $2}' tmp |sort -u > "Genes-$str1-Not-$str2.txt"
grep -v -f "Genes-Overlapping-$str.txt" file1_sorted_tmp > "Genes-$str1-Not-$str2.txt"
		#rm tmp
awk 'END{print NR}' "Genes-$str1-Not-$str2.txt" > "Num-Genes-$str1-Not-$str2.txt"


# in list2 not list1
#  diff -f "Genes-Overlapping-$str.txt" $2 > tmp
#	awk '{if ($2 ~/AT/) print $2}' tmp |sort -u > "Genes-$str2-Not-$str1.txt"
#	rm tmp
#	awk 'END{print NR}' "Genes-$str2-Not-$str1.txt" > "Num-Genes-$str2-Not-$str1.txt"
grep -v -f "Genes-Overlapping-$str.txt" file2_sorted_tmp > "Genes-$str2-Not-$str1.txt"
#rm tmp
awk 'END{print NR}' "Genes-$str2-Not-$str1.txt" > "Num-Genes-$str2-Not-$str1.txt"
rm file1_sorted_tmp
rm file2_sorted_tmp

