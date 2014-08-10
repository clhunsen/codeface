## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('./spl/justgage.r', chdir=TRUE)

initWidget.widget.spl.finstance.gauge.lof <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.finstance.gauge.lof <- function(w) {
  reactive({
    metrics <- spl.db.finstance.metrics(w$pid(), w$spl$file())
    lof <- metrics[metrics$name == 'LOF', ]
    max <- spl.db.finstance.metrics.max(w$pid())
    lof.max <- max[max$name == 'LOF', ]

    c(value = lof$value, max = lof.max$value)
  })
}

html.widget.spl.finstance.gauge.lof <- function(id) {
  spl.tags.justgage(id, title = 'Lines Of Feature Code', units = 'lines')
}

widgetColor.widget.spl.finstance.gauge.lof <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.finstance.gauge.lof <- function(w) {
  reactive({
    return("Widget Description")
  })
}

## Widget for gauge test
createWidgetClass(
  c("widget.spl.finstance.gauge.lof"),
  "SPL File Instance LOF", "Gauge Test",
  NULL, # no topical restrictions
  1, 1,
  html=html.widget.spl.finstance.gauge.lof,
  detailpage=list(app="spldashboard", topic="overview")
)

