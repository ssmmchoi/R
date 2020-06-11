# chap16_Classification

install.packages("rpart")
library(rpart) # rpart() : 분류모델 생성 
install.packages("rpart.plot")
library(rpart.plot) # prp(), rpart.plot() : rpart 시각화
install.packages('rattle')
library('rattle') # fancyRpartPlot() : node 번호 시각화 


# 단계1. 실습데이터 생성 
data(iris)
set.seed(415)
idx = sample(1:nrow(iris), 0.7*nrow(iris))
train = iris[idx, ]
test = iris[-idx, ]
dim(train) # 105 5
dim(test) # 45  5

table(train$Species)

# 단계2. 분류모델 생성 
# rpart(y변수 ~ x변수, data)
model = rpart(Species~., data=train) # iris의 꽃의 종류(Species) 분류 
model
# 1) root 105 68 setosa (0.35238095 0.31428571 0.33333333)  
#    root node : 전체크기, 68(setosa제외), 가장 많은 비율을 가진 label(105-68=37개 나왔다.), 세 개의 레이블에 대해 각각의 출현 비율

#   2) Petal.Length< 2.45 37  0 setosa (1.00000000 0.00000000 0.00000000) *
#  root node 기준 왼쪽 node: 분류조건, 분류대상(37), 오분류개수(0), 주 레이블 이름, *은 답노드(terminal node)라는 뜻.

#   3) Petal.Length>=2.45 68 33 virginica (0.00000000 0.48529412 0.51470588)  
#  root node 기준 오른쪽 node : 분류조건, 가장 많은 비율을 가진 label(virginica 68-33 = 35개

#     6) Petal.Width< 1.75 35  2 versicolor (0.00000000 0.94285714 0.05714286) *


#     7) Petal.Width>=1.75 33  0 virginica (0.00000000 0.00000000 1.00000000) *



# 분류모델 시각화 - rpart.plot 패키지 제공 
prp(model) # 간단한 시각화   
rpart.plot(model) # rpart 모델 tree 출력
fancyRpartPlot(model) # node 번호 출력(rattle 패키지 제공)
# 누락된 4,5번은 3번 노드에 의해서





###############################################
### 가지치기(cp:cut prune)
###############################################

# 트리의 가지치기 : 과적합 문제 해결법
# cp : 0 ~ 1, default=0.05
# 0으로 갈수록 트리 커짐, 학습데이타에 대한 오류율은 감소, 하지만 과적합 증가

model$cptable
#            CP nsplit  rel error       xerror        xstd
# 1 0.5147059        0  1.00000000  1.11764706  0.06737554
# 2 0.4558824        1  0.48529412  0.57352941  0.07281162
# 3 0.0100000        2  0.02941176  0.02941176  0.02059824  >> 가장 적은 오류율의 cp값은 0.02941176
# 테스트해서 과적합 발생하면 -> 0.48529412





# 단계3. 분류모델 평가  
pred <- predict(model, test) # 비율 예측 
pred <- predict(model, test, type="class") # 분류 예측 
pred

# 1) 분류모델로 분류된 y변수 보기 
table(pred)
# setosa versicolor  virginica 
# 13         19         13 

# 2) 분류모델 성능 평가 
tab <- table(pred, test$Species)
tab
#                실제분류
# pred         setosa versicolor virginica
# setosa         13          0         0
# versicolor      0         16         3
# virginica       0          1        12

acc <- (tab[1,1] + tab[2,2] + tab[3,3]) / nrow(test)
acc  # 0.9111111

















##################################################
# Decision Tree 응용실습 : 암 진단 분류 분석
##################################################
# "wdbc_data.csv" : 유방암 진단결과 데이터 셋 분류
# 어떤 경우에 '정규화'하냐? 내용도 포함되어 있음

# 1. 데이터셋 가져오기 
wdbc <- read.csv('C:/ITWILL/Work/2_Rwork/Part-IV/wdbc_data.csv', stringsAsFactors = FALSE)
str(wdbc)  # 'data.frame':	569 obs. of  31 variables:
# diagnosis 악성/양성 dmf y변수로 사용

# 2. 데이터 탐색 및 전처리 
wdbc <- wdbc[-1] # id 칼럼 제외(이상치) 
head(wdbc)
head(wdbc[, c('diagnosis')], 10) # 진단결과 : B -> '양성', M -> '악성'

# 목표변수(y변수)를 factor형으로 변환 
wdbc$diagnosis <- factor(wdbc$diagnosis, levels = c('B', 'M'))
wdbc$diagnosis[1:10]
# [1] B B B B B B B M B B
# Levels: B M
# 이렇게 Levels가 뜨면 이 자료가 factor형이고 먼저 뜨는 B가 base역할을 한다는 뜻
head(wdbc)
summary(wdbc)

# 3. 정규화  : 서로 다른 특징을 갖는 칼럼값 균등하게 적용 
normalize <- function(x){ # 정규화를 위한 함수 정의 lapply로 호출함
  return ((x - min(x)) / (max(x) - min(x)))
}

# wdbc[2:31] : x변수에 해당한 칼럼 대상 정규화 수행 
wdbc_x <- as.data.frame(lapply(wdbc[2:31], normalize))
wdbc_x
summary(wdbc_x) # 0 ~ 1 사이 정규화 
class(wdbc_x) # [1] "data.frame"
nrow(wdbc_x) # [1] 569
str(wdbc_x)

