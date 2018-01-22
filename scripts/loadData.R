reqPackages(c("xlsx", "abind"))

folder <- "E:/TYPESET/International Data/Adspend database/Database (NEW FORMAT)/"

# list excel datasets
datasets <- grep("\\.xlsx$|\\.xlsm$", list.files(folder), value = TRUE)

# exclude temp files
datasets <- datasets[-grep("^~\\$", datasets)]

df <- NULL
mf <- NULL

for (wb in datasets) {
  
  path <- paste0(folder, wb)
  file <- loadWorkbook(path)
  
  sheets <- names(getSheets(file))
  sheets <- sheets[!sheets %in% c("Sheet2", "Sheet3", "Countries", "Asia Pacific Counts", "Africa Counts", "Latin America Counts", "MiddleEast Counts", "Template")]
  
  for (sht in sheets) {
    
    # data <- read.xlsx(path, sht, rowIndex = 23:60, colIndex = 1:55, keepFormulas = FALSE, header = FALSE, row.names = 1)
    data <- readWorksheet(file, sht, startRow = 1, endRow = 60, startCol = 1, endCol = 55, useCachedValues = TRUE, header = FALSE, stringsAsFactors = FALSE)
    browser()
    # meta <- read.xlsx(path, sht, rowIndex = 14:21, colIndex = 1:55, header = FALSE, stringsAsFactors = FALSE, row.names = 1)
    
    countryMeta <- read.xlsx(path, sht, rowIndex = 1:3, colIndex = 1, header = FALSE, stringsAsFactors = FALSE)
    setName <- countryMeta[1, 1]
    dateUpdated <- countryMeta[2, 1]
    regionCode <- countryMeta[3, 1]
    
    meta <- meta[14:21, ]
    meta[5:7, ] <- apply(meta[5:7, ], 1:2, as.numeric)
    
    meta <- list("setName" = setName, "dateUpdated" = dateUpdated, "regionCode" = regionCode, "meta" = meta)
    
    colnames(data) <- meta["SeriesCode", ]
    
    mf <- abind(mf, meta, along = 3)
    df <- abind(df, data, along = 3)
  }
}


