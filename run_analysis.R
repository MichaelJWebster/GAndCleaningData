require(data.table)
#
# The run_analysis.R script creates a merged and tidy datasets from the
# Human Activity Recognition using Smartphones data. It performs the following
# tasks:
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each
#    variable for each activity and each subject. 
#
# To run the code from a directory that contains the dataset in a subdirectory
# called "UCI_HAR_Dataset", run the following commands in R:
#
# > source("run_analysis.R")
# > tdset <- run_analysis()
#
# At this point:
# - tdset will be a data table containing a tidy dataset.
# - Your working directory will contain the merged dataset in a file
#   "merged.csv".
# - Your working directory will contain another file called tidy_dset.csv that
#   contains the same dataset as in the tdset variable.
#
run_analysis <- function(dir="UCI_HAR_Dataset", merged.file.name="merged.txt",
                         tidy.dset.name="tidy_dset.txt") {
    # Run the required analysis on the Human Activity Recognition using
    # smartphones dataset by:
    #
    # 1. Merge the training and test data sets to create 1 dataset, where:
    #    - The merged dataset contains only the mean and std deviation for each
    #      measurment in the original dataset.
    #    - The merged dataset uses descriptive activity names to label the
    #      activities in the dataset.
    #    - The merged datset has descriptive variable names.
    # 2. Creates a second, independent tidy dataset with the average of each
    #    variable for each activity and each subject.
    # 3. Save these two datasets in a tidy format.
    #
    # Args:
    #   dir: The name of the directory containing the data set.
    #
    # Returns:
    #  The second independend data set created.
    #
    if (file.exists(merged.file.name)) {
        merged.complete <-
            fread(merged.file.name)
            #read.csv(merged.file.name, header=TRUE, check.names=FALSE)
    }
    else {
        merged.complete <- merge.complete(dir)
        write.csv(merged.complete, file=merged.file.name)
    }

    tidy.dset <- create.tidy.dset(merged.complete)
    write.csv(tidy.dset, file=tidy.dset.name)
    return(tidy.dset)
}

create.tidy.dset <- function(dt) {
    # Create a tidy data set from the supplied merged Human activity recognition
    # dataset.
    #
    # Args:
    #  dt:       The human activity dataset, with training and test results
    #            merged, and only standard deviation and mean results.
    #
    # Returns:
    #  A tidy dataset containing the averages of all values for each field
    #  one for each subject/activity pair.
    # 
    y <- dt[, lapply(.SD, mean), by=list(Subject, Activity_ID, Activity),
            .SDcols=5:length(colnames(dt))]
    return(y)
}

merge.complete <- function(dir="UCI_HAR_Dataset") {
    # Read in the test and training datasets under the supplied directory, and
    # return a data table containing a tidied dataset created by merging to
    # training and test data, and only including the mean and std deviations
    # for each measurement.
    #
    # Args:
    #   dir:      The name of the directory under which the Human Activity
    #             dataset using smartphones is contained.
    #
    # Returns:
    #   A data table containing the merged training and test data sets with
    #   columns containing the mean and standard deviation calculations.
    #
    test.dset <- get.dset(dir=dir, globals=global.data, dset=test.data)
    train.dset <- get.dset(dir=dir, globals=global.data, dset=train.data)
    merged.dset <- merge(test.dset, train.dset, by=colnames(test.dset), all=TRUE)
    setkey(merged.dset, "Subject")
    return(merged.dset)
    
}

