library(reshape)
library(stringr)

source('version_helper.r', chdir=TRUE)

spl.release.metrics <- function(pid) {
  db.data <- spl.db.release.metrics(pid)
  data <- cast(db.data, revision~name, value = 'sum')
  frame <- data.frame(data)
  frame <- frame[order(spl.versions.sortable(frame$revision)), ]
  extendedFrame <- within(frame, {
    lof.diff <- head(append(c(0), (append(tail(LOF, -1), c(0)) - LOF)), -1)
    lof.change <- round(head(append(c(0), ((LOF / append(tail(LOF, -1), c(0))) - 1)), -1), 3)
    loc.diff <- head(append(c(0), (append(tail(LOC, -1), c(0)) - LOC)), -1)
    loc.change <- round(head(append(c(0), ((LOC / append(tail(LOC, -1), c(0))) - 1)), -1), 3)
    nofc.diff <- head(append(c(0), (append(tail(NOFC, -1), c(0)) - NOFC)), -1)
    nofc.change <- round(head(append(c(0), ((NOFC / append(tail(NOFC, -1), c(0))) - 1)), -1), 3)
  })
  extendedFrame
}
