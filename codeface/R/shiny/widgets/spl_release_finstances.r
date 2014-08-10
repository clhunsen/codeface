## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('../spl/db.queries.r', chdir=TRUE)

## Return HTML for an overview box

## Superclass constructor which already fills important variables
initWidget.widget.spl.release.finstances <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  w$data <- reactive({
    pid <- w$pid()
    rid <- w$spl$release()
    finstances <- spl.db.finstances.get(pid, rid)
    finstances
  })
  return(w)
}

## Widget which creates an overview of a spl project
createWidgetClass(
  c("widget.spl.release.finstances"),
  "SPL Release File Instances", "List of all File Instances in a Release",
  NULL, # no topical restrictions
  2, 2,
  html=htmlOutput,
  detailpage=list(app="spldashboard", topic="overview")
)

renderTable.widget.spl.release.finstances <- function(d) {

  table.rows <- apply(d, 1, function(row) {
    url <- sprintf("./?topic=spl-finstance&projectid=%s&file=%s", row['pid'], row['fiid'])
    tags$tr(
      tags$td(tags$a(row['path'], href=url))
    )
  })

  table.header <- tags$tr(
    tags$td('Path')
  )

  tags$div(
    tags$table(table.header, table.rows, class='table table-striped table-condensed'),
    class='spl release finstances metrics'
  )
}

renderWidget.widget.spl.release.finstances <- function(w) {
  renderUI({
    data <- w$data()
    renderTable.widget.spl.release.finstances(data)
  })
}

widgetColor.widget.spl.release.finstances <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.release.finstances <- function(w) {
  reactive({
    "Widget Explanation."
  })
}
