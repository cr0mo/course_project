
# 0) READ DATA (TEST AND TRAIN)
file <- "./UCI HAR Dataset 2/test/subject_test.txt"
testSubject <- read.table(file, sep = "", header = FALSE)

file <- "./UCI HAR Dataset 2/test/y_test.txt"
testActivity <- read.table(file, sep = "", header = FALSE)

file <- "./UCI HAR Dataset 2/test/X_test.txt"
testData <- read.table(file, sep = "", header = FALSE)

# read train data
file <- "./UCI HAR Dataset 2/train/subject_train.txt"
trainSubject <- read.table(file, sep = "", header = FALSE)

file <- "./UCI HAR Dataset 2/train/y_train.txt"
trainActivity <- read.table(file, sep = "", header = FALSE)

file <- "./UCI HAR Dataset 2/train/X_train.txt"
trainData <- read.table(file, sep = "", header = FALSE)


# 1) MERGE SETS
testSet <- cbind(testSubject, testActivity, testData)
trainSet <- cbind(trainSubject, trainActivity, trainData)
fullSet <- rbind(testSet,trainSet)



# 2) EXTRACT MEAN AND STD COLUMNS
# "extractedSet" is the data.frame which contains the subset of columns with the 
# mean and std.

file <- "./UCI HAR Dataset 2/features.txt"
features <- read.table(file, sep = "", header = FALSE)
indexes <- grepl("mean",features[,"V2"]) | grepl("std",features[,"V2"])
reducedFeatures <- features[indexes,2]
reducedSet <- fullSet[,3:563]

extractedSet <- reducedSet[,indexes]
names(extractedSet) <- reducedFeatures


# 3) REPLACE ACTIVITY NUMBERS WITH ACTIVITY NAMES
fullSet[fullSet[,2] == 1, 2] <- "walking"
fullSet[fullSet[,2] == 2, 2] <- "walking_upstairs"
fullSet[fullSet[,2] == 3, 2] <- "walking_downstairs"
fullSet[fullSet[,2] == 4, 2] <- "sitting"
fullSet[fullSet[,2] == 5, 2] <- "standing"
fullSet[fullSet[,2] == 6, 2] <- "laying"


# 4) LABEL THE DATA WITH VARIABLE NAMES
featuresNames <- as.character(features[,2])
dataNames <- c("subject","activity",featuresNames)
colnames(fullSet) <- dataNames


# 5) NEW DATA SET WITH AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH 
# SUBJECT
# the data frame "newSet" contains the average for each variable for the
# corresponding subject and activity
newDataSet <- aggregate(fullSet[3:563],
                    list(subject = fullSet$subject, activity = fullSet$activity),
                    mean)
write.table(newDataSet, "newData.txt")
