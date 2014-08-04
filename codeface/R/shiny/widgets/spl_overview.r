#! /usr/bin/env Rscript

## This file is part of Codeface. Codeface is free software: you can
## redistribute it and/or modify it under the terms of the GNU General Public
## License as published by the Free Software Foundation, version 2.
##
## This program is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
## FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
## details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
##
## Copyright 2013 by Siemens AG, Johannes Ebke <johannes.ebke.ext@siemens.com>
## All Rights Reserved.

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
  #w$cycles <- reactive({get.cycles.con(conf$con, w$pid())})
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

## Widget which creates an overview of a project for analysts
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
  #w$status <- reactive({
  #  list(
  #    collaboration = figure.of.merit.collaboration(w$pid())$status,
  #    construction = figure.of.merit.construction(w$pid())$status,
  #    communication = figure.of.merit.communication(w$pid())$status,
  #    complexity = figure.of.merit.complexity(w$pid())$status
  #  )
  #})
  return(w)
}

renderWidget.widget.spl.overview.project <- function(w) {
  renderUI({
    ## Collaboration indicator color
    #combined.status <- as.character(combine.status(w$status()))
    #indicator.summary <- symbols.processing.status[[which(names(symbols.processing.status) == combined.status)]]

    #indicator.collaboration <- make.indicator(symbol.collaboration, as.color(w$status()$collaboration))
    #indicator.construction <- make.indicator(symbol.construction, as.color(w$status()$construction))
    #indicator.communication <- make.indicator(symbol.communication, as.color(w$status()$communication))
    #indicator.complexity <- make.indicator(symbol.complexity, as.color(w$status()$complexity))

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
    print("--------------------")
    #cs <- combine.status(w$status())
    #error <- names(w$status()[w$status() == as.integer(status.error)])
    #good <- names(w$status()[w$status() == as.integer(status.good)])
    #warn <- names(w$status()[w$status() == as.integer(status.warn)])
    #bad <- names(w$status()[w$status() == as.integer(status.bad)])
    #if (all(w$status() == status.good)) {
      return("This project has good marks in all categories and is fully analysed.")
    #}
    #res <- list()
    #if (length(good) > 0) {
    #  res <- c(res, paste("This project has good marks in ", text.enumerate(good), ".", sep=""))
    #}
    #if (length(warn) > 0) {
    #  res <- c(res, paste("Warnings have been reported for ", text.enumerate(warn), ".", sep=""))
    #}
    #if (length(bad) > 0) {
    #  res <- c(res, paste("There seem to be problems in ", text.enumerate(bad), ".", sep=""))
    #}
    #if (length(error) > 0) {
    #  res <- c(res, paste("No analysis has been done for ", text.enumerate(error), ".", sep=""))
    #}
    #res <- c(res, "Click 'details...' to get more information on the evaluations.")
    #do.call(paste, res)
  })
}
