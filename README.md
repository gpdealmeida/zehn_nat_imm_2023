## Description

This repository provides the code used for processing and analysis of NGS data[^1], as well as for generation of related figures for the puplication:

*"Scherer et al. Pyrimidine de novo synthesis inhibition selectively blocks effector but not memory T-cell development. Nat Imm 2023".*

<br>

## Usage

### Bulk RNA-Seq analysis

- **Step 1:** To generate the read counts table run [bulkSeqPipe](https://gitlab.lrz.de/ImmunoPhysio/bulkSeqPipe/) using as input the configuration file[^2] available [here](https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE200358&format=file&file=GSE200358%5Fconfig%2Eyaml%2Egz).[^3]

- **Step 2:** To perform DEG analysis and reproduce **Figure3A-D** run the script *bulk.Rmd*.

  `Rscript -e "rmarkdown::render('bulk.Rmd')"` [^2]

### SCRB-Seq analysis

- **Step 1:** To generate the table with read counts per cell run [dropSeqPipe](https://hoohm.github.io/dropSeqPipe/) using as input the configuration file[^2] available [here](https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE200359&format=file&file=GSE200359%5Fconfig%2Eyaml%2Egz).[^3]

- **Step 2:** To perform the single cells analysis and reproduce **Figure5A,C**, **Figure6A-C** and **ExtData9A-C** run the script *scrbseq.Rmd*.

  `Rscript -e "rmarkdown::render('scrbseq.Rmd')"` [^2]

### 10xGenomics analysis

- **Step 1:** To generate the table with read counts per cell run the script *cellranger.sh*: `cellranger.sh` [^2]

- **Step 2:** To perform the single cells analysis and reproduce **ExtData10A-B,D-G** run the script *10xgenomics.Rmd*.

  `Rscript -e "rmarkdown::render('10xgenomics.Rmd')"` [^2]

<br>

[^1]: *All the raw sequencing files and the respective processed data can be retrieved from the GEO database under the SuperSeries with accession number [GSE200488](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE200360).*

[^2]: *To run locally the configuration files and the scripts provided here must be modified accordingly to be adapted to the system settings.*

[^3]: *__Step 1__ can be skipped, as the processed data is available at the GEO database.*
