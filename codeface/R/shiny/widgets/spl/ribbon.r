spl.tags.ribbon <- function(text, color='green', link=NULL) {
  wrapperClass = sprintf('ribbon-wrapper %s', color)
  ribbonClass = sprintf('ribbon %s', color)
  content <- {
    if (is.null(link)) {
      text
    } else {
      tags$a(text, href=link)
    }
  }
  tags$div(
    tags$div(
      content,
      class=ribbonClass
    ),
    class=wrapperClass
  )
}
