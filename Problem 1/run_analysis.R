setwd(dirname(rstudioapi::getActiveDocumentContext()$path))		#Sets the working directory to the directory of the source file

nsampleSize = -1L
train <- read
test <- readData("../specdata/UCI_HAR_Dataset/test", "test", nsampleSize)
