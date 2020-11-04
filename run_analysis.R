# Run Analysis (main R script to get & clean the course project data)

# author: Marko intihar

graphics.off()
rm(list = ls())


# Load R packages
packages <- c("tidyverse", "data.table") # list of packages to load
source("package_check.R") # load or install & load list of packages


# Download & unzip the data
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "./data_raw/data.zip")
unzip(zipfile = "./data_raw/data.zip", exdir = "./data_raw", overwrite = T, )


# Load data

## Get path to root data folder
path_data <- list.files("./data_raw") %>% 
  str_subset(string = ., pattern = "UCI") %>% 
  paste0("./data_raw/", .)

## Get path to train folder
path_data_train <- list.files("./data_raw") %>% 
  str_subset(string = ., pattern = "UCI") %>% 
  paste0("./data_raw/", ., "/train")

## Get path to test folder
path_data_test <- list.files("./data_raw") %>% 
  str_subset(string = ., pattern = "UCI") %>% 
  paste0("./data_raw/", ., "/test")

X_train <- fread(file = paste0(path_data_train, "/X_train.txt")) # train data set features
y_train <- fread(file = paste0(path_data_train, "/y_train.txt")) # train data set labels
subject_train <- fread(file = paste0(path_data_train, "/subject_train.txt")) # train data set subject ID

X_test <-  fread(file = paste0(path_data_test, "/X_test.txt"))    # train data set features
y_test <-  fread(file = paste0(path_data_test, "/y_test.txt"))    # train data set labels
subject_test <- fread(file = paste0(path_data_test, "/subject_test.txt")) # train data set subject ID

feature_names   <- fread(file = paste0(path_data, "/features.txt")) %>% pull(2) # vector of names of the features  
activity_labels <- fread(file = paste0(path_data, "/activity_labels.txt"))  # activity labels  



# Add column names to imported data sets
colnames(X_train) <- feature_names
colnames(y_train) <- "label"
colnames(subject_train) <- "subject"
colnames(X_test) <- feature_names
colnames(y_test) <- "label"
colnames(subject_test) <- "subject"
colnames(activity_labels) <- c("label", "activity")


# Merge training and test data sets
#  - first bind column wise feature-label then row wise train test data set
df <- bind_rows(bind_cols(X_train, subject_train, y_train),
                bind_cols(X_test,  subject_test,  y_test))





        

