.PHONY: setup_snakemake

setup_snakemake:
  conda create --prefix ./env
  conda activate ./env
  conda install -y -c bioconda snakemake snakefmt
  
