# Code Book

### Study Design

Data for this project was as part of Coursera - **Getting and Cleaning Data Course Assignment**.

Original dataset can be found here: [link to Raw Data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
The dataset is part of [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The whole idea of the project is to apply data clening and data wrangling techniques in order to get tigy data. In order to do so, our procedure executes given major steps:

* download raw data
* merge training and test data sets into one dtaa set
* extract only specific variables from the data set
* apply cleaning techniques to clean names of the variables
* finally obtain tidy data set
* create additional data set by applying aggreation on tidy data


### Variables

The tidy data includes all variables from the original raw data set, where mean or standard deviation was calculated on original measurement. Additional to measurements variables we added variable called **subject**, which indicates ID of a person from whom the measurements were taken. And additional variable **label**, which indicates the activity done by person at time when measurement was taken. All measurement variables are standardized so values range between -1 (minimum) and 1 (maximum). 


### Summary choices

The produced tidy data by our priocedure is additionally **aggregted**. This aggregation includes **calcualting average values** for all measurements in the tidy data, where aggregation is partitioned for every **subject** and every **activity**.


### Detailed raw data description

After you run this procedure (main R script) you will obtain all raw data in your currewnt working directory. This folder also includes detail description of raw data. **README** file casn be found here (path to folder): 

**./data_raw/UCI HAR Dataset/README.txt**.







