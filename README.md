# MilkSafe - Milk Proteome Evaluation Tool

MilkSafe is a command-line tool for analyzing milk proteome data. It processes protein data from milk and exosome samples and generates UpSet plots to visualize protein intersections.

## Getting Started

These instructions will help you set up and use MilkSafe for your protein analysis.

### Prerequisites

- [R](https://www.r-project.org/)
- R packages: dplyr, UpSetR, ggplot2

### Installation

Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/milksafe.git
```

Usage
Run the milksafe.sh script, providing the required input files and options:
```bash
./milksafe.sh -d protein_database.csv -m milk_sample.txt -e exosome_sample.txt
```
Options
-d <protein table>: Specify the protein database for the analysis.
-m <input file>: Specify the input file containing a protein list (milk sample).
-e <input file>: Specify the input file containing a protein list (exosome sample).
The tool will perform protein analysis and generate output files.

Output
MilkSafe will create several output files, including:

exosome_proteins.tsv: Proteins detected in exosome samples.
milk_proteins.tsv: Proteins detected in milk samples.
miss_exosome_proteins.tsv: Proteins not detected in exosome samples.
miss_milk_proteins.tsv: Proteins not detected in milk samples.
UpSetPlot_exosomes.jpg: UpSet plot for exosome proteins.
UpSetPlot_milk.jpg: UpSet plot for milk proteins.

Author
Margaritis Tsifintaris
Contact: mtsifintaris@gmail.com

Version
Version: 1.0

