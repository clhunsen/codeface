## This file contains the XXXX widgets for the YYYY dashboard

## Widget class 
createWidgetClass(
  c("widget.spl.example"),
  "Example Widget", "Example Details",
  NULL, # no topical restrictions
  1, 1,
  html=htmlOutput,
  detailpage=list(app="spldashboard", topic="overview")
)

initWidget.widget.spl.gauge.test <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.gauge.test <- function(w) {
  renderUI({
  })
}

widgetColor.widget.spl.gauge.test <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.gauge.test <- function(w) {
  reactive({
    return("Widget Description")
  })
}

