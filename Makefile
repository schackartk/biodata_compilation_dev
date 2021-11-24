.PHONY: setup_snakemake

setup_snakemake:
  conda create --prefix ./env
  conda activate ./env
  conda install -y -c bioconda -c r snakemake snakefmt r

setup_renv:
  conda activate ./env
  Rscript -e "install.packages('renv')"
  Rscript -e "renv::restore()"
  
