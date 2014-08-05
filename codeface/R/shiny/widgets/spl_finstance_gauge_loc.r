## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('./spl/justgage.r', chdir=TRUE)

initWidget.widget.spl.finstance.gauge.loc <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.finstance.gauge.loc <- function(w) {
  reactive({
    metrics <- spl.db.finstance.metrics(w$pid(), w$spl$file())
    loc <- metrics[metrics$name == 'LOC', ]
    max <- spl.db.finstance.metrics.max(w$pid())
    loc.max <- max[max$name == 'LOC', ]

    c(value = loc$value, max = loc.max$value)
  })
}

html.widget.spl.finstance.gauge.loc <- function(id) {
  spl.tags.justgage(id, title = 'Lines Of Code', units = 'lines')
}

widgetColor.widget.spl.finstance.gauge.loc <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.finstance.gauge.loc <- function(w) {
  reactive({
    return("Widget Description")
  })
}

## Widget for gauge test
createWidgetClass(
  c("widget.spl.finstance.gauge.loc"),
  "SPL File Instance LOC", "Gauge Test",
  NULL, # no topical restrictions
  1, 1,
  html=html.widget.spl.finstance.gauge.loc,
  detailpage=list(app="spldashboard", topic="overview")
)

