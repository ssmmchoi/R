# chap16_2_RandomForest


##################################################
#randomForest
##################################################
# 결정트리(Decision tree)에서 파생된 모델 
# 랜덤포레스트는 앙상블 학습기법을 사용한 모델
# 앙상블 학습 : 새로운 데이터에 대해서 여러 개의 Tree로 학습한 다음, 
# 학습 결과들을 종합해서 예측하는 모델(PPT 참고)
# DT보다 성능 향상, 과적합 문제를 해결


# 랜덤포레스트 구성방법(2가지)
# 1. 결정 트리를 만들 때 데이터의 일부만을 복원 추출하여 트리 생성 
#  -> 데이터 일부만을 사용해 포레스트 구성 
# 2. 트리의 자식 노드를 나눌때 일부 변수만 적용하여 노드 분류
#  -> 변수 일부만을 사용해 포레스트 구성 
# [해설] 위 2가지 방법을 혼용하여 랜덤하게 Tree(학습데이터)를 구성한다.

# 새로운 데이터 예측 방법
# - 여러 개의 결정트리가 내놓은 예측 결과를 투표방식(voting) 방식으로 선택 


install.packages('randomForest')
library(randomForest) # randomForest()함수 제공 

data(iris)

# 1. 랜덤 포레스트 모델 생성 
# 형식) randomForest(y ~ x, data, ntree(기본500), mtry(기본2))
model = randomForest(Species~., data=iris)  
model
# randomForest(formula = Species ~ ., data = iris) 
# Type of random forest: classification                    >> 분류트리이다. (범주형을 인식)
# Number of trees: 500
# No. of variables tried at each split: 2                  >> x변수 4개 중 가장 중요한 역할을 하는 2개를 가지고 분류했다.
# 
# OOB estimate of  error rate: 5.33%
# Confusion matrix:
#               setosa versicolor virginica class.error
# setosa         50          0         0        0.00
# versicolor      0         47         3        0.06
# virginica       0          5        45        0.10



# 2. 파라미터 조정 300개의 Tree와 4개의 변수 적용 모델 생성 
model = randomForest(Species~., data=iris, 
                     ntree=300, mtry=4, na.action=na.omit )
# 통상 mtry수를 결정할 때 sqrt(4변수개수)=2 로 한다. / 회귀분류(y변수가연속형)의 경우 1/3p
# mtry는 노드 분할에 사용하는 x변수 개수.

model
# Call:
# randomForest(formula = Species ~ ., data = iris, ntree = 300,      
#              mtry = 4, na.action = na.omit) 
# Type of random forest: classification
# Number of trees: 300
# No. of variables tried at each split: 4
# 
# OOB estimate of  error rate: 4.67%
# Confusion matrix:
#   setosa versicolor virginica class.error
# setosa         50          0         0        0.00
# versicolor      0         47         3        0.06
# virginica       0          4        46        0.08





# 3. 최적의 파리미터(ntree, mtry) 찾기
# - 최적의 분류모델 생성을 위한 파라미터 찾기

ntree <- c(400, 500, 600)
mtry <- c(2:4)

# 2개 vector이용 data frame 생성 
param <- data.frame(n=ntree, m=mtry)
param

for(i in param$n){ # 400,500,600
  cat('ntree = ', i, '\n')
  for(j in param$m){ # 2,3,4
    cat('mtry = ', j, '\n')
    model = randomForest(Species~., data=iris, 
                         ntree=i, mtry=j, 
                         na.action=na.omit )    
    print(model)
  }
}



# 4. 중요 변수 생성  
model3 = randomForest(Species ~ ., data=iris, 
                      ntree=500, mtry=2, 
                      importance = T,
                      na.action=na.omit )
model3 


pred <- model3$predicted
true <- iris$Species

table(true, pred)

importance(model3)
#                  setosa  versicolor virginica MeanDecreaseAccuracy MeanDecreaseGini
# Sepal.Length  6.292346  7.01980433  7.857833            10.903195         9.364157
# Sepal.Width   5.247065  0.08747457  5.762430             5.452602         2.455430
# Petal.Length 22.867688 33.14382823 29.273810            34.254280        44.085231
# Petal.Width  21.543115 32.66160312 29.722922            33.177089        43.300743

# MeanDecreaseAccuracy숫자가 클수록 큰 영향을 미침
#                     분류정확도 개선에 기여
# MeanDecreaseGini 지니계수도 경향이 위와 같음
#                  노드 불순도(불확실성) 개선에 기여하는 변수 : entropy

varImpPlot(model3)









###################################################
### 회귀 tree
###################################################

library(MASS)

data('Boston')
str(Boston)
#crim : 도시 1인당 범죄율 
#zn : 25,000 평방피트를 초과하는 거주지역 비율
#indus : 비상업지역이 점유하고 있는 토지 비율  
#chas : 찰스강에 대한 더미변수(1:강의 경계 위치, 0:아닌 경우)
#nox : 10ppm 당 농축 일산화질소 
#rm : 주택 1가구당 평균 방의 개수 
#age : 1940년 이전에 건축된 소유주택 비율 
#dis : 5개 보스턴 직업센터까지의 접근성 지수  
#rad : 고속도로 접근성 지수 
#tax : 10,000 달러 당 재산세율 
#ptratio : 도시별 학생/교사 비율 
#black : 자치 도시별 흑인 비율 
#lstat : 하위계층 비율 
#medv(y) : 소유 주택가격 중앙값 (단위 : $1,000)

