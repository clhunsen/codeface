## This file contains the SPL overview widgets for the main dashboard
source("../symbols.r", chdir=TRUE)
source('../spl/db.queries.r', chdir=TRUE)

## Return HTML for an overview box
spl.overview.html <- function(title, bigtext, subtitle, link, subtitle.size="100%") {
  tagList(
    tags$div(class="grid_title", title),
    tags$div(class='grid_bigtext', style="font-size:20px; line-height: 20px; text-align: center", bigtext),
    tags$div(style=paste("font-size:", subtitle.size, "; text-align: center; font-size: 12px; line-height: 16px; margin-top: 25px"), subtitle)
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

renderWidget.widget.spl.overview.project <- function(w) {
  renderUI({
    link <- paste("?projectid=", w$pid(), sep="")
    data <- w$data()
    spl.overview.html(w$project.name(), "SPL",
              tags$table(width="100%",
                                 tags$tr(tags$td(paste('Files: ', data$n.files))),
                                 tags$tr(tags$td(paste('File Instances: ', data$n.files.instances))),
                                 tags$tr(tags$td(paste('File Level Variables: ', data$n.variables.file))),
                                 tags$tr(tags$td(paste('Release Level Variables: ', data$n.variables.release))),
                                 tags$tr(tags$td(paste('Releases: ', data$n.releases))),
                                 tags$tr(tags$td(sprintf("LOC: %.0f / %.0f / %.0f (min/max/avg)", data$stat.loc$min, data$stat.loc$max, data$stat.loc$avg))),
                                 tags$tr(tags$td(sprintf("LOF: %.0f / %.0f / %.0f (min/max/avg)", data$stat.lof$min, data$stat.lof$max, data$stat.lof$avg))),
                                 tags$tr(tags$td(sprintf("NOFC: %.0f / %.0f / %.0f (min/max/avg)", data$stat.nofc$min, data$stat.nofc$max, data$stat.nofc$avg)))
                                 ),
              link
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
