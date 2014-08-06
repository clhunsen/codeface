## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('../spl/db.queries.r', chdir=TRUE)

## Return HTML for an overview box

content.widget.spl.release.overview <- function(projectname, releasename, content) {
  headline <- sprintf("Release %1$s in %2$s", releasename, projectname)
  tagList(
    tags$div(class="spl project title", headline, title = headline),
    tags$div(content, class='spl project summary metrics')
  )
}

## Superclass constructor which already fills important variables
initWidget.widget.spl.release.overview <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  w$project.name <- reactive({query.project.name(conf$con, w$pid())})
  w$data <- reactive({
    pid <- w$pid()
    rid <- w$spl$release()
    release <- spl.db.release.get(pid, rid)
    release.metrics <- spl.db.release.metrics.r(pid, rid)
    release.metrics.loc <- release.metrics[release.metrics$name == 'LOC', ]
    release.metrics.lof <- release.metrics[release.metrics$name == 'LOF', ]
    release.metrics.nofc <- release.metrics[release.metrics$name == 'NOFC', ]
    list(
      n.files.instances = spl.db.count.files.instances.r(pid, rid),
      n.variables.file = spl.db.count.variables.file.r(pid, rid),
      n.variables.release = spl.db.count.variables.release.r(pid, rid),
      stat.loc = release.metrics.loc$sum,
      stat.lof = release.metrics.lof$sum,
      stat.nofc = release.metrics.nofc$sum,
      releasename = release$tag
    )
  })
  return(w)
}

## Widget which creates an overview of a spl project
createWidgetClass(
  c("widget.spl.release.overview"),
  "SPL Release Summary", "Short SPL Release summary",
  NULL, # no topical restrictions
  1, 1,
  html=htmlOutput,
  detailpage=list(app="spldashboard", topic="overview")
)

renderTable.widget.spl.release.overview <- function(d) {
  tags$table(class='table table-striped table-condensed',
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
      tags$td('LOC'),
      tags$td(d$stat.loc)
    ),
    tags$tr(
      tags$td('LOF'),
      tags$td(d$stat.lof)
    ),
    tags$tr(
      tags$td('NOFC'),
      tags$td(d$stat.nofc)
    )
  )
}

renderWidget.widget.spl.release.overview <- function(w) {
  renderUI({
    link <- paste("?projectid=", w$pid(), sep="")
    data <- w$data()
    content.widget.spl.release.overview(
      w$project.name(),
      data$releasename,
      renderTable.widget.spl.release.overview(data)
    )
  })
}

widgetColor.widget.spl.release.overview <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.release.overview <- function(w) {
  reactive({
    "Widget Explanation."
  })
}
