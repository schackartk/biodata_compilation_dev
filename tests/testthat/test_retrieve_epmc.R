PRG <- "../../src/retrieve_epmc.R"

run_cmd <- function(cmd) {
  system(cmd, intern = TRUE, ignore.stderr = TRUE)
}

# ---------------------------------------------------------------------------
test_that("Program exists", {
  expect_true(file.exists(PRG))
})

# ---------------------------------------------------------------------------
test_that("Program is lint free", {
  expect_silent(lintr::lint(PRG))
})

# ---------------------------------------------------------------------------
test_that("Program prints usage", {
  for (flag in c("-h", "--help")) {
    expect_match(run_cmd(stringr::str_glue("Rscript {PRG} {flag}"))[1],
                 "usage")
  }
  
})

# ---------------------------------------------------------------------------
test_that("Runs okay", {
  out_dir <- "test_dir"
  query <-
    '"(ABSTRACT:"www" OR ABSTRACT:"http" OR ABSTRACT:"https")"'
  limit <- 100
  
  tryCatch({
    if (dir.exists(out_dir)) {
      unlink(out_dir, recursive = TRUE)
    }
    
    # Check that it runs and gives message
    expect_match(run_cmd(stringr::str_glue(
      paste0("Rscript {PRG} -l {limit} ",
             "-o {out_dir} ",
             "{query}")
    ))[1],
    "Initial seed saved")
    
    # Check that output file was written
    expect_true(file.exists(stringr::str_glue(
      paste0("{out_dir}",
             "/pmc_seed_all.csv")
    )))
    
    # Check that correct number of records are present
    expect_equal(fpeek::peek_count_lines(paste0(out_dir, "/pmc_seed_all.csv")),
                 limit + 1)
  },
  finally = {
    if (dir.exists(out_dir)) {
      unlink(out_dir, recursive = TRUE)
    }
  })
})
