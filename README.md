# MilkSafe - Milk Proteome Evaluation Tool

MilkSafe is a versatile command-line tool designed for in-depth analysis of milk proteome datasets. It empowers researchers to seamlessly process protein data extracted from both milk and exosome samples. MilkSafe's comprehensive analysis capabilities enable users to gain valuable insights into protein intersections, and it provides a powerful visualization tool in the form of UpSet plots, making it easier to understand and interpret complex proteomic data.

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
./milksafe.sh -d protein_database.csv -i sample.txt
```
Options
```
-d <protein table>: Specify the protein database for the analysis.
-i <input file>: Specify the input file containing a protein list.
```

The tool will perform protein analysis and generate output files.

### Output
MilkSafe will create several output files, including:

Tables:
```
exosome_proteins.tsv: Proteins detected in exosome samples.
milk_proteins.tsv: Proteins detected in milk samples.
miss_exosome_proteins.tsv: Proteins not detected in exosome samples.
miss_milk_proteins.tsv: Proteins not detected in milk samples.
```
Plots:
```
UpSetPlot_exosomes.jpg: UpSet plot for exosome proteins.
UpSetPlot_milk.jpg: UpSet plot for milk proteins.
```

Author
Margaritis Tsifintaris
Contact: mtsifintaris@gmail.com

Version
Version: 1.0

