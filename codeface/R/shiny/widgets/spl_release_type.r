## This file contains the TYPE metric widgets for the spl dashboard

source('../spl/db.queries.r', chdir=TRUE)
source('../spl/metrics.release.r', chdir=TRUE)

html.widget.spl.releases.type <- function(id) {
  plotOutput(id, width='100%', height='100%')
}

initWidget.widget.spl.releases.type <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.releases.type <- function(w) {
  #data <- reactive({
  #  spl.release.type(w$pid())
  #})
  renderPlot({
    data <- spl.release.type(w$pid())
    labels <- paste(data$name, ' (', round(data$value), ')', sep="") 
    pie(data$value,
      labels = labels,
      main = 'TYPE',
      radius = 0.95
    )
  }, bg='transparent')
}

widgetColor.widget.spl.releases.type <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.releases.type <- function(w) {
  reactive({
    return("Widget Description")
  })
}

## Widget class 
createWidgetClass(
  c("widget.spl.releases.type"),
  "TYPE for all Releases", "Example Details",
  NULL, # no topical restrictions
  1, 1,
  html=html.widget.spl.releases.type,
  detailpage=list(app="spldashboard", topic="overview")
)
