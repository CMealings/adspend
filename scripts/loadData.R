reqPackages(c("xlsx", "abind", "readxl"))

folder <- "E:/TYPESET/International Data/Adspend database/Database (NEW FORMAT)/"

# list excel datasets
datasets <- grep("\\.xlsx$|\\.xlsm$", list.files(folder), value = TRUE)

# exclude temp files
datasets <- datasets[-grep("^~\\$", datasets)]

df <- NULL
mf <- NULL
sheet.names <- NULL

start <- Sys.time()

for (wb in datasets) {
  
  path <- paste0(folder, wb)
  
  sheets <- excel_sheets(path)
  sheets <- sheets[!sheets %in% c("Sheet2", "Sheet3", "Countries", "Asia Pacific Counts", "Africa Counts", "Latin America Counts", "Europe Counts", "MiddleEast Counts", "Template")]
  
  for (sht in sheets) {
    
    data <- read_excel(path, sht, range = "A1:CF60", col_names = FALSE)
    
    setName <- as.character(data[1, 2])
    dateUpdated <- as.numeric(data[2, 2][[1]])
    regionCode <- as.character(data[3, 2])
    
    meta <- as.data.frame(data[14:21, -1])
    rownames(meta) <- data[14:21, 1][[1]]
    meta[6:8, ] <- apply(meta[6:8, ], 1:2, as.numeric)
    
    meta <- list("setName" = setName, "dateUpdated" = dateUpdated, "regionCode" = regionCode, "data" = meta)
    data <- as.data.frame(data[23:60, -1], row.names = data[23:60, 1][[1]], colClasses = rep("numeric", dim(data)[2] - 1))
    
    colnames(data) <- meta$data["SeriesName", ]
    
    mf <- list(mf, list(meta))
    df <- abind(df, data, along = 3)
  }
  
  sheet.names <- append(sheet.names, sheets)
}

dimnames(df)[[3]] <- sheet.names
cat(Sys.time() - start)

