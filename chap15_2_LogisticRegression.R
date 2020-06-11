# chap15_2_LogisticRegression



###############################################
# 15_2. 로지스틱 회귀분석(Logistic Regression) 
###############################################

# 목적 : 일반 회귀분석과 동일하게 종속변수와 독립변수 간의 관계를 나타내어 
# 향후 예측 모델을 생성하는데 있다.

# 차이점 : 종속변수가 범주형 데이터를 대상으로 하며 입력 데이터가 주어졌을 때
# 해당 데이터의결과가 특정 분류로 나눠지기 때문에 분류분석 방법으로 분류된다.
# 유형 : 이항형(종속변수가 2개 범주-Yes/No), 다항형(종속변수가 3개 이상 범주-iris 꽃 종류)
# 다항형 로지스틱 회귀분석 : nnet, rpart 패키지 이용 
# a : 0.6,  b:0.3,  c:0.1 -> a 분류 

# 분야 : 의료, 통신, 기타 데이터마이닝

# 선형회귀분석 vs 로지스틱 회귀분석 
# 1. 로지스틱 회귀분석 결과는 0과 1로 나타난다.(이항형)
# 2. 정규분포 대신에 이항분포를 따른다.
# 3. 로직스틱 모형 적용 : 변수[-무한대, +무한대] -> 변수[0,1]사이에 있도록 하는 모형 
#    -> 로짓변환 : 출력범위를 [0,1]로 조정
# 4. 종속변수가 2개 이상인 경우 더미변수(dummy variable)로 변환하여 0과 1를 갖도록한다.
#    예) 혈액형 AB인 경우 -> [1,0,0,0] AB(1) -> A,B,O(0)


# 단계1. 데이터 가져오기
weather = read.csv("C:/ITWILL/Work/2_Rwork/Part-IV/weather.csv", stringsAsFactors = F) 
# stringsAsFactors = F 순수한 문자형으로 가져오기

dim(weather)  # 366  15
head(weather)
str(weather)


# chr 칼럼, Date, RainToday 칼럼 제거 
weather_df <- weather[, c(-1, -6, -8, -14)]
str(weather_df)  # 숫자형 10개는 x변수, 범주형 1개는 y변수가 될 것.


# RainTomorrow 칼럼 -> 로지스틱 회귀분석 결과(0,1)에 맞게 더미변수 생성      
weather_df$RainTomorrow[weather_df$RainTomorrow=='Yes'] <- 1
weather_df$RainTomorrow[weather_df$RainTomorrow=='No'] <- 0
class(weather_df$RainTomorrow)  # "character"

weather_df$RainTomorrow <- as.numeric(weather_df$RainTomorrow)
head(weather_df)


table(weather_df$RainTomorrow)
# 0    1 
# 300  66 
prop.table(table(weather_df$RainTomorrow))
# 0         1 
# 0.8196721 0.1803279



#  단계2.  데이터 셈플링
idx <- sample(1:nrow(weather_df), 0.7*nrow(weather_df))
train <- weather_df[idx, ]
test <- weather_df[-idx, ]


#  단계3.  로지스틱  회귀모델 생성 : 학습데이터 
weather_model<- glm(formula = RainTomorrow~., data = train, family='binomial')
# family='binominal' : 이항 분포. y가 두개이다.


weather_model 
summary(weather_model) 


# 단계4. 로지스틱  회귀모델 예측치 생성 : 검정데이터 
# newdata=test : 새로운 데이터 셋, type="response" : 0~1 확률값으로 예측 
pred <- predict(weather_model, newdata=test, type="response")
# type="response" : 이 예측을 확률로. 시그모이드
pred 

range(pred, na.rm=T)  # 0.0005162529 0.9836534583
summary(pred)
# Min.      1st Qu.   Median    Mean      3rd Qu.   Max.       NA's 
# 0.0005163 0.0189113 0.0744729 0.1997105 0.2398225 0.9836535  3 
str(pred)


#cut off = 0.5
cpred <- ifelse(pred>=0.5, 1, 0)
cpred
table(cpred)
# cpred
# 0  1 
# 89 20   >> 합치면 109개. test 데이터셋의 길이. 전체의 30%


y_true <- test$RainTomorrow
y_true
table(y_true)
# 0  1 
# 93 19 


# 교차분할표
tab <- table(y_true, cpred)
#         cpred
# y_true   0  1
#     0   82  9   >> 잘못분류된 것 91개 중 9개
#     1    7 11
#         >> 잘못분류된 것 89개 중 7개

# 1) 정분류(분류정확도)
acc <- (82+11) / nrow(test)
acc   # 0.8454545
cat('accuracy =', acc)
# or
acc <- (tab[1,1]+tab[2,2]) / nrow(test)  # 정분리 확률


