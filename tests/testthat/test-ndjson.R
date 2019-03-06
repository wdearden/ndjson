context("uncompressed files (validation and streaming)")
test_that("validation and streaming works in uncompressed files (validation and streaming)", {

  f <- system.file("extdata", "test.json", package="ndjson")
  expect_that(validate(f), equals(TRUE))
  expect_that(nrow(stream_in(f)), equals(100))
  expect_that(stream_in(f), is_a("data.table"))

})

context("compressed files (validation and streaming)")
test_that("validation and streaming works in compressed files", {

  gzf <- system.file("extdata", "testgz.json.gz", package="ndjson")
  expect_that(validate(gzf), equals(TRUE))
  expect_that(nrow(stream_in(gzf)), equals(100))
  expect_that(stream_in(gzf), is_a("data.table"))

})