get.dset <- function(dir="UCI_HAR_Dataset",
                     globals=global.data, dset=test.data) {
    # Create a data set from files read under the supplied directory "dir" where
    # the filenames for each relevant file is passed in in either list globals
    # or dset. The dataset returned includes all rows of the unprocessed
    # features data, but only includes the observation columns for standard
    # deviations and means.
    #
    # Args:
    #  dir:        The name of the directory under which the whole data set is
    #              stored.
    #  globals:    A list containing names of the features and activity label
    #              files.
    #  dset:       A list containing the names of files containing the actual
    #              recorded data.
    #
    # Returns:
    # A data table containing one of the test or training data sets extracted
    # as described above.
    #
    act.labels.fname <-     paste(dir, "/", globals$act.labels, sep="")
    feat.fname <-           paste(dir, "/", globals$features, sep="")
    subj.fname <-           paste(dir, "/", dset$subjects, sep="")
    acts.fname <-           paste(dir, "/", dset$acts, sep="")
    readings.fname <-       paste(dir, "/", dset$readings, sep="")

    # Get the subjects as the first column.
    subs.col <- get.col(fname=subj.fname, col.name="Subject")
    # Get the activities as the second column.
    acts.col <- get.col(fname=acts.fname, col.name="Activity_ID")
    # Get a column of activities with descriptive labels.
    acts.descriptive.col <- get.activity.column(fname=acts.fname,
                                                activity.labels=act.labels.fname)

    # Get a datframe containing the measurements of the various features with
    # descriptive column names.
    d.t <- data.table(get.data(readings.fname, feat.fname))

    #
    # Create a new dataframe that only includes the mean and standard deviations
    # for each measurement.
    #
    rexp <- ".*-(mean|std)\\(.*"
    cols <- grep(rexp, colnames(d.t), ignore.case=TRUE)
    d.t <- d.t[, cols, with=FALSE]
    old.cnames <- colnames(d.t)
    cnames <-  sapply(old.cnames,
                      function(s) {
                          new.str <- gsub("\\(\\)", "", s);
                          new.str <- gsub("(\\(|\\)|,|-)", "_", new.str);
                          new.str},
                      USE.NAMES=FALSE)
    setnames(d.t, old.cnames, cnames)
    d.t <- cbind(subs.col,acts.col, acts.descriptive.col, d.t)
    return(d.t)
}



#
# Utility functions
#
get.data <- function(fname, feat.name) {
    #
    # Read in the data from the supplied filename, using the features data as
    # column names.
    #
    # Args:
    #  fname: The name of the file containing the observations for each of the
    #         features
    #  feat.name: The name of the file containing the list of names of each
    #         of the features being measured.
    #
    # Returns:
    # A data frame containing columns of the different observations of the
    # various features being measured for each test case.
    #
    f <- get.features(feat.name)
    d <- read.table(fname, col.names=f[1,], check.names=FALSE)
    return(d)
}

get.features <- function(fname) {
    # Get data from the features.txt file as an array of 1 row by X 561 columns.
    #
    # Args:
    # fname:    The name of the file containing the features column names.
    #
    # Returns:
    # A row of data containing the names of the features.
    #
    d.t <- get.rows(fname)
    x <- d.t[[2]]
    dim(x) <- c(1, length(x))
    return(x)
}    


##
## Get the activity column in human readable form.
##
##
get.activity.column <- function (fname = "UCI_HAR_Dataset/test/y_test.txt",
                                 activity.labels = "UCI_HAR_Dataset/activity_labels.txt") {
    activity.labels <- get.rows(fname=activity.labels)
    act.df <- get.col(fname=fname)
    activities <- sapply(act.df, function(el) { e <- as.integer(el); return(activity.labels[[e, 2]])})
    dim(activities) <- c(length(activities), 1)
    colnames(activities) <- "Activity"
    return(activities)
}

get.col <-
    function(fname="./UCI_HAR_Dataset/test/subject_test.txt", col.name=NULL) {
        # Read the data in the file with the supplied fname, and return it as an
        # array with 1 column. If col.name is not NULL, add the name supplied as
        # the column name for the returned array.
        #
        # Args:
        #   fname:      The name of the file we are reading column data from.
        #               The file must contain a single column of data.
        #   col.name:   A name to give the column in the returned array.
        #
        # Returns:
        # A 1 column array containing the data read from the file fname, and with
        # colname = col.name.
        #
        d.t <- get.rows(fname=fname)
        if (is.null(col.name)) {
            col.name <- colnames(d.t)[1]
        }
        x <- d.t[[1]]
        dim(x) <- c(length(x), 1)
        colnames(x) <- col.name
        return(x)
}

get.rows <- function(fname="./UCI_HAR_Dataset/test/subject_test.txt") {
    # Read and return a data.table containning the data read from the file with
    # with the given name.
    #
    # Args:
    #   fname:    The name of the file to be read.
    #
    # Returns:
    #   A data table containing the data read from the file.
    #    
    return(fread(fname))
}


#
# Some Constants that map variable names to the various files in the dataset
# that we are interested in.
#

#
# Global files, containing the activity labels and features for all the test
# runs.
#
global.data <- list(act.labels = "activity_labels.txt", features="features.txt")

#
# Test subject data files.
#
test.data <- list(subjects="test/subject_test.txt", acts="test/y_test.txt",
                  readings="test/X_test.txt")

#
# Training subject data files.
#
train.data <- list(subjects="train/subject_train.txt", acts="train/y_train.txt",
                  readings="train/X_train.txt")

    
