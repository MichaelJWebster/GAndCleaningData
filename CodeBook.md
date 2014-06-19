## Getting and Cleaning Data Project CodeBook

This repository contains code to perform data cleaning on the **Human Activity
Recognition Using Smartphones Data Set**, as well as a couple of cleaned up
datasets extracted from the original dataset.

###Raw Data

The dataset and it's description can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).


###Cleaned up Datasets

The two cleaned up datasets contained in this repository are:

* merged.csv
  * Merges the test subject and training subject data into the one dataset
  * Contains only the mean and standard deviation variables for each measurement.
* tidy_dset.csv
  * Same as merged .csv, but replaces multiple observations for each combination
  of subject and activity, with a single average value of all those results.

#### The tidy_dset.csv dataset

The **tidy_dset.csv** dataset contains tabular data like the following:

|   |    |Subject | Activity_ID | Activity         | tBodyAcc-mean()-Y    | contd.... |
|:-:|:-:|:--------|:---------:|:-----------------|---------------------:|:-------------|
|1  | 1 |      1  |         1 |  WALKING         | -0.017383819         | ... |
|2 |  2 |      1  |   2       | WALKING_UPSTAIRS |     -0.023953149     | ... |
|3 |  3 |      1  |  3        | WALKING_DOWNSTAIRS  |    -0.009918505   | ... |
|4 |  4 |      1  |  4        | SITTING           |   -0.001308288      | ... |
| 5 |  5 |    1   |  5        |  STANDING         | -0.016137590        | ... |
|6  | 6  |    1   |  6        |  LAYING           | -0.040513953        | ... |
| 7  | 7 |    2   |  1        |  WALKING          | -0.018594920        | ... |
| 8  | 8  |   2   |  2        | WALKING_UPSTAIRS  |    -0.021412113     | ... |
| 9  | 9  |  2    |  3        | WALKING_DOWNSTAIRS | -0.022661416       | ... |
| 10 | 10 |  2    |  4        | SITTING            |     -0.015687994   | ... |
| :  | :  |  :    |  :        |  :                 |  :                 | :......|

So, for each subject identified in the *Subject* column, and for each activity as
identified in the *Activity* column, we have a recorded a series of averages of the
mean and standard deviations recorded for those measurements. The names of the
measurements can be seen in R by running:

```R
> tidy.data <- read.csv("tidy_dset.csv", check.names=FALSE)
> colnames(tidy.data)[5:ncol(tidy.data)]
```
#### The merged.csv dataset

The dataset contained in the **merged.csv** file has the same columns as does
**tidy_dset.csv**. **merged.csv** however,  contains all the mean and std
deviation measurements obtained from the raw data set.





