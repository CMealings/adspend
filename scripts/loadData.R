loadAdspendDB <- function(path) {

  version <- 1.1
  
  start <- Sys.time()
  
  reqPackages(c("xlsx", "abind", "readxl"))
  
  folder <- "E:/TYPESET/International Data/Adspend database/Database (NEW FORMAT)/"
  
  # list excel datasets
  datasets <- grep("\\.xlsx$|\\.xlsm$", list.files(folder), value = TRUE)
  
  # exclude temp files
  datasets <- datasets[-grep("^~\\$", datasets)]
  
  df <- NULL
  mf <- NULL
  sheet.names <- NULL
  
  # Read each workbook
  for (wb in datasets) {
    
    path <- paste0(folder, wb)
    
    # Read sheet names
    sheets <- excel_sheets(path)
    
    # Exclude extraneous sheets
    sheets <- sheets[!sheets %in% c("Sheet2", "Sheet3", "Countries", "Asia Pacific Counts", "Africa Counts", "Latin America Counts", "Europe Counts", "MiddleEast Counts", "Template")]
    
    # Read each sheet
    for (sht in sheets) {
      
      # Read raw sheet
      data <- read_excel(path, sht, range = "A1:CF60", col_names = FALSE)
      
      # Get per sheet metadata
      setName <- as.character(data[1, 2])
      dateUpdated <- as.numeric(data[2, 2][[1]])
      regionCode <- as.character(data[3, 2])
      
      # Get per variable metadata
      meta <- as.data.frame(data[14:21, -1])
      rownames(meta) <- data[14:21, 1][[1]]
      meta[6:8, ] <- apply(meta[6:8, ], 1:2, as.numeric)
      
      # Organise data and metadata
      meta <- list("setName" = setName, "dateUpdated" = dateUpdated, "regionCode" = regionCode, "data" = meta)
      data <- as.data.frame(data[23:60, -1], row.names = data[23:60, 1][[1]], colClasses = rep("numeric", dim(data)[2] - 1))
      
      colnames(data) <- meta$data["SeriesName", ]
      
      # Add sheet to metaframe and dataframe
      mf <- append(mf, list(meta))
      df <- abind(df, data, along = 3)
    }
    
    sheet.names <- append(sheet.names, sheets)
  }
  
  # Sheet name to dataframe
  dimnames(df)[[3]] <- sheet.names
  
  assign("df", df, pos = parent.frame(n = 1))
  assign("mf", mf, pos = parent.frame(n = 1))
  
  # Load time
  end <- Sys.time() - start
  cat("Adspend Database loaded in ", end)
  
}