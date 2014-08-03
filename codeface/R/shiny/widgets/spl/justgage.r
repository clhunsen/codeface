spl.tags.justgage <- function(id, title = '', units = '', min = 0, max = 100) {
  tags$div(id = id,
    class = 'justgage_output',
    'data-title' = title,
    'data-units' = units,
    'data-min' = min,
    'data-max' = max,
    style = 'width:260px; height:200px'
  )
}
