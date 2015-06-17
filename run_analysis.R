##
## Getting and Cleaning Data Course Project
##
## run_analysis.R Script 06/2015 JBlohm
##
## The whole script needs a few more seconds to run, ... be patient
##
## Open: include innertial signals?
## Idea: Extract mean etc. values based in matching part of name -> list -> extract
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
activity_labels_dt <- data.table(read.csv("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ", col.names=c("activity_class", "activity")))

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

#####################################################
## Combining observations from training & test tables
#####################################################

## Put test group observations below training groups
data_set <- rbind(training_set_dt, test_set_dt)

#########################################################
## Extract only the measurements on the mean an std. dev.
## We also leave the subject and activity_class in here.
#########################################################

## Generate a list vector containing matching column indices grep(value=FALSE)
c_v <- grep(".mean.", names(test_set_dt), value=FALSE, fixed=TRUE)
c_v <- c(c_v, grep(".std.", names(test_set_dt), value=FALSE, fixed=TRUE))
c_v <- c(c_v, grep("subject", names(test_set_dt), value=FALSE, fixed=TRUE))
c_v <- c(c_v, grep("activity_class", names(test_set_dt), value=FALSE, fixed=TRUE))

## In dplyr you can subset on that list of indices
extracted_data_set <- select(data_set, c_v)

###############################################################################
## Now we have created our data_set with appropriate descriptive variable names
## We will now replace the activity id's with their descriptive activity names
###############################################################################

extracted_data_set <- left_join(extracted_data_set, activity_labels_dt, by="activity_class")

## We can remove the activit_class code, because we now have the named activity in the table
extracted_data_set <- select(extracted_data_set, -activity_class)

################################################################################
## Create the tidy data set with the average (mean) of each activity per subject
################################################################################
## This is a split, apply, combine problem:
## If not already done: install.packages("plyr")
library(plyr)

# melting & casting with averaging on activity and subject for all variables, calculating the mean
tidy_data_Melt <- melt(extracted_data_set,id=c("activity","subject"))
tidy_data <- dcast(tidy_data_Melt, activity+subject ~ variable, mean)

## Write table to .txt file:
write.table(tidy_data, "./tidy_data_set.txt", row.names=FALSE)



