## This file contains the per-release metrics widgets for the spl dashboards

source('../spl/db.queries.r', chdir=TRUE)
source('../spl/metrics.release.r', chdir=TRUE)

initWidget.widget.spl.release.metrics <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.release.metrics <- function(w) {
  reactive({
    spl.release.metrics(strtoi(w$pid()))
  })
}

widgetColor.widget.spl.release.metrics <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.release.metrics <- function(w) {
  reactive({
    return("Widget Description")
  })
}

html.widget.spl.release.metrics <- function(id) {
  tags$div(tags$table(class='table table-striped table-hover spl releases',
    tags$tr(
      tags$td('Revision'),
      tags$th('LOC'),
      tags$th('LOF'),
      tags$th('NOFC'),
      tags$th('AND'),
      tags$th('FPFC'),
      tags$th('SDEG'),
      tags$th('TDEG')
    )
  ), class="spl releases output", id=id)
}

## Widget class
createWidgetClass(
  c("widget.spl.release.metrics"),
  "Release Metrics", "This widget shows all per-release metrics.",
  NULL, # no topical restrictions
  3, 2,
  html=html.widget.spl.release.metrics,
  detailpage=list(app="spldashboard", topic="overview")
)