wdbc_df <- data.frame(wdbc$diagnosis, wdbc_x)
dim(wdbc_df) # 569  31
head(wdbc_df)

# 4. 훈련데이터와 검정데이터 생성 : 7 : 3 비율 
idx = sample(nrow(wdbc_df), 0.7*nrow(wdbc_df))
wdbc_train = wdbc_df[idx, ] # 훈련 데이터 
wdbc_test = wdbc_df[-idx, ] # 검정 데이터 

dim(wdbc_train)  # 398  31
dim(wdbc_test)  # 171  31


# 5. rpart 분류모델 생성 

model <- rpart(wdbc.diagnosis~., data=wdbc_train)
model

prp(model)
rpart.plot(model)

# 6. 분류모델 평가  

y_pred <- predict(model, wdbc_test, type='class')
length(y_pred)  # 171
y_true <- wdbc_test$wdbc.diagnosis
length(y_true)  # 171

tab <- table(y_true, y_pred)
#          y_pred
# y_true    B  M
#        B 99  6
#        M 14 52

acc <- (tab[1,1] + tab[2,2]) / nrow(wdbc_test)
acc  # 0.8830409

inacc <- (tab[1,2] + tab[2,1]) / nrow(wdbc_test)
inacc  # 0.1169591

M <- tab[2,2] / (tab[2,1] + tab[2,2])
M  # 0.7878788 recall

B <- tab[1,1] / (tab[1.1] + tab[1,2])
B  # 0.9428571 recall about B


# 다른 방법

y_pred2 <- predict(model, wdbc_test)
y_pred_cut <- ifelse(y_pred2[,1] >= 0.5, 'B', "M")
y_pred_cut














#####################################################
### 교차검정
#####################################################

# 단계1 : k겹 교차검정(데이터를 k개로 균등분할 하겠다.)
install.packages("cvTools")
library(cvTools)

?cvFolds
# cvFolds(n 쪼갤 데이터 길이, K = 5 5등분, R = 1 몇개만들거,
#         type = c("random"랜덤샘플링, "consecutive", "interleaved"))
cross <- cvFolds(n=nrow(iris), K=3, R=1, type='random')
# K = 3 이므로 d1 =50, d2 = 50, d3 = 50
cross
# Fold : dataset    Index : row
head(cross)
str(cross)
# List of 5
# $ n      : num 150
# $ K      : num 3
# $ R      : num 1
# $ subsets: int [1:150, 1] 65 53 31 98 51 63 74 70 109 106 ...  : 중요!!!!
# $ which  : int [1:150] 1 2 3 1 2 3 1 2 3 1 ...
# - attr(*, "class")= chr "cvFolds"


# set1 추출
d1 <- cross$subsets[cross$which==1,]
d1
# set2 추출
d2 <- cross$subsets[cross$which==2,]
d2
# set3 추출
d3 <- cross$subsets[cross$which==3,]
d3

length(d1)
length(d2)
length(d3)
# all 50

K <- 1:3
R <- 1

for(r in R){    # set = 열 index
  for(k in K){    # k겹 = 행 index
    idx <- cross$subsets[cross$which==k, r]
    cat('k =', k, '\n')
    print(idx)
  }
}

R <- 1:2
for(r in R){    # set = 열 index
  cat('R =', r, '\n')
  for(k in K){    # k겹 = 행 index
    idx <- cross$subsets[cross$which==k, r]
    cat('k =', k, '\n')
    print(idx)
  }
}   # Error in cross$subsets[cross$which == k, r] : 
# 첨자의 허용 범위를 벗어났습니다   --> 처음 cvFolds를 만들 때 R=1로 설정했기 때문
# R=1 인 인덱스만 출력됨



K <- 1:3
R <- 1
ACC <- numeric()

for(r in R){  # set = 열 index
  
  for(k in K){    # k겹 = 행 index
    idx <- cross$subsets[cross$which==k, r]
    cat('k =', k, '\n')
    print(idx)
    test <- iris[idx,]  # 검정용(50)
    train <- iris[-idx,]  # 훈련용(100)
    model <- rpart(Species~., data=train)
    pred <- predict(model, test, type='class')
    tab <- table(test$Species, pred)
    ACC[k] <- (tab[1,1] + tab[2,2] + tab[3,3]) / sum(tab)  
    cat('\n')
  }
 cat('쪼개진 데이터셋으로 시험한 모델의 분류 정확도는', mean(ACC)) 
}

ACC  # 0.96 0.96 0.90
mean(ACC)  # 0.94


#### k가 출력할 ACC의 인덱스와 같지 않을 경우에는(정석 방법),
cnt <- 1

for(r in R){  # set = 열 index
  
  for(k in K){    # k겹 = 행 index
    idx <- cross$subsets[cross$which==k, r]
    cat('k =', k, '\n')
    print(idx)
    test <- iris[idx,]  # 검정용(50)
    train <- iris[-idx,]  # 훈련용(100)
    model <- rpart(Species~., data=train)
    pred <- predict(model, test, type='class')
    tab <- table(test$Species, pred)
    ACC[cnt] <- (tab[1,1] + tab[2,2] + tab[3,3]) / sum(tab)  
    cnt <- cnt +1
    cat('\n')
  }
  cat('쪼개진 데이터셋으로 시험한 모델의 분류 정확도는', mean(ACC)) 
}

fancyRpartPlot(model)




###################################################
### titanic 3
###################################################

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
























