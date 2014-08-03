spl.versions.split <- function(v) {
  strsplit(v, '\\.')[[1]]
}

spl.versions.toint <- function(splits) {
  strtoi(splits[1]) * 1000000 + strtoi(splits[2]) * 1000 + strtoi(splits[3])
}

spl.versions.sortable <- function(v) {
  do.call(rbind, as.matrix(lapply(lapply(v, spl.versions.split), spl.versions.toint)))
}
