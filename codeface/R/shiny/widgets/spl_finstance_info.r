## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('../spl/db.queries.r', chdir=TRUE)

## Return HTML for an overview box
content.widget.spl.finstance.info <- function(release, path, projectname, content='') {
  headline <- sprintf("%2$s at %1$s in project %3$s", release, path, projectname)
  tagList(
    tags$div(class="spl finstance title", headline, title = headline),
    tags$div(content, class='spl finstance metrics')
  )
}

metrictable.widget.spl.finstance.info <- function(metrics) {
  table.rows <- apply(metrics, 1, function(row) {
    tags$tr(tags$td(row['name']), tags$td(row['value']))
  })
  tags$table(table.rows, class='table table-striped table-condensed')
}

## Widget which creates an overview of a spl file_instance
createWidgetClass(
  c("widget.spl.finstance.info"),
  "SPL File Instance Info", "Short SPL File Instance Info summary",
  NULL, # no topical restrictions
  1, 1,
  html=htmlOutput,
  detailpage=list(app="spldashboard", topic="overview")
)

initWidget.widget.spl.finstance.info <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  w$data <- reactive({
    project <- query.project.name(conf$con, w$pid())
    finstance <- spl.db.finstance.get(w$pid(), w$spl$file())
    metrics <- spl.db.finstance.metrics(w$pid(), w$spl$file())
    list(
      project.name = project,
      release = finstance$revision,
      path = finstance$path,
      metrics = metrics
    )
  })
  return(w)
}

renderWidget.widget.spl.finstance.info <- function(w) {
  renderUI({
    link <- paste("?projectid=", w$pid(), sep="")
    data <- w$data()
    content.widget.spl.finstance.info(data$release, data$path, data$project.name,
      metrictable.widget.spl.finstance.info(data$metrics))
  })
}

widgetColor.widget.spl.finstance.info <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.finstance.info <- function(w) {
  reactive({
    "Widget Explanation."
  })
}
