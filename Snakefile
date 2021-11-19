rule all:
  input:
    config["out_dir"] + "/raw/pmc_seed_all_2021_11_18.csv",
    
rule query_eurpopmc:
  output:
    config["out_dir"] + "/raw/pmc_seed_all_2021_11_18.csv",
  params:
    query=config["europepmc_query"],
    run=config["step_1_1_script"],
    out_dir=config["out_dir"]
  shell:
  """
  source activate ./env
  Rscript -e "source('packrat/init.R')"
  
  {params.run} -o {params.out_dir}/raw {params.query}
  """