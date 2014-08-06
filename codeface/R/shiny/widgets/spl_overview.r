## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('../spl/db.queries.r', chdir=TRUE)

## Return HTML for an overview box

content.widget.spl.overview <- function(projectname, content) {
  headline <- sprintf("The %1$s SPL", projectname)
  tagList(
    tags$div(class="spl project title", headline, title = headline),
    tags$div(content, class='spl project summary metrics')
  )
}

## Superclass constructor which already fills important variables
initWidget.widget.spl.overview <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  w$project.name <- reactive({query.project.name(conf$con, w$pid())})
  w$data <- reactive({
    pid <- w$pid()
    list(
      n.files = spl.db.count.files(pid),
      n.files.instances = spl.db.count.files.instances(pid),
      n.variables.file = spl.db.count.variables.file(pid),
      n.variables.release = spl.db.count.variables.release(pid),
      n.releases = spl.db.count.releases(pid),
      stat.loc = spl.db.project.loc(pid),
      stat.lof = spl.db.project.lof(pid),
      stat.nofc = spl.db.project.nofc(pid)
    )
  })
  return(w)
}

## Widget which creates an overview of a spl project
createWidgetClass(
  c("widget.spl.overview.project", "widget.spl.overview"),
  "Software Product-Line Summary", "Short SPL summary",
  NULL, # no topical restrictions
  1, 1,
  html=htmlOutput,
  detailpage=list(app="spldashboard", topic="overview")
)

initWidget.widget.spl.overview.project <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderTable.widget.spl.overview.project <- function(d) {
  tags$table(class='table table-striped table-condensed',
    tags$tr(
      tags$td('Files'),
      tags$td(d$n.files)
    ),
    tags$tr(
      tags$td('File Instances'),
      tags$td(d$n.files.instances)
    ),
    tags$tr(
      tags$td('File Level Variables'),
      tags$td(d$n.variables.file)
    ),
    tags$tr(
      tags$td('Release Level Variables'),
      tags$td(d$n.variables.release)
    ),
    tags$tr(
      tags$td('Releases'),
      tags$td(d$n.releases)
    ),
    tags$tr(
      tags$td('LOC'),
      tags$td(sprintf("%.0f / %.0f / %.0f", d$stat.loc$min, d$stat.loc$max, d$stat.loc$avg), title='(min/max/avg)')
    ),
    tags$tr(
      tags$td('LOF'),
      tags$td(sprintf("%.0f / %.0f / %.0f", d$stat.lof$min, d$stat.lof$max, d$stat.lof$avg), title='(min/max/avg)')
    ),
    tags$tr(
      tags$td('NOFC'),
      tags$td(sprintf("%.0f / %.0f / %.0f", d$stat.nofc$min, d$stat.nofc$max, d$stat.nofc$avg), title='(min/max/avg)')
    )
  )
}

renderWidget.widget.spl.overview.project <- function(w) {
  renderUI({
    link <- paste("?projectid=", w$pid(), sep="")
    data <- w$data()
    content.widget.spl.overview(
      w$project.name(),
      renderTable.widget.spl.overview.project(data)
    )
  })
}

widgetColor.widget.spl.overview.project <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.overview.project <- function(w) {
  reactive({
    "Widget Explanation."
  })
}
