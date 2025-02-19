
test_that("renv_records_select() handles missing packages gracefully", {

  # simulate what happens during printing of records during install
  lhs <- list()
  rhs <- list(skeleton = list(Package = "skeleton"))

  actions <- c(skeleton = "install")
  action <- "install"

  expect_identical(renv_records_select(lhs, actions, action), lhs)
  expect_identical(renv_records_select(rhs, actions, action), rhs)

})

test_that("we can format records in various ways", {

  old <- list(
    Package    = "skeleton",
    Version    = "1.0.0",
    Source     = "Repository",
    Repository = "CRAN"
  )

  new <- list(
    Package        = "skeleton",
    Version        = "1.0.0",
    Source         = "github",
    RemoteUsername = "kevinushey",
    RemoteRepo     = "skeleton"
  )

  expect_equal(renv_record_format_short(old), "1.0.0")
  expect_equal(renv_record_format_short(new), "kevinushey/skeleton")

  expect_equal(
    renv_record_format_pair(old, new),
    "[1.0.0 -> kevinushey/skeleton]"
  )

  expect_equal(
    renv_record_format_pair(new, new),
    "[kevinushey/skeleton: unchanged]"
  )

  record <- list(
    Package        = "skeleton",
    Version        = "1.0.0",
    Source         = "github",
    RemoteUsername = "kevinushey",
    RemoteRepo     = "skeleton",
    RemoteRef      = "feature/branch"
  )

  expect_equal(
    renv_record_format_short(record),
    "kevinushey/skeleton@feature/branch"
  )

  old <- list(
    Package        = "skeleton",
    Version        = "1.0.0",
    Source         = "GitHub",
    RemoteUsername = "kevinushey",
    RemoteRepo     = "skeleton"
  )

  new <- list(
    Package        = "skeleton",
    Version        = "1.0.0",
    Source         = "Gitlab",
    RemoteUsername = "kevinushey",
    RemoteRepo     = "skeleton"
  )

  expect_equal(
    renv_record_format_pair(old, new),
    "[1.0.0: GitHub -> Gitlab]"
  )

})

test_that("compatible records from pak are handled correctly", {

  lhs <- list(
    Package           = "anytime",
    Version           = "0.3.9",
    Source            = "Repository",
    Depends           = "R (>= 3.2.0)",
    Imports           = "Rcpp (>= 0.12.9)",
    LinkingTo         = c("Rcpp (>= 0.12.9)", "BH"),
    Repository        = "CRAN",
    RemoteType        = "standard",
    RemotePkgRef      = "anytime",
    RemoteRef         = "anytime",
    RemoteRepos       = "https=//cran.rstudio.com",
    RemotePkgPlatform = "aarch64-apple-darwin20",
    RemoteSha         = "0.3.9",
    Hash              = "74a64813f17b492da9c6afda6b128e3d"
  )

  rhs <- list(
    Package           = "anytime",
    Version           = "0.3.9",
    Source            = "CRAN",
    Repository        = "CRAN",
    RemoteType        = "standard",
    RemotePkgRef      = "anytime",
    RemoteRef         = "anytime",
    RemoteRepos       = "https://cran.rstudio.com",
    RemotePkgPlatform = "aarch64-apple-darwin20",
    RemoteSha         = "0.3.9",
    Hash              = "74a64813f17b492da9c6afda6b128e3d",
    Requirements      = list()
  )

  change <- renv_lockfile_diff_record(lhs, rhs)
  expect_null(change)

})
