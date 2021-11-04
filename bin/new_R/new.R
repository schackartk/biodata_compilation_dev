#!/usr/bin/env Rscript

# Author : Kenneth Schackart <schackartk1@gmail.com>
# Date   : 2021-09-30
# Purpose: Create Rscript template

# Library Calls  ------------------------------------------------------------

library(argparse)
library(stringr)


# Argument Parsing ----------------------------------------------------------

#' Parse Arguments
#'
#' Parse command line arguments using argparse.
#'
#' @return args
get_args <- function() {
  parser <- argparse::ArgumentParser(description = "Create a new R file")
  
  rc_file <- file.path(fs::path_home(), ".new.R")
  defaults <- get_defaults(rc_file)
  
  parser$add_argument("program",
                      metavar = "PRG",
                      help = "New R file name",
                      type = "character")
  parser$add_argument("-n",
                      "--name",
                      help = "Name for docstring",
                      type = "character",
                      default = defaults$name)
  parser$add_argument("-e",
                      "--email",
                      help = "Email address",
                      type = "character",
                      default = defaults$email)
  parser$add_argument("-p",
                      "--purpose",
                      help = "Purpose of program",
                      type = "character",
                      default = defaults$purpose)
  parser$add_argument("-f",
                      "--force",
                      help = "Overwrite existing",
                      action = "store_true")
  
  
  args <- parser$parse_args()
  
  args$program <-  stringr::str_replace(
    stringr::str_trim(args$program),
    "-", "_")
  
  if (nchar(args$program) == 0) {
    stop(stringr::str_glue("Not a usable filename '{args$program}'"))
  }
  
  return(args)
  
}

# Main ----------------------------------------------------------------------

#' Main Function
#'
#' @return
main <- function() {
  
  args <- get_args()
  
  program <- args$program
  
  if (file.exists(program) &! args$force) {
    stop(stringr::str_glue("{program} already exists. Use --force to overwrite."))
  }
  
  content <- get_script(args)
  
  write(content, file = program)
  
  print(stringr::str_glue("Done. See new script {program}."))
}

# Defaults -------------------------------------------------------------------

#' Get Defaults
#'
#' Get defaults from RC file if present
#'
#' @param rc_file Configuration file at ~/.new.R
#' @return defaults
get_defaults <- function(rc_file) {
  
  defaults <- list()
  sys_info <- Sys.info()
  
  if (file.exists(rc_file)) {
    for (line in readLines(rc_file)) {
      match <- stringr::str_match(line, '([^=]+)=([^=]+)')
      if (length(match == 3) > 0) {
        defaults[stringr::str_trim(match[2])] <- stringr::str_trim(match[3])
      }
    }
  }
  
  if (is.null(defaults$name)) {
    defaults$name <- sys_info["user"]
  }
  if (is.null(defaults$email)) {
    defaults$email <- stringr::str_glue('{defaults$name}@domain.tld')
  }
  if (is.null(defaults$purpose)) {
    defaults$purpose <- "Do some stuff"
  }
  
  return(defaults)
  
}

# Content -------------------------------------------------------------------

#' Get script template
#'
#' Get template script that uses argparse
#'
#' @param args Command line arguments
#' @return content
get_script <- function(args) {
  
  content <- stringr::str_glue("#!/usr/bin/env Rscript
    
    # Author : {args$name} <{args$email}>
    # Date   : {Sys.Date()}
    # Purpose: {args$purpose}
    
    # Imports -------------------------------------------------------------------
    
    ## Library calls ------------------------------------------------------------
    
    library(magrittr)
    
    # Argument Parsing ----------------------------------------------------------
    
    #' Parse Arguments
    #'
    #' Parse command line arguments using argparse.
    #'
    #' @return args
    get_args <- function() {{
      parser <- argparse::ArgumentParser(description = \"{args$purpose}\")
      
      parser$add_argument(\"positional\",
                          help = \"A positional argument\",
                          metavar = \"POSITIONAL\")
      parser$add_argument(\"-o\",
                          \"--on\",
                          help = \"A boolean flag\",
                          action = \"store_true\"
      )
      parser$add_argument(\"-i\",
                          \"--int\",
                          help = \"A named numerical argument\",
                          metavar = \"INT\",
                          type = \"integer\",
                          default = 0
      )
      parser$add_argument(\"-s\",
                          \"--str\",
                          help = \"A named string argument\",
                          metavar = \"STR\",
                          type = \"character\",
                          default = \"\"
      )
      
      args <- parser$parse_args()
      
      return(args)
      
    }}
    
    # Main ----------------------------------------------------------------------
    
    #' Main Function
    #'
    #' @return
    main <- function() {{
      
      args <- get_args()
      
      print(args$positional)
      print(args$on)
      print(args$int)
      print(args$str)
    }}
    
    # Call Main -----------------------------------------------------------------
    if (!interactive()) {{
      main()
    }}
    
    ")
}

# Call Main -----------------------------------------------------------------
if (!interactive()) {
  main()
}