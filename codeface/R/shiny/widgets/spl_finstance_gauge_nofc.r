## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('./spl/justgage.r', chdir=TRUE)

initWidget.widget.spl.finstance.gauge.nofc <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.finstance.gauge.nofc <- function(w) {
  reactive({
    metrics <- spl.db.finstance.metrics(w$pid(), w$spl$file())
    nofc <- metrics[metrics$name == 'NOFC', ]
    max <- spl.db.finstance.metrics.max(w$pid())
    nofc.max <- max[max$name == 'NOFC', ]

    c(value = nofc$value, max = nofc.max$value)
  })
}

html.widget.spl.finstance.gauge.nofc <- function(id) {
  spl.tags.justgage(id, title = '# Of Feature Constants', units = 'feature constants')
}

widgetColor.widget.spl.finstance.gauge.nofc <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.finstance.gauge.nofc <- function(w) {
  reactive({
    return("Widget Description")
  })
}

## Widget for gauge test
createWidgetClass(
  c("widget.spl.finstance.gauge.nofc"),
  "SPL File Instance NOFC", "Gauge Test",
  NULL, # no topical restrictions
  1, 1,
  html=html.widget.spl.finstance.gauge.nofc,
  detailpage=list(app="spldashboard", topic="overview")
)

