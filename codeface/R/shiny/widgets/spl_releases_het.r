## This file contains the TYPE metric widgets for the spl dashboard

source('../spl/db.queries.r', chdir=TRUE)

html.widget.spl.releases.het <- function(id) {
  plotOutput(id, width='100%', height='100%')
}

initWidget.widget.spl.releases.het <- function(w) {
  # Call superclass
  w <- NextMethod(w)
  return(w)
}

renderWidget.widget.spl.releases.het <- function(w) {
  renderPlot({
    het <- spl.db.releases.het(w$pid())
    hom <- spl.db.releases.hom(w$pid())
    hohe <- spl.db.releases.hohe(w$pid())
    yrange <- range(het$value, hom$value, hohe$value)
    colors <- rainbow(3)

    plot(het$value,
      type = 'p',
      main = 'HET/HOM/HOHE',
      ylim = yrange,
      axes = FALSE,
      ann = FALSE
    )

    axis(1, at=1:length(het$revision), lab=het$revision)
    axis(2, las=1, at=400*0:yrange[2])

    box()

    lines(het$value, type='p', col=colors[1])
    lines(hom$value, type='p', col=colors[2], pch=22)
    lines(hohe$value, type='p', col=colors[3], pch=23)

    legend(-5, yrange[2],
      c('HET', 'HOM', 'HOHE'), cex=0.8, colors, pch=21:23, bty='n')

  }, bg='transparent')
}

widgetColor.widget.spl.releases.het <- function(w) {
  reactive({
    color.neutral
  })
}

widgetExplanation.widget.spl.releases.het <- function(w) {
  reactive({
    return("Widget Description")
  })
}

## Widget class
createWidgetClass(
  c("widget.spl.releases.het"),
  "HET/HOM/HOHE for all Releases", "Example Details",
  NULL, # no topical restrictions
  4, 1,
  html=html.widget.spl.releases.het,
  detailpage=list(app="spldashboard", topic="overview")
)
