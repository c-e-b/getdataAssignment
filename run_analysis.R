# download zip-file to folder "pdata" and extract it there -> folder "UCI HAR Dataset" is inside "pdata"
if(!file.exists("./pdata")){dir.create("./pdata")}
projUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(projUrl, destfile = "./pdata/projData.zip", method = "curl")
unzip("./pdata/projData.zip", exdir = "./pdata")

# read test data and add subjects and activities as further columns (by using cbind)
testData = read.csv("./pdata/UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "")
testSubjects = read.csv("./pdata/UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = "")
testActivities = read.csv("./pdata/UCI HAR Dataset/test/y_test.txt", header = FALSE, sep = "")
testData = cbind(testData, testSubjects, testActivities)

# read training data and add subjects and activities as further columns (by using cbind)
trainData = read.csv("./pdata/UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "")
trainSubjects = read.csv("./pdata/UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = "")
trainActivities = read.csv("./pdata/UCI HAR Dataset/train/y_train.txt", header = FALSE, sep = "")
trainData = cbind(trainData, trainSubjects, trainActivities)

# merge test and train data by using rbind (trainData is added "below" testData)
mergedData = rbind(testData, trainData)

# read activity labels
actLabels = read.csv("./pdata/UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = "")

# read features and make them "nicer"
features = read.csv("./pdata/UCI HAR Dataset/features.txt", header = FALSE, sep = "")
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

# we only want mean and standard deviation values plus the columns subject(=562) and acitivity(=563)
featureRowsWanted = grep(".*Mean.*|.*Std.*", features[,2])
featuresWanted = features[featureRowsWanted,]
actColsWanted = c(featureRowsWanted, 562, 563)

# now we really choose the mean+std+subject+activity columns from the merged dataset
mergedMeanStdData = mergedData[,actColsWanted]
# add column names
colnames(mergedMeanStdData) <- c(featuresWanted$V2, "Subject", "Activity")
# make them all lower case to be more tidy
colnames(mergedMeanStdData) <- tolower(colnames(mergedMeanStdData))

# we replace the index of the activity with its real name by means of a for loop that runs through all 6 activities
actIndex = 1
for (actName in actLabels$V2) {
        mergedMeanStdData$activity = gsub(actIndex, actName, mergedMeanStdData$activity)
        actIndex = actIndex + 1
}

# subject and activity are made into factor variables to be able to group by them (function aggregate)
mergedMeanStdData$subject <- as.factor(mergedMeanStdData$subject)
mergedMeanStdData$activity <- as.factor(mergedMeanStdData$activity)

# aggregate the data by subject and activity -> mean of every variable considering every subject and every activity of that subject are calculated
tidy = aggregate(mergedMeanStdData, by=list(subject=mergedMeanStdData$subject, activity=mergedMeanStdData$activity), mean)
# since we grouped by subject and activity the last two columns don't make sense anymore and we make them NULL
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")
head(tidy)
