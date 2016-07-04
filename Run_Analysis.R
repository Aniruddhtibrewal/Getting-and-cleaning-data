library(dplyr)
library(data.table)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

setwd("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset")


#Import test and train feature data sets###
test <- read.table("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset/test/X_test.txt")
train <- read.table("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset/train/X_train.txt")
##join test and train feature data set##
all_data <- rbind(test, train)

#download features names data and identify mean and sdev features##
feature <- read.table("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset/features.txt")
feature_names <- feature[,2]
feature_names <- as.character(feature_names)
colnames(all_data) <- c(feature_names)
featurerequired <- feature_names[grep(".*mean.*|.*std.*", feature_names)]

#filter data for required features##
all_data_required  <- all_data[,(featurerequired)]

##Download and create subject datasets##
test_subject <- read.table("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset/test/subject_test.txt")
train_subject <- read.table("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset/train/subject_train.txt")
all_subject <- rbind(test_subject,train_subject)
colnames(all_subject) <- ("Subject")

##Download and create activity datasets##
test_activity <- read.table("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset/test/Y_test.txt")
train_activity <- read.table("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset/train/Y_train.txt")
all_activity <- rbind(test_activity,train_activity)
colnames(all_activity) <- ("Activity")

##combine feature, avtivity and subject datasets##
final_data <- cbind(all_activity,all_subject,all_data_required)

## tidy column names to meaninful names###
colnames(final_data) <- gsub('-mean','- Mean',colnames(final_data))
colnames(final_data) <- gsub('-std','- Standard  Deviation',colnames(final_data))
colnames(final_data) <- gsub('[()]',' ',colnames(final_data))

##Assign names to activity list###
activity_labels <- read.table("/Users/aniruddhtibrewal/Documents/Training/UCI HAR Dataset/activity_labels.txt")
final_data$Activity <- factor(final_data$Activity, levels = activity_labels[,1], labels = activity_labels[,2])

#summarize data to calcualte mean and standard deviation##
final_data <-data.table(final_data)
final_result <- final_data[,lapply(.SD, mean), by = c("Activity", "Subject")]

##Exporty the tidy dataset##
write.table(final_result, "final_result.txt", row.names = FALSE, quote = FALSE)
