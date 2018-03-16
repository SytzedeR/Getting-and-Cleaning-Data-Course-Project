##library packages
library(dplyr)

##read all datasets
xtrain<-read.table("./train/X_train.txt")
ytrain<-read.table("./train/Y_train.txt")
xtest<-read.table("./test/X_test.txt")
ytest<-read.table("./test/Y_test.txt")
testsubj<-read.table("./test/subject_test.txt")
trainsubj<-read.table("./train/subject_train.txt")
actlab<-read.table("./activity_labels.txt")
feat<-read.table("features.txt")

##create column names
colnames(testsubj)<-"subject"
colnames(trainsubj)<-"subject"
colnames(xtrain)<-feat[,2]
colnames(xtest)<-feat[,2]

##combine train and test data
data<-rbind(xtrain, xtest)
labels<-rbind(ytrain, ytest)
subjects<-rbind(trainsubj, testsubj)

##merge labels with description of labels
labels<-merge(labels, actlab, by=1)[,2]

##add subjects and labels to the data
df<-cbind(subjects, labels, data)

##find and select columns with mean or std data
newcolumns<-grep("mean|std", colnames(df))
df2<-df[,c(1,2,newcolumns)]

##create new dataset with means
df3<-group_by(df2, subject, labels)
df4<-summarise_all(df3, mean)

##save dataset for upload
write.table(df4, file = "tidydata.txt", row.name = FALSE)