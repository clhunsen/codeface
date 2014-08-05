## This file contains the TYPE metric widgets for the spl dashboard

source('../spl/db.queries.r', chdir=TRUE)

html.widget.spl.files.and <- function(id) {
  plotOutput(id, width='100%', height='100%')
}

initWidget.widget.spl.files.and <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.files.and <- function(w) {
  renderPlot({
    andavg <- spl.db.files.and.avg(w$pid(), w$spl$release())

    limit <- 1

    andavg <- andavg[andavg$value > limit, ]
    andavg$group <- 1
    andavg$group[andavg$value > 1.5] <- 2
    andavg$group[andavg$value > 2] <- 3

    andavg$color <- 'darkgreen'
    andavg$color[andavg$group == 2] <- 'yellow4'
    andavg$color[andavg$group == 3] <- 'darkred'


    dotchart(andavg$value,
      labels=andavg$path,
      cex=.7,
      main=paste('ANDAVG (filter: > ', limit, ')', sep=''),
      xlab='ANDAVG',
      gcolor='black',
      groups=andavg$group,
      color=andavg$color
    )
  }, bg='transparent')
}

widgetColor.widget.spl.files.and <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.files.and <- function(w) {
  reactive({
    return("Widget Description")
  })
}

## Widget class
createWidgetClass(
  c("widget.spl.files.and"),
  "AND for all files", "Example Details",
  NULL, # no topical restrictions
  3, 2,
  html=html.widget.spl.files.and,
  detailpage=list(app="spldashboard", topic="overview")
)
