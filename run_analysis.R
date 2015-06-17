##
## Getting and Cleaning Data Course Project
##
## run_analysis.R Script 06/2015 JBlohm
##
## The whole script needs a few more seconds to run, ... be patient
##
## Open: include innertial signals?
##

## If not already done: install.packages("data.table")
## (data.table used for convenience and speed)
## Good info source: http://www.cookbook-r.com/Data_input_and_output/Loading_data_from_a_file/
library(data.table)
## If not already done: install.packages("dplyr")
library(dplyr)

####################################
## Get features and activity data ##
####################################

## Read table of all features 
features_dt <- data.table(read.csv("./UCI HAR Dataset/features.txt", header=FALSE, sep=" ", col.names=c("feature_id", "feature")))

## Read table of activity labels 
activity_labels_dt <- data.table(read.csv("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ", col.names=c("activity_id", "activity")))

#######################
## Get Training Data ##
#######################

## Read the subject id's of the training group
subject_train_dt <- data.table(read.csv("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep=" ", col.names=c("subject_id")))

## Read the subject id's of the training group
training_activity_class_dt <- data.table(read.csv("./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep=" ", col.names=c("activity_class")))

## Read the training time and frequency domain variables (561 columns)
## Assign the correct column names from features_dt
## Takes a few seconds to complete...
training_set_dt <- data.table(read.csv("./UCI HAR Dataset/train/X_train.txt",header=FALSE, sep="", col.names=features_dt$feature))

###################
## Get Test Data ##
###################

## Read the subject id's of the test group
subject_test_dt <- data.table(read.csv("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep=" ", col.names=c("subject_id")))

## Read the subject id's of the test group
test_activity_class_dt <- data.table(read.csv("./UCI HAR Dataset/test/y_test.txt", header=FALSE, sep=" ", col.names=c("activity_class")))

## Read the test time and frequency domain variables (561 columns)
## Assign the correct column names from features_dt
## Takes a few seconds to complete...
test_set_dt <- data.table(read.csv("./UCI HAR Dataset/test/X_test.txt",header=FALSE, sep="", col.names=features_dt$feature))

######################################
## Merging the training data tables ##
######################################

## Add a column "activity_class" to training_set_dt,
## based on data in training_activity_class_dt
training_set_dt <- mutate(training_set_dt, activity_class = training_activity_class_dt)

## Add a column "subject" to training_set_dt,
## based on data in subject_train_dt
training_set_dt <- mutate(training_set_dt, subject = subject_train_dt)

##################################
## Merging the test data tables ##
##################################

## Add a column "activity_class" to test_set_dt,
## based on data in test_activity_class_dt
test_set_dt <- mutate(test_set_dt, activity_class = test_activity_class_dt)

## Add a column "subject" to test_set_dt,
## based on data in subject_test_dt
test_set_dt <- mutate(test_set_dt, subject = subject_test_dt)





