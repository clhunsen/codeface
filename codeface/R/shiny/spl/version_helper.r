spl.versions.split <- function(v) {
  strsplit(v, '\\.')[[1]]
}

spl.versions.toint <- function(splits) {
  triple <- c(splits[1], splits[2], splits[3])
  triple[is.na(triple)] <- 0
  strtoi(triple[1]) * 1000000 + strtoi(triple[2]) * 1000 + strtoi(triple[3])
}

spl.versions.sortable <- function(v) {
  do.call(rbind, as.matrix(lapply(lapply(v, spl.versions.split), spl.versions.toint)))
}
