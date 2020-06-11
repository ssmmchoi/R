# chap16_3_XGboost

# xgboost vs randomForest
# - xgboost : boosting 방식 
# - randomForest : bagging 방식 

# 1. package install
install.packages("xgboost")
library(xgboost)

library(help="xgboost")

# 2. dataset load/search
data(agaricus.train)
data(agaricus.test)

train <- agaricus.train
test <- agaricus.test

str(train)
# x 변수로 사용할 변수들은 'data'라는 key에, y변수는 'label'이라는 key에
# 저장되어 있음
# label: num [1:6513] 1 0 0 1 0 0 0 1 0 0 ... 1차원 벡터 : 독 有無

# @ 는 객체에서 호출할 수 있는 member(or slot)
   # java, python : object.member
   # R : object@member
   # Class -> object
train$data@Dim  # 6513  126 : x변수의 차원정보(2차원 matrix)

train$data
train$label
table(train$label)
# 0    1 
# 3373 3140

str(test)
# $ data : x변수 : Dim [1611,126]
# $ label: y변수 : num [1:1611]





# 3. xgboost matrix 생성 : 객체 정보 확인 (model생성을 위한 단계)
# xgb.DMatrix(data=x, label=y)
dtrain <- xgb.DMatrix(data = train$data, label = train$label) # x:data, y:label
dtrain <- xgb.DMatrix(data=train$data, label=train$label)
dtrain 
# xgb.DMatrix  dim: 6513 x 126  info: label  colnames: yes



?xgboost
#We will train decision tree model using the following parameters:
# •objective = "binary:logistic": we will train a binary classification model ;
# "binary:logistic" : y변수 이항 
# •max_depth = 2: the trees won't be deep, because our case is very simple ;
# tree 구조가 간단한 경우 : 2
# •nthread = 2: the number of cpu threads we are going to use;
# cpu 사용 수 : 2
# •nrounds = 2: there will be two passes on the data, the second one will enhance the model by further reducing the difference between ground truth and prediction.
# 실제값과 예측값의 차이를 줄이기 위한 반복학습 횟수 
# •eta = 1 : eta control the learning rate 
# 학습률을 제어하는 변수(Default: 0.3) 
# 숫자가 낮을 수록 모델의 복잡도가 높아지고, 컴퓨팅 파워가 더많이 소요
# 부스팅 과정을보다 일반화하여 오버 피팅을 방지하는 데 사용
# •verbose = 0 : no message
# 0이면 no message, 1이면 성능에 대한 정보 인쇄, 2이면 몇 가지 추가 정보 인쇄

# 4. model 생성 : xgboost matrix 객체 이용  
xgb_model <- xgboost(data = dtrain, max_depth = 2, eta = 1, nthread = 2, nrounds = 2, objective = "binary:logistic", verbose = 0)
xgv_model <- xgboost(data=dtrain, max_depth=2, eta=1, nthread=2, nrounds=2, objective="binary:logistic", verbose=0)
xgv_model


# 5.  학습된 model의 변수(feature) 중요도/영향력 보기 
import <- xgb.importance(colnames(train$data), model = xgb_model)
import <- xgb.importance(colnames(train$data), model= xgb_model)
import
#                    Feature       Gain     Cover Frequency
# 1:               odor=none 0.67615471 0.4978746       0.4
# 2:         stalk-root=club 0.17135375 0.1920543       0.2
# 3:       stalk-root=rooted 0.12317236 0.1638750       0.2
# 4: spore-print-color=green 0.02931918 0.1461960       0.2
# xgb.plot.importance(importance_matrix = import)
#                             ㄴ 지니계수 : 높을수록 기여도 up

xgb.plot.importance(importance_matrix = import)
xgb.plot.importance(importance_matrix = import)


# 6. 예측치
pred <- predict(xgb_model, test$data)
range(pred)  # 0.01072847 0.92392391 확률로 예측됨
test$label  # 0과 1로 나타나므로 pred값 변경

y_pred <- ifelse(pred>=0.5, 1, 0)
y_true <- test$label

tab <- table(y_true, y_pred)
tab
#         y_pred
# y_true     0   1
#        0 813  22
#        1  13 763


# 7. model평가
# 1) 분류정확도
acc <- (tab[1,1] + tab[2,2]) / sum(tab)  # or, since this is a vector, 'length(y_true)'
acc  # 0.9782744


# 2) 평균오차
mean_err <- mean(as.numeric(pred >= 0.5) != y_true)  # 0.02172564
# pred >= 0.5 는 T /F로 반환되기 때문에 수로 바꿔준다.
cat('평균오차 =', mean_err)


# 8. model save & load

# 1) model file save
setwd("C:/ITWILL/Work/2_Rwork/output")
xgb.save(xgb_model, 'xgboost.model')  # (obj, filename)
#  TRUE

rm(list = ls())  # 지웟음..


# 2) model load(memory loading)
xgb_model2 <- xgb.load('xgboost.model')

###### xgb.Booster
# raw: 1.2 Kb 
# xgb.attributes:
#   niter
# niter: 

pred2 <- predict(xgb_model2, test$data)
pred2
range(pred2)  #  0.01072847 0.92392391
# range(pred)  # 0.01072847 0.92392391 기존과 같음


########################################
### iris dataset : y 이항분류
########################################
# objective="binary:logistic"


iris_df <- iris  #복제본

