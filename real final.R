library('lattice')
library('ggplot2')
library('caret')
library('dplyr')

train_base = read.csv('C:/Users/romai/Documents/EDHEC/M1/S2/TTFE/final/pml-training.csv', header=T)
final_base = read.csv('C:/Users/romai/Documents/EDHEC/M1/S2/TTFE/final/pml-testing.csv', header=T)

### We look at the dimension of the data (160 variables)
dim(final_base)
dim(train_base)
head(final_base,0)
head(train_base,0)

# Delete data ininteresting 
final_base = final_base[,c(8:11,37:49,60:68,84:86,102,113:124,140,151:160)]
dim(final_base) 
train_base = train_base[,c(8:11,37:49,60:68,84:86,102,113:124,140,151:160)]
dim(train_base)



#Data Slicing / Cross Validation 
set.seed(23139) # For reproducibile purpose
cv <- createDataPartition(train_base$classe, p=0.70, list=F)
data_train <- train_base[cv, ]
data_test <- train_base[-cv, ]

#Data modelling 
controlRf <- trainControl(method="cv", 5)
modfit <- train(classe ~ ., data= data_train, method="rf", trControl=controlRf, ntree=250)
modfit


#validation data set 
pred <- predict(modfit,data_test)
table(pred,data_test$classe)
length(data_test$classe)
length(pred)

confusionMatrix(table(data_test$classe, pred)) 

#testing set 
#Remove "id_number"

final_base = final_base[,-53]
final <- predict(modfit,final_base)
final