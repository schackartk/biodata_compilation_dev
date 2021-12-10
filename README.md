# Biodata Collection

Repository for the project of Dr. Heidi Imker, collecting information about the current biodata databases.

## Getting Set Up

This project utilizes anaconda and renv to manage dependencies.

Set up the conda environment:

```
conda create --prefix ./env
conda activate ./env
conda install -c bioconda snakemake snakefmt
```

Install R package dependencies:

```
Rscript -e "install.packages('renv')"
Rscript -e "renv::restore()"
```

## Project structure

Here is a topographical map of the structure of this repository.

```
.
├── .git
├── .gitignore
├── .Rprofile
├── bin/                 # Helpful scripts, not directly related to the project
├── config/              # Configuration files
├── data/                # Raw and processed data
├── figures/             # Figures generated by code
├── gbc_project.Rproj
├── renv/               # Packrat environment for dependency management
├── README.md
├── src/                 # Source code
└── tests/               # Integration tests
```

## renv

Since this project utilizes renv, dependencies are tracked in the renv.lock file. They can be installed with `renv::restore`, or using the make target `make setup_renv`

To keep the snapshot up-to-date, run `renv::snapshot()` after installing new packages. The status can be checked with `renv::status()`.

## Snakemake

To see what jobs need to be run, use the dry run argument:

```
snakemake -np --configfile config/snake_config.yml
```

The pipeline can be run with:

```
snakemake --cores 1 --configfile config/snake_config.yml
```

## Testing

There are tests for the parameterized R scripts. The full test suite can be run with:

```
make test
```


## Authorship

Dr. Heidi Imker, Principal Investigator <hjimker@gmail.com>

Kenneth Schackart, Data Scientist <schackartk1@gmail.com>
