## Problem 1

Load the needed library
```
library(dplyr)
```

Sets the current working directory to the path of the source file
```
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
```

Reads the data from both training and tests
```
train.x <- read.table("specdata/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("specdata/UCI HAR Dataset/train/Y_train.txt")
train.sub <- read.table("specdata/UCI HAR Dataset/train/subject_train.txt")

test.x <- read.table("specdata/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("specdata/UCI HAR Dataset/test/Y_test.txt")
test.sub <- read.table("specdata/UCI HAR Dataset/test/subject_test.txt")
```

Merge the data from both sets into one using rbind
```
xData <- rbind(train.x, test.x)
yData <- rbind(train.y, test.y)
subjectData <- rbind(train.sub, test.sub)
```

Then combine all the data into one data frame using cbind
```
data <- cbind(subjectData, yData, xData)
```

Now that we have the data, next is to give it a column name.
We extract the names from features.txt
```
feature <- read.table("specdata/UCI HAR Dataset/features.txt")
```

Then add two more column names, SubjectID & ActivityName, and assign it as the column names to data
```
names(data) <- c("SubjectID", "ActivityName", as.character(feature$V2))
```

After we added column names to our data. Next is to only extract the data that contains the mean and std.
We can do this by extracting column names that contain the string pattern "-mean()" or "-std()" and subsetting the original data
```
subjectData.sd.mean <- feature$V2[grep("-mean\\(\\)|-std\\(\\)", feature$V2)]
selColumns <- c("SubjectID", "ActivityName", as.character(subjectData.sd.mean))
data <- subset(data, select = selColumns)
```

Now that we have only the mean and std data, next is to change the ActivityName values into their descriptive values.
We extract the values from activity_labels.txt then replacing the int values into its descriptive values.
```
activity <- read.table("specdata/UCI HAR Dataset/activity_labels.txt")
data$ActivityName = activity[data$ActivityName, 2]
```

And finally, we have to change the column names into their meaningful version.
We change the first small letter t into Time and f into Frequency,
then complete Acc, Gyro, Mag into Accelerometer, Gyroscope, Magniture respectively.
We can do this by using gsub and finding the patterns to replace.
```
names(data) <- gsub("^t", "Time", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))
```

Finally, the data is tidy and clean.

To get the average values from every subject id and activity name, we have to group the data into the respective columns.
Then get the mean by using the group.
```
dataGroup <- group_by(data, SubjectID, ActivityName)
dataMean <- summarise_each(dataGroup, funs(mean))
```

To clean the environment from RStudio we remove the temporary variables used throughout the process.
```
remove(train.x, train.y, train.sub, test.x, test.y, test.sub, yData, xData, subjectData, feature, subjectData.sd.mean, selColumns, activity, dataGroup)
```