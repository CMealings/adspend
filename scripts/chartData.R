chartData <- function(df, mf, years, variables, countries) {
  
  version <- 1.1
  
  data <- df[years, variables, countries]
  
  return(data)
}