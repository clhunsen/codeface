library(reshape)
library(stringr)

source('version_helper.r', chdir=TRUE)

spl.release.metrics.change <- function(vals) {
  round(head(append(c(0), (append(tail(vals, -1), c(0)) - vals) / vals * 100), -1), 3)
}

spl.release.metrics.diff <- function(vals) {
  head(append(c(0), (append(tail(vals, -1), c(0)) - vals)), -1)
}

spl.release.metrics <- function(pid) {
  db.data <- spl.db.release.metrics(pid)
  data <- cast(db.data, revision~name, value = 'sum')
  frame <- data.frame(data)
  frame <- frame[order(spl.versions.sortable(frame$revision)), ]
  extendedFrame <- within(frame, {
    lof.diff <- spl.release.metrics.diff(LOF)
    lof.change <- spl.release.metrics.change(LOF)
    loc.diff <- spl.release.metrics.diff(LOC)
    loc.change <- spl.release.metrics.change(LOC)
    nofc.diff <- spl.release.metrics.diff(NOFC) 
    nofc.change <- spl.release.metrics.change(NOFC)
  })
  extendedFrame
}
