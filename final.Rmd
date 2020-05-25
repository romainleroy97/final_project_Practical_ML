---
title: "Final"
author: "Romain LEROY"
date: "24/05/2020"
output: html_document
---
Final Exam: Topics to Financial Econometrics


Data Description 

At first, we load the two datasets we have for the exam: the train data set that allows us to make the Machine Learning Algorithm and test it. The Final base is the data set where the 20 questions for the final exam is. 

```{r}
library('lattice')
library('ggplot2')
library('caret')
library('dplyr')

train_base = read.csv('C:/Users/romai/Documents/EDHEC/M1/S2/TTFE/final/pml-training.csv', header=T)
final_base = read.csv('C:/Users/romai/Documents/EDHEC/M1/S2/TTFE/final/pml-testing.csv', header=T)
``` 

The final base data is composed of 20 rows and 160 columns. The train base data is composed of 19622 rows and 160 columns too. Final base and train base have the same columns except for the final one, since train base have the results and not the final base. 

```{r}
dim(final_base)
dim(train_base)
```

With the function head(), we can show the name of the different columns in the data: 

```{r}
dim(final_base)
```

As we can see looking directly in the data file, a lot of columns have plenty of N/A or plenty of empty cells. Therefore, we have to clean the data. I decided to remove the column manually because the function is.na() does not work on one data set and I do not find a solution. Moreover, I could code the cleaning with a if and for conditions. However, it would have decrease the speed of the algorithm, which is not interesting for us. 

```{r}
final_base = final_base[,c(8:11,37:49,60:68,84:86,102,113:124,140,151:160)]
dim(final_base) 
train_base = train_base[,c(8:11,37:49,60:68,84:86,102,113:124,140,151:160)]
dim(train_base)
```

After deleting the data with N/A, empty cells and rows containing date and username, we have now 53 columns that are relevant for the Machine Learning implementation. 


We make a Cross Validation of the train_base in order to have a train set and a test set for the Machine Learning. Wwe decided to take p =0.7, i.e. 70% of the data set for the train set and 30% for the test set. We set set.seed(23139) in order to have the same data set when we restart the cross validation, and so have the same result in the Machine Learning

```{r}
set.seed(23139) 
cv <- createDataPartition(train_base$classe, p=0.70, list=F)
data_train <- train_base[cv, ]
data_test <- train_base[-cv, ]
```

We want to predict in which manner an athlete perform well an exercise, which is complied in the column “classe”, with 5 grades: [A,B,C,D,E]. Therefore, it seems obvious that the best Machine Learning technique will be a decision tree. Since we want the best accuracy possible, a random forest analysis will be better than a decision tree, because it is a collection of decision tree. 

```{r}
controlRf <- trainControl(method="cv", 5)
modfit <- train(classe ~ ., data= data_train, method="rf", trControl=controlRf, ntree=250)
modfit
```

As a result, we have an accuracy of 0.99 with our method, which is very good. 

We apply then our algorithm to our data_test, in order to validate our result before the final test. 

```{r}
pred <- predict(modfit,data_test)
confusionMatrix(table(data_test$classe, pred)) 
```

We have an accuracy on the data test of 0.9908, which is very good. Therefore, we can apply our algorithm to the final test data in order to have the result. At first, we remove the “id_number” column (the last one), since it is not relevant for the algorithm. 

```{r}
final_base = final_base[,-53]
final <- predict(modfit,final_base)
final
```

This is the result of the application of our ML random forest to the final data. 



