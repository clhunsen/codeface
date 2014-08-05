## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('./spl/justgage.r', chdir=TRUE)

initWidget.widget.spl.finstance.gauge.ndmax <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.finstance.gauge.ndmax <- function(w) {
  reactive({
    metrics <- spl.db.finstance.metrics(w$pid(), w$spl$file())
    ndmax <- metrics[metrics$name == 'NDMAX', ]
    max <- spl.db.finstance.metrics.max(w$pid())
    ndmax.max <- max[max$name == 'NDMAX', ]

    c(value = ndmax$value, max = ndmax.max$value)
  })
}

html.widget.spl.finstance.gauge.ndmax <- function(id) {
  spl.tags.justgage(id, title = 'Maximum Nesting Depth', units = 'nesting level')
}

widgetColor.widget.spl.finstance.gauge.ndmax <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.finstance.gauge.ndmax <- function(w) {
  reactive({
    return("Widget Description")
  })
}

## Widget for gauge test
createWidgetClass(
  c("widget.spl.finstance.gauge.ndmax"),
  "SPL File Instance NDMAX", "Gauge Test",
  NULL, # no topical restrictions
  1, 1,
  html=html.widget.spl.finstance.gauge.ndmax,
  detailpage=list(app="spldashboard", topic="overview")
)

