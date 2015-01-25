
library(plyr)

data_dir <- "./data/UCI HAR Dataset"
merged_data <- list()


new_names <- function(col) {
        col <- gsub("tBody", "Time.Body", col)
        col <- gsub("tGravity", "Time.Gravity", col)
        col <- gsub("fBody", "FFT.Body", col)
        col <- gsub("fGravity", "FFT.Gravity", col)
        col <- gsub("\\-mean\\(\\)\\-", ".Mean.", col)
        col <- gsub("\\-std\\(\\)\\-", ".Std.", col)
        col <- gsub("\\-mean\\(\\)", ".Mean", col)
        col <- gsub("\\-std\\(\\)", ".Std", col)
        return(col)
}


## Read File from URL

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("data")) {
        dir.create("data")
}
if (!file.exists("./data/UCI HAR Dataset.zip")){
        download.file(fileUrl, destfile="data/UCI HAR Dataset.zip")       
     
}
unzip("data/UCI HAR Dataset.zip", exdir="./data")

## Merges the training and the test sets to create one data set.

merged_data$features <- read.table(paste(data_dir, "features.txt", sep="/"), col.names=c('id', 'name'), stringsAsFactors=FALSE)

merged_data$activity_labels <- read.table(paste(data_dir, "activity_labels.txt", sep="/"), col.names=c('id', 'Activity'))

merged_data$test <- cbind(subject=read.table(paste(data_dir, "test", "subject_test.txt", sep="/"), col.names="Subject"),
                          y=read.table(paste(data_dir, "test", "y_test.txt", sep="/"), col.names="Activity.ID"),
                          x=read.table(paste(data_dir, "test", "x_test.txt", sep="/")))

merged_data$train <- cbind(subject=read.table(paste(data_dir, "train", "subject_train.txt", sep="/"), col.names="Subject"),
                           y=read.table(paste(data_dir, "train", "y_train.txt", sep="/"), col.names="Activity.ID"),
                           x=read.table(paste(data_dir, "train", "X_train.txt", sep="/")))




## Extracts only the measurements on the mean and standard deviation for each measurement. 

mean_std <- rbind(merged_data$test, merged_data$train)[,c(1, 2, grep("mean\\(|std\\(", merged_data$features$name) + 2)]

## Rename columns using new_name function to  descriptive activity names 

names(mean_std) <- c("Subject", "Activity.ID", new_names(merged_data$features$name[grep("mean\\(|std\\(", merged_data$features$name)]))

## Appropriately labels the data set with descriptive  names. 

mean_std <- merge(mean_std, merged_data$activity_labels, by.x="Activity.ID", by.y="id")
mean_std <- mean_std[,!(names(mean_std) %in% c("Activity.ID"))]

## Creates a second, independent mean_std data set with the average of each variable for each activity and each subject.
mean_std.mean <- ddply(melt(mean_std, id.vars=c("Subject", "Activity")), .(Subject, Activity), summarise, MeanSamples=mean(value))
write.csv(mean_std.mean, file = "mean_std.txt",row.names = FALSE)
