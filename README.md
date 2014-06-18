## Getting and Cleaning Data Project Repository

This repository contains code to perform data cleaning on the **Human Activity
Recognition Using Smartphones Data Set**, as well as a couple of cleaned up
datasets extracted from the original dataset.

###Contents

The repository contains the following files:

* run_analysis.R: R code to clean the data from the raw dataset and produce a
tidy and a merged dataset as output,
* merged.csv: A dataset containing mean and standard deviation measurements from
the raw data set, and with the test and training groups of data merged into the
one dataset,
* tidy_dset.csv: A dataset containing the averages of the data in merged.csv
for each combination of subject and activity.

### The run_analysis script

The run_analysis.R script creates merged and tidy datasets from the
Human Activity Recognition using Smartphones data. It performs the following
tasks:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each
   measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each
   variable for each activity and each subject. 

To run the code from a directory that contains the dataset in a subdirectory
called **UCI_HAR_Dataset**, run the following commands in R:
    > source("run_analysis.R")
    > tdset <- run_analysis()

At this point:
- **tdset** will be a data table containing a tidy dataset.
- Your working directory will contain the merged dataset in a file
**merged.csv**.
- Your working directory will contain another file called **tidy_dset.csv**
that contains the same dataset as in the tdset variable.

The output file names and the location of the directory containing the raw
dataset can be specified to the run_analysis function using named arguments.
Please see the code for how to do this.
