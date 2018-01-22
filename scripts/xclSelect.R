

function(selection = list(), datapath) {
  
  # Get filetype
  
  filetype <- unlist(strsplit(datapath, "\\."))
  filetype <- filetype[length(filetype)]
  
  ## Read in data
  if (filetype == "xlsx") {
    
    wb <- loadWorkbook(datapath)
    sheets <- names(getSheets(wb))
    
    data <- list()
    
    if (length(sheets > 1)) {
      
      for (sht in 1:length(sheets)) {
        
        data <- append(data, list(read.xlsx(datapath, sht, header = FALSE)))
        
      }
      names(data) <- sheets
    } else {
      
      data <- read.xlsx(datapath, sht, header = FALSE)
    }
  }
  
  if (filetype == "csv") {
    
    data <- read.csv(datapath, header = FALSE)
    
    ## Remove 1000s separator, where csv uses it
    # data <- data.frame(apply(data, 1:2, gsub, pattern = ",", replacement = ""))
    
  }
  
  # Index Conversion
  for (sel in selection) {
    
    topleft <- sel[1]
    btmright <- sel[2]
    
    firstcol <- gsub("[0-9]", "", topleft)
    firstrow <- as.numeric(gsub("[A-Z]", "", topleft))
    lastcol <- gsub("[0-9]", "", btmright)
    lastrow <- as.numeric(gsub("[A-Z]", "", btmright))
    
    index <- function(cell) {
      if (nchar(cell) == 1)
        col.n <- grep(firstcol, LETTERS)
      else
        col.n <- (grep(substr(cell, 1, 1), LETTERS) * 26) + grep(substr(cell, 2, 2), LETTERS)
      return(col.n)
    }
  }
}