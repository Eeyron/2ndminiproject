library(dplyr)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))		# Sets the working directory to the directory of the source file

# Read data from train
train.x <- read.table("specdata/UCI HAR Dataset/train/X_train.txt")
train.y <- read.table("specdata/UCI HAR Dataset/train/Y_train.txt")
train.sub <- read.table("specdata/UCI HAR Dataset/train/subject_train.txt")

# Read data from test
test.x <- read.table("specdata/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("specdata/UCI HAR Dataset/test/Y_test.txt")
test.sub <- read.table("specdata/UCI HAR Dataset/test/subject_test.txt")

# Merge sets from train and test
xData <- rbind(train.x, test.x)
yData <- rbind(train.y, test.y)
subjectData <- rbind(train.sub, test.sub)

# Merge every data into one data frame
data <- cbind(subjectData, yData, xData)

# Read the features from features.txt
feature <- read.table("specdata/UCI HAR Dataset/features.txt")

# Add those features as column as well as subject id and activity name
names(data) <- c("SubjectID", "ActivityName", as.character(feature$V2))

# Extract only the mean and std features
subjectData.sd.mean <- feature$V2[grep("-mean\\(\\)|-std\\(\\)", feature$V2)]
# Then add subject id and activity name
selColumns <- c("SubjectID", "ActivityName", as.character(subjectData.sd.mean))
# Extract the data only from mean and std features
data <- subset(data, select = selColumns)

# Get the values of activity names from activity_labels.txt
activity <- read.table("specdata/UCI HAR Dataset/activity_labels.txt")
# Replace ActivityName column into their descriptive values
data$ActivityName = activity[data$ActivityName, 2]

names(data) <- gsub("^t", "Time", names(data))				# Replace first small letter t to Time
names(data) <- gsub("^f", "Frequency", names(data))			# Replace first small letter f to Frequency
names(data) <- gsub("Acc", "Accelerometer", names(data))	# Replace Acc to Accelerometer
names(data) <- gsub("Gyro", "Gyroscope", names(data))		# Replace Gyro to Gyroscope
names(data) <- gsub("Mag", "Magnitude", names(data))		# Replace Mag to Magnitude

# Group the data by subjectid and activityname
dataGroup <- group_by(data, SubjectID, ActivityName)

# Get the mean in every activity and id
dataMean <- summarise_each(dataGroup, funs(mean))

# Remove temporary variables
remove(train.x, train.y, train.sub, test.x, test.y, test.sub, yData, xData, subjectData, feature, subjectData.sd.mean, selColumns, activity, dataGroup)