library(dplyr)
#Get variable names and activity labels from master folder
setwd("~/R/Coursera/Cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
features<-read.table('features.txt', header = FALSE)
activities<-read.table('activity_labels.txt', header = FALSE)
#Get train data
setwd("~/R/Coursera/Cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train")
xTrain<-read.table("X_train.txt", quote="\"", comment.char="")
yTrain<-read.table('y_train.txt')
#Get test data
setwd("~/R/Coursera/Cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test")
xTest<- read.table("X_test.txt", quote="\"", comment.char="")
yTest<-read.table('y_test.txt', header = FALSE)
#Label variables
colnames(xTrain)<-features[,2]
colnames(xTest)<-features[,2]
colnames(yTrain)<-"Activity"
colnames(yTest)<-"Activity"
#Combine x and y into single sets
train=cbind(yTrain,xTrain)
test=cbind(yTest, xTest)
#Combine train and test data
df=as.data.frame(rbind(train,test))
#Remove intermediate step dataframes
rm(test,train,xTest,yTest,yTrain,xTrain)
#Find indeces for mean and standard deviation columns
meancols<-grep("mean()",colnames(df))
stdcols<-grep("std()",colnames(df))
#Join indices into one object
datacols<-c(meancols,stdcols)
#Extract data with mean and std. dev variables only
data<-df[,c(1,datacols)]
#Label activities
data<-merge(data,activities, by.x="Activity", by.y="V1")
data$Activity<-data$V2
#Create separate data set
data<-as_tibble(data)
#Summarize all variables
data2<-data%>%group_by(Activity)%>%summarise_all(list(mean))