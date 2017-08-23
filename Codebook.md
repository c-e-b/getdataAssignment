Getting and Cleaning Data - Course Project for Week 4
=====================================================

This file describes the final data and the script I wrote.

For the purpose of the Getting and Cleaning Data course project a dataset from https://d396qusza40orc.cloudfront.net/ is used. The data set is well-describes in its README.txt (after performing run_analysis.R you can find it in "'YOUR-WORKING-DIRECTORY'/pdata/UCI HAR Dataset/"). The training and test data from this data set is merged, subject and activity columns are added, only those columns with mean or standard deviation are picked, the column names (features) are added, activity identifiers are replaced by real names and then the data is grouped by subject and activity. At the end a tidy dataset is exported as .txt file in the users working directory.

More detailed - I wrote a script that does:
        # download zip-file (from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip") to folder "pdata" and extract it there -> folder "UCI HAR Dataset" is inside "pdata"
        # read test data and add subjects and activities as further columns (by using cbind)
        # read training data and add subjects and activities as further columns (by using cbind)
        # merge test and train data by using rbind (trainData is added "below" testData)
        # read activity labels
        # read features and make them "nicer"
        # we only want mean and standard deviation values plus the columns subject(=562) and acitivity(=563)
        # now we really choose the mean+std+subject+activity columns from the merged dataset
        # add column names
        # make them all lower case to be more tidy
        # we replace the index of the activity with its real name by means of a for loop that runs through all 6 activities
        # subject and activity are made into factor variables to be able to group by them (function aggregate)
        # aggregate the data by subject and activity -> mean of every variable considering every subject and every activity of that subject are calculated
        # since we grouped by subject and activity the last two columns don't make sense anymore and we make them NULL
+ in the step before the last step the tidy dataset is saved as tidy.txt in your working directory (not in /pdata)
+ the last step shows the head of tidy

Each observation in tidy.txt corresponds to the mean of one subject doing one activity. Each column represents a variable (where the first two columns represent the factor variables subject and activity by which was grouped). Since 30 subjects did 6 activities each, tidy.txt consists of 180 (=30*6) observations.