# 1. y변수-> binary (y를 펙터형으로 사용할수 없음?)
iris_df$Species <- ifelse(iris_df$Species=='setosa', 0, 1)
str(iris_df)   # $ Species     : num  0 0 0 0 0 0 0 0 0 0 ...
table(iris_df$Species)
# 0   1 
# 50 100

# 2. dataset 생성
idx <- sample(nrow(iris_df), 0.7*nrow(iris_df))
train <- iris_df[idx,]
test <- iris_df[-idx,]

# x : matrix, y : vector
train_x <- train[,-5]
train_y <- train$Species

dim(train_x)  #  105   4  # data frame,..? how you know????????????????
str(train_y)  # [1:105] 1 1 0 1 1 1 1 0 0 0 ... 벡터형! 그대로사용

train_x <- as.matrix(train[,-5])
dim(train_x)


# 3. dmatrix 생성(model 생성에 필요한 소스)
dtrain <- xgb.DMatrix(data=train_x, label=train_y)
dtrain  # xgb.DMatrix  dim: 105 x 4  info: label  colnames: yes


# 4. xgboost model 생성
xgb_iris_model <- xgboost(data=dtrain, max_depth=2, eta=1, 
                          nthread=2, nrounds=2,
                          objective="binary:logistic", verbose=0)
xgb_iris_model


# 5. 중요변수 보기
import <- xgb.importance(colnames(train_x), model=xgb_iris_model)
import
#                  Feature Gain Cover Frequency
# 1: Petal.Length             1     1         1

xgb.plot.importance(importance_matrix = import)


# 6. y 예측치
# x : matrix, y : vector
test_x <- as.matrix(test[,-5])
test_y <- test$Species

pred <- predict(xgb_iris_model, test_x)
range(pred)  # 0.06065392 0.94855309

y_pred <- ifelse(pred>=0.5,1,0)

tab <- table(test_y, y_pred)
#         y_pred
# test_y    0  1
#        0 15  0
#        1  0 30

acc <- (tab[1,1] + tab[2,2]) / length(test_y)
acc  # 1
cat('accuracy =', acc*100,'%')
  # accuracy = 100 %






###############################################
#### iris xgboost 다항분류
###############################################
#
# objective="multi:softmax", num_class = 3

iris_df <- iris

iris_df$Species <- ifelse(iris_df$Species=='setosa',0,(
  ifelse(iris_df$Species=='versicolor',1,2)
))
iris_df$Species
table(iris_df$Species)
# 0  1  2 
# 50 50 50 


# dataset 생성
idx <- sample(nrow(iris_df), 0.7*nrow(iris_df))
train <- iris_df[idx,]
test <- iris_df[-idx,]

# x : matrix, y : vector
train_x <- as.matrix(train[,-5])
train_y <- train$Species


# DMatrix 생성
dtrain <- xgb.DMatrix(data=train_x, label=train_y)

# xgboost
model <- xgboost(data=dtrain, max_depth=2,
                 eta=1, nthread=2, nrounds=2,
                 objective="multi:softmax",
                 num_class = 3, verbose=0)
model
# iter train_merror
# 1     0.047619
# 2     0.038095

# 예측치 준비
test_x <- as.matrix(test[,-5])
test_y <- test$Species

# 왜햇는지 모르겟음ㅋdtrain <- xgb.DMatrix(data=test_x, label=test_y)

pred <- predict(model, test_x)
pred
true <- test_y
true

# 3가지 방식으로 model평가
# tab
tab <- table(true, pred)
#          pred
# true    0  1  2
#      0 13  0  0
#      1  0 16  0
#      2  0  0 16

acc <- (tab[1,1] + tab[2,2] + tab[3,3]) / length(true)
acc  # 1

# mse
err = pred-true
mse <- mean(err**2)
mse # 0

# cor
cor(true,pred)  # 1



#############################################
### iris dataset : y 연속형
#############################################
# objective = 'reg : squarederror' : 연속형(default)

# 1. train/test
idx <- sample(nrow(iris), 0.7*nrow(iris))
train <- iris[idx,]
test <- iris[-idx,]

# 2. xgboost model 생성
# y : 1번 칼럼
# x : 2~4번 칼럼

train_x <- as.matrix(train[,2:4])
train_y <- as.vector(train[,1])

dtrain <- xgb.DMatrix(data=train_x, label=train_y)
dtrain  # dim: 105 x 3

model <- xgboost(data=dtrain, max_depth=2, eta=1,
                 nthread=2, nrounds=2,
                 objective="reg:squarederror", verbose=0)
model
# evaluation_log:
# iter train_rmse
# 1   0.543327
# 2   0.389561  >> 오차가 떨어졋음. 두번째 트레이닝에


# 예측치 준비
test_x <- as.matrix(test[,2:4])
test_y <- as.vector(test[,1])
y_pred <- predict(model, test_x)
y_pred
y_true <- test_y
range(y_pred)  # 4.841854 7.438672
range(y_true)  # 4.3 7.9

table(y_true, y_pred)


# 변수 기여도 확인
import <- xgb.importance(colnames(train_x), model)
import
#        Feature         Gain      Cover  Frequency
# 1: Petal.Length  0.92185615  0.7047619       0.75
# 2:  Sepal.Width  0.07814385  0.2952381       0.25
# Petal.Length 기여도 크넹

xgb.plot.importance(importance_matrix = import)


# model 검정

err = y_pred - y_true
err
mse <- mean(err**2)
mse  # 0.1479627

cor(y_true, y_pred)  # 0.8924352

# 괜찮은 모델이다.

