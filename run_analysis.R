##
## Getting and Cleaning Data Course Project
##
## run_analysis.R Script 06/2015 JBlohm
##

## If not already done: install.packages("data.table")
## (data.table used for convenience and speed)
## Good info source: http://www.cookbook-r.com/Data_input_and_output/Loading_data_from_a_file/
library(data.table)

## Read table of all features 
features_dt <- data.table(read.csv("./UCI HAR Dataset/features.txt", header=FALSE, sep=" ", col.names=c("feature_id", "feature")))

## Read table of activity labels 
activity_labels_dt <- data.table(read.csv("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ", col.names=c("activity_id", "activity")))

## Read the subject id's of the training group
subject_train_dt <- data.table(read.csv("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep=" ", col.names=c("subject_id")))

## Read the subject id's of the training group
training_activity_class_dt <- data.table(read.csv("./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep=" ", col.names=c("activity_class")))

## Read the training time and frequency domain variables (561 columns)
## Assign the correct column names from features_dt
## Takes a few seconds to complete...
training_set_dt <- read.csv("./UCI HAR Dataset/train/X_train.txt",header=FALSE, sep="", col.names=features_dt$feature)