ntree <- 500
p <- 13
mtry <- 1/3*p
mtry # 4.333333  : 4 or 5

bostonmodel <- randomForest(medv~., data=Boston, ntree=ntree,
                            mtry=5, importance=T)
bostonmodel
#        Type of random forest: regression
#              Number of trees: 500
# No. of variables tried at each split: 5
# 
#      Mean of squared residuals: 9.54259                 >>> 표준화 안되어있음
#            % Var explained: 88.7

names(bostonmodel)
bostonmodel$importance
importance(bostonmodel)
varImpPlot(bostonmodel)
bostonmodel$predicted   # 모델에 의해 예측한 예측치

y_pred <- bostonmodel$predicted
y_true <- bostonmodel$y 

table(y_true, y_pred)

# mse : 표준화 0
err <- y_pred - y_true
mse < - mean(err**2)  # 9.461938
                      # 모델에서 평균제곱오차 9.54259와 유사함
                      # scaling 되지 않은 값

# correlation : 표준화 X
cor(y_true, y_pred)  # 0.9446826



# *********정리*********
# model 평가
# 분류tree : confusion matrix
# 회귀tree : MES, cor
























###################################################
### titanic 3 - 회귀tree와 분류tree비교
###################################################

# decision Tree

# titanic3.csv 변수 설명
#'data.frame': 1309 obs. of 14 variables:
#1.pclass : 1, 2, 3등석 정보를 각각 1, 2, 3으로 저장
#2.survived : 생존 여부. survived(생존=1), dead(사망=0)
#3.name : 이름(제외)
#4.sex : 성별. female(여성), male(남성)
#5.age : 나이
#6.sibsp : 함께 탑승한 형제 또는 배우자의 수
#7.parch : 함께 탑승한 부모 또는 자녀의 수
#8.ticket : 티켓 번호(제외)
#9.fare : 티켓 요금
#10.cabin : 선실 번호(제외)
#11.embarked : 탑승한 곳. C(Cherbourg), Q(Queenstown), S(Southampton)
#12.boat     : (제외)Factor w/ 28 levels "","1","10","11",..: 13 4 1 1 1 14 3 1 28 1 ...
#13.body     : (제외)int  NA NA NA 135 NA NA NA NA NA 22 ...
#14.home.dest: (제외)

titanic3 <- read.csv(file.choose())  # titanic3.csv

# <조건1> 6개 변수 제외 -> subset 생성
# <조건2> survived : int -> factor변환(0,1)
# <조건3> train vs test =7:3
# <조건4> 가장 중요한 변수?
# <조건5> model 평가 : 분류정확도



# <조건1>
titanic <- titanic3[,-c(3,8,10,12,13,14)]

library(dplyr)
titanic %>% head()
titanic$sex
titanic$sibsp
titanic$embarked


# <조건2>
titanic$survived <- factor(titanic$survived, levels=c(0,1))
titanic$survived


# <조건3>
idx <- sample(nrow(titanic), 0.7*nrow(titanic))
train <- titanic[idx,]
nrow(train)  # 916
test <- titanic[-idx,]
nrow(test)  # 393

model <- rpart(survived~., data=train)
model
prp(model)
rpart.plot(model)



# <조건4> 가장 중요한 변수?

# sex > age, pclass> sibsp, fare



# <조건5>
pred <- predict(model, test, type='class')
pred
length(pred)

true <- test$survived

tab <- table(true, pred)
#           pred
# true     0   1
#      0 230  21
#      1  62  80

acc <- (tab[1,1] + tab[2,2]) / sum(tab)
acc  # 0.7888041






# random Tree


titanic3 <- read.csv(file.choose())  # titanic3.csv
titanic3

titanic <- titanic3[,-c(3,8,10,12,13,14)]
titanic$survived <- factor(titanic$survived, levels=c(0,1))

idx <- sample(nrow(titanic), 0.7*nrow(titanic))
train <- titanic[idx,]
nrow(train)  # 916
test <- titanic[-idx,]
nrow(test)  # 393



mtry <- round(sqrt(7))
ntree <- 500

model <- randomForest(survived~., data = titanic, ntree = ntree,
                               mtry = mtry, importance = T,
                               na.action= na.omit)
model
#             Type of random forest: classification
#                     Number of trees: 500
# No. of variables tried at each split: 3
# 
#        OOB estimate of  error rate: 20.1%          >> 분류정확도 약 80%
# Confusion matrix:
#   0   1 class.error
# 0 541  77   0.1245955
# 1 133 294   0.3114754

model$importance
varImpPlot(model)
# 중요변수 : sex > pclass > age > fare...


##             decision Tree          Vs         randon Tree
#      acc       0.7888041                   0.799
# 중요변수 sex > age, pclass> sibsp, fare    sex > pclass > age > fare...





















#########################################################
### entropy : 불확실성 척도
#########################################################

# - tree model에서 중요변수 선정 기준

# 1. x1 : 앞면, x2 : 뒷면 : 불확실성이 가장 높은 경우
x1 = 0.5; x2 = 0.5

e1 <- -x1 * log2(x1) -x2 * log2(x2)
e <- exp(1)
e1   # 1  : 최고불확실성

# 2. x1 =0.8, x2=0.2
x1 =0.8; x2 =0.2
e2 <- -x1 * log2(x1) -x2 * log2(x2)
e2  # 0.7219281  : less than e1

# 3. x1=0.9, x2=0.1
x1=0.9; x2=0.1
e3 <- -(x1*log2(x1) + x2*log2(x2))
e3  # 0.4689956