ifyes <- 7 / (11+7)
ifyes   # 0.3888889  다소 낮은 정확도
ifno <- 82 / (82 + 9)
ifno    # 0.9010989

# 2) 오분류
no_acc <- (tab[1,2] + tab[2,1]) / nrow(test)
no_acc  # 오분리 확률

# [해석] 비가 오지 않을 경우, 예측의 정확도가 약 90%로 정확한 편이나,
#        비가 올 경우에는 예측의 정확도가 약 32%로 다소 낮다.


# 3) 특이도 : no(true) -> no(predict)
tab[1,1] / (tab[1,1] + tab[1,2] )   # 0.978022


# 4) 재현율 = 민감도 : yes(true) -> yes(predict)
recall <- tab[2,1] / (tab[2,1] + tab[2,2])  # 0.6111111


# 5) 정확률 : 예측치(yes) -> 실제값(yes)
precision <- tab[2,2] / (tab[1,2]+tab[2,2])  # 0.7777778


# 6) F1_score : 불균형 비율 - 조합 평균
F1_score = 2*(recall * precision) / (recall + precision)
F1_score  # 0.6844444

### ROC Curve를 이용한 모형평가(분류정확도)  ####
# Receiver Operating Characteristic

install.packages("ROCR")
library(ROCR)

# ROCR 패키지 제공 함수 : prediction() -> performance
pr <- prediction(pred, test$RainTomorrow)  # predict함수, 정답y
mode(test$RainTomorrow)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
prf
plot(prf)
# 그래프의 사각형에서 비어있는 좌측 상단 부분이 오차에 해당
# 이 영역이 좁을수록 오차가 적은 좋은 모델이다.



######################################################
### 다항형 로지스틱 회귀분석 : nnet
######################################################

install.packages("nnet")
library(nnet)

set.seed(123)
idx <- sample(nrow(iris), 0.7*nrow(iris))
train <- iris[idx,]
test <- iris[-idx,]
nrow(train)

# 활성함수
# 이항분류를 할 때 : sigmoid function을 사용했음 : 0~1 확률값
# 다항분류 : softmax function : 0~1 확률값
# 차이점 : 다항분류에서 0~1 확률값의 sum=1
# y1=0.1 y2=0.1 y3=0.8

names(iris)
model <- multinom(Species~., data=train)
# 100번 학습을 함. 첫 번째 학습의 오차 115.3~에서 최종 학습의 오차 0.02~ 까지
# 오차가 점점 줄어듬.
# initial  value 115.354290 
# iter  10 value 14.037979
# iter  20 value 3.342288
# iter  30 value 2.503699
# iter  40 value 2.171547
# iter  50 value 2.099460
# iter  60 value 1.828506
# iter  70 value 0.904367
# iter  80 value 0.669147
# iter  90 value 0.622003
# iter 100 value 0.609416
# final  value 0.609416 
# stopped after 100 iterations
# weights:  18 (10 variable) : hidden layer로 변수를 연결해주는 뉴런 수

names(model)
model$fitted.values
# 몇 가지 결과sample은 다음과 같다.
#            setosa   versicolor     virginica
# 14   1.000000e+00 2.041289e-26 3.063590e-162  >> 합계 1
# 50   1.000000e+00 2.241607e-28 1.576956e-165
# 118 1.347298e-151 7.524377e-37  1.000000e+00
# 43   1.000000e+00 5.054793e-23 2.996285e-154
# 150 4.246683e-105 6.869622e-12  1.000000e+00
# 148 1.201633e-103 6.073557e-13  1.000000e+00

str(model$fitted.values)
# num [1:105, 1:3] 행개수 105개, 열 개수 3개

train[1,]  # 실제 얘는 setosa
model$fitted.values[1,]  # 예측한 결과도 setosa

range(model$fitted.values)  #almost 0 ~ 1
rowSums(model$fitted.values)  #각 행의 합이 다 1


model$softmax
model$censored
model$value
model$terms
model$coefnames


# 예측치
y_pred1 <- predict(model, test)   # type= 'probs' 넣으면 비율예측
length(y_pred)  # 45

y_true <- test$Species

y_pred2 <- predict(model, test, type= 'probs')
str(y_pred)

# cut off 를 비율예측에 적용하면
y_pred2_cut <- ifelse(y_pred2[,1] >= 0.5, 'setosa', ifelse(y_pred2[,2] >= 0.5, 'versicolor', 'verginica'))
y_pred2_cut

# 교차분할표(confusion matrix)
tab <- table(y_true, y_pred)
tab

acc <- (tab[1,1] + tab[2,2] + tab[3,3]) / nrow(test)
acc  # 0.9777778

cat('분류정확도 =', acc)
# 분류정확도 = 0.9777778






