# Readme

Below we explain what each file in the project folder does. The project folder (named **tidy-data**) should contain given files:

*  *run_analysis.R*
*  *package_check.R*
*  *data_tidy.txt*
*  *CODE_BOOK.md*
*  *README.md*
*  *tidy-data.Rproj*


### run_analysis.R 

Main **R** script of the project folder, this script executes the whole procedure of data collection, data cleaning and creating tidy data.

Script first loads neccessary libraries (using script **package_check.R**).

Then raw data is downloaded-unzipped and stored to folder **data_raw**.

After raw data is unzipped, the script loads all neccessary .txt files regarding test and train dataset and corresponding labels and feature names. 

Imported data sets does not have headers, so adequate column names are added to the tables. Then all data sets are merged into one data frame called **df_tidy**.

From the original merged data frame we only keep variables such as:

* subject (indicating who was measured ID)
* label (indicating what activity was done)
* variables that include mean values
* variables that include standard deviation values 

One major step od the procedure is renaming measurement columns, in order to get more descriptive names. This operation is done using regular expressions and R's functions to rename each part of variable name using more descriptive counterpart.

After renaming is finished we obtain a tidy dataset.

On this tidy data set we apply aggreation function in order to calculate the average of each measurement (in the tidy data set) per each subject and each label. 

St teh end the aggregated tidy dataset is exported from R's workspace to project folder. The name of the file is **data_tidy.txt**.


### package_check.R 

R script to install and/or load neccessary R libraries.


### data_tidy.txt

Final aggregated tidy dataset, which is exported when main R script is executed.



### CODE_BOOK.md

Code book of the project. Describing the study design, variables of the tidy dataset and summary choices.


### README.md

Readme file of the project (currently read file!). 


### tidy-data.Rproj

RStudio's project file. This file can be opened from RStudio in order to run the procedure of this project.


