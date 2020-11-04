# Run Analysis (main R script to get & clean the course project data)

# author: Marko intihar

# Main script to clean raw data and prepare tidy data
# For more details check files "CODE_BOOK.txt" & "README.md"

graphics.off()
rm(list = ls())


# Load R packages
packages <- c("tidyverse", "data.table") # list of packages to load
source("package_check.R") # load or install & load list of packages


# Download & unzip the data

### first create folder for storing raw data
if(!dir.exists(paths = "./data_raw")){
  dir.create(path = "./data_raw") 
}

### download zip folder
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "./data_raw/data.zip")

### unzip zip folder
unzip(zipfile = "./data_raw/data.zip", exdir = "./data_raw", overwrite = T)


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
df_tidy <- bind_rows(bind_cols(X_train, subject_train, y_train),
                bind_cols(X_test,  subject_test,  y_test))


# Extract only measurements on mean & std

### grab only relevant columns using Regex
columns_keep <- df_tidy %>% 
  colnames() %>% 
  grepl(x = ., pattern = "mean\\(\\)|std\\(\\)|subject|label") %>% 
  which(. == T)

### keep only relevant columns
df_tidy <- df_tidy %>% select(all_of(columns_keep))


# Add descriptive activity names
df_tidy <- df_tidy %>% 
  left_join(x = ., y = activity_labels, by = "label") %>%  # first merge df_tidy & activity_labels (to get names)
  mutate(activity_ = str_replace(string = tolower(activity),       # change activity to lower case and remove "_"
                                 pattern = "_", replacement = " ")) %>% 
  select(-c("label", "activity")) %>% # drop old activity names and label column
  rename(activity = activity_) %>%  # rename activity column
  select(subject, activity, everything()) # rearrange columns
    

# Create descriptive variable names

names_old <- df_tidy %>% colnames() ### store current (old) column names

### rename old names using Regex (we would like to have more informative labels)
names_new <- names_old %>% 
  str_replace(string = ., pattern = "^t", replacement = "time ") %>%           # replace "t" at the beginning for "time"
  str_replace(string = ., pattern = "^f", replacement = "frequency ") %>%      # replace "f" at the beginning for "frequency"
  str_replace_all(string = ., pattern = "Body", replacement = "body ") %>%     # replace "Body" for "body"
  str_replace(string = ., pattern = "Gravity", replacement = "gravity ") %>%   # replace "Gravity" for "gravity"
  str_replace(string = ., pattern = "Acc", replacement = "accelerometer") %>%  # replace "Acc" for "accelerometer"
  str_replace(string = ., pattern = "Gyro", replacement = "gyroscope") %>%     # replace "Gyro" for "gyroscope"
  str_replace(string = ., pattern = "Jerk", replacement = " jerk") %>%         # replace "Jerk" for "jerk"
  str_replace(string = ., pattern = "Mag", replacement = " magnitude") %>%     # replace "Mag" for "magnitude"
  str_replace(string = ., pattern = "X$", replacement = "X direction") %>%     # replace "X" for "X direction"
  str_replace(string = ., pattern = "Y$", replacement = "Y direction") %>%     # replace "Y" for "Y direction"
  str_replace(string = ., pattern = "Z$", replacement = "Z direction") %>%     # replace "Z" for "Z direction"
  data.frame(old = names_old, new = .) %>%   # create a data frame of old VS new names
  # add flag for mean and std variable
  mutate(type_of_var = case_when(str_detect(string = new, pattern = "-mean") ~ "mean",
                                 str_detect(string = new, pattern = "-std")  ~ "std",
                                 T ~ "NA")) %>% 
  # add prefix for mean or std variables
  mutate(new = case_when(type_of_var == "mean" ~ paste0("mean of ", new),
                         type_of_var == "std" ~ paste0("standard deviation of ", new),
                         T ~ new)) %>% 
  mutate(new = gsub(x = new, pattern = "mean\\(\\)|std\\(\\)", replacement = ""),
         new = str_replace_all(string = new, pattern = "-", replacement = " "))

### rename tidy data frame columns
colnames(df_tidy) <- names_new %>% pull(new)


# remove some temporary objects from workspace
rm(names_new, names_old, package.check, columns_keep, path_data, path_data_train, path_data_test, activity_labels)


# Create average of each variable per subject & activity
df_tidy_average <- df_tidy %>% 
  group_by(subject, activity) %>%       # group data per subject and activity
  summarise_all(.tbl = ., .funs = mean) # calculate average of each variable

### rename columns
colnames(df_tidy_average) <- c(colnames(df_tidy_average[1:2]),
                               paste0("average of ", colnames(df_tidy_average[3:ncol(df_tidy_average)])))


# Export aggregated tidy data set
write.table(x = df_tidy_average, file = "data_tidy.txt", row.name = FALSE, sep = "\t") 


