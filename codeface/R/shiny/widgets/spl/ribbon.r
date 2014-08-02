spl.tags.ribbon <- function(text, color='green') {
  wrapperClass = sprintf('ribbon-wrapper %s', color)
  ribbonClass = sprintf('ribbon %s', color)
  tags$div(
    tags$div(
      text,
      class=ribbonClass
    ),
    class=wrapperClass
  )
}
