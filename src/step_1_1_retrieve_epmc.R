#!/usr/bin/env Rscript

# Author : Kenneth Shackart <Kenneth Shackart@domain.tld>
# Date   : 2021-11-17
# Purpose: Retrieve records from Europe PMC and clean

# Imports -------------------------------------------------------------------

## Library calls ------------------------------------------------------------

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(europepmc))
suppressPackageStartupMessages(library(magrittr))
suppressPackageStartupMessages(library(stringr))

# Argument Parsing ----------------------------------------------------------

#' Parse Arguments
#'
#' Parse command line arguments using argparse.
#'
#' @return args
get_args <- function() {
  parser <-
    argparse::ArgumentParser(description = "Retrieve records from Europe PMC and clean")
  
  parser$add_argument("query",
                      help = "EuropePMC search query",
                      type = "character",
                      metavar = "STR")
  parser$add_argument("-o",
                      "--outdir",
                      help = "Output directory",
                      type = "character",
                      metavar = "DIR",
                      default = "out")
  parser$add_argument(
    "-l",
    "--limit",
    help = "Limit number of returned records",
    metavar = "INT",
    type = "integer",
    default = 25000
  )
  parser$add_argument(
    "-y",
    "--year",
    help = "Cutoff year",
    metavar = "INT",
    type = "integer",
    default = 2010
  )
  
  args <- parser$parse_args()
  
  return(args)
  
}

# Main ----------------------------------------------------------------------

#' Main Function
main <- function() {
  args <- get_args()
  
  query <- args$query
  out_dir <- args$outdir
  
  pmc_seed <- epmc_search(query = query, limit = args$limit) %>% 
    filter(!is.na(id)) %>% 
    filter(pubYear > args$year)
  
  today <- str_replace_all(Sys.Date(), "-", "_")
  out_file <- paste0("pmc_seed_all_", today, ".csv")
  out_path <- file.path(out_dir, out_file)
  
  if (!dir.exists(out_dir)) {
    dir.create(out_dir, recursive = TRUE)
  }
  
  write.csv(pmc_seed, out_path, row.names = FALSE)
  
  print(str_glue("Initial seed saved to {out_path}."))
}

# Call Main -----------------------------------------------------------------
if (!interactive()) {
  main()
}
