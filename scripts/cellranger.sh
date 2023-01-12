#!/bin/bash

#-------------------------------------------------------------------------------------------------------

# Create variables
id=run049
dir=~/ngs/rawdata/$id/Project328
wdir=~/ngs/procdata/$id/cellranger
reference=~/ngs/references/cellranger/mouse/refdata-gex-mm10-2020-A
mkdir -p $wdir/results

# Download reference
cd ~/ngs/references/cellranger/mouse/refdata-gex-mm10-2020-A
wget https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-mm10-2020-A.tar.gz
tar -xzvf refdata-gex-mm10-2020-A.tar.gz

# Download raw data files
#Available under the GEO SuperSeries with accession number GSE200360 (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE200360)
#Under the GEO series with accession number GSE200359 (https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE200359)
#https://www.ncbi.nlm.nih.gov/Traces/study/?query_key=1&WebEnv=MCID_63bec4be39281958e18c09a5&o=acc_s%3Aa

# Install cellranger
cd ~/bin/cellranger
wget -O cellranger-6.0.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-6.0.1.tar.gz?Expires=1620267854&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci02LjAuMS50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2MjAyNjc4NTR9fX1dfQ__&Signature=QF~H4LuL16cBSNWx4N2ldro-OICypVLPj9Ko1asV241w67Y3gnJAKM7cKQouNN1ZO5VHefFmi0wKQrlyObrcfiFGk13Lh3xGHIYw09QWfeCVgec5c6es7OYtPZCD5fTcc~bGRds6iYq9-WkJ3giif~aS2slDIxzT~F6rd1uaNnVlt7gkt2e8rHtmE24uM0kJkU3nOO8Byjsazopkh9ZRI4jRtsrdMNPWQvUUCe34N-mnaB277XE5b~HfUlPGP8GFe6wKok-fcJsgeqXLLbkuZ7zbckyRr0trThl9nIQZUQRC2zBMS~Vp5x-P4GfzEqT4zdXtNPyvj-ZKosuynz8vXQ__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
tar -xzvf cellranger-6.0.1.tar.gz
rm cellranger-6.0.1.tar.gz

# Create the file with the following content under $wdir/run049_design.csv, changing the ids to the NCBI SRR numbers accordingly
#id,name,cells
#SI-GA-C06,CMC-Spleen1,5000
#SI-GA-C07,CMC-Spleen2,5000
#SI-GA-C08,CMC-Spleen3,5000
#SI-GA-C09,CMC-Spleen5,5000
#SI-GA-C10,Lefl-Spleen1,5000
#SI-GA-C11,Lefl-Spleen2,5000
#SI-GA-C12,Lefl-Spleen3,5000
#SI-GA-D01,Lefl-Spleen4,5000

# Define working directory
cd $wdir

#-------------------------------------------------------------------------------------------------------

# Define all samples to be analyzed
samples=($(ls -d $dir/*/ | cut -f8 -d'/'))
samples=($(for i in ${!samples[@]}; do echo ${samples[i]} | cut -d'_' -f1 ; done))
samples=($(printf "%s\n" "${samples[@]}" | sort -u -V))

# Sample annotation (define sample name (donor type, tissue type, replicate)
mapfile -t design < <(tail -n+2 $wdir/run049_design.csv)
names=($(for i in ${!design[@]}; do echo ${design[i]} | cut -d',' -f2 ; done))

# Expected number of cells
cellnumbers=($(for i in ${!design[@]}; do echo ${design[i]} | cut -d',' -f3 ; done))

# Loop through all samples for quantification
for i in ${!samples[@]}; do
	# Define sample details
	sample=${samples[i]}
	name=${names[i]}
	cellnumber=$(echo ${cellnumbers[i]} | tr -d '\r')
	# Quantify samples with cellranger
	echo "${tis} : CellRanger quantification of sample ${sample} - ${name} started"
	cellranger count --id=$name \
		--transcriptome=$reference \
		--fastqs=$dir \
		--sample=$name \
		--expect-cells=$cellnumber \
		--chemistry=auto \
		--jobmode=local \
		--localcores=16 \
		--localmem=28 #0.9*totalmem
		
	tie=$(date)
	echo "${tie} : CellRanger quantification of sample ${sample} - ${name} finished"
done

#-------------------------------------------------------------------------------------------------------
