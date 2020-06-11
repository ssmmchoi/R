# Chap15_1_Regration

######################################################
# 회귀분석(Regression Analysis)
######################################################
# - 특정 변수(독립변수:설명변수)가 다른 변수(종속변수:반응변수)에 어떠한 영향을 미치는가 분석

###################################
## 1. 단순회귀분석 
###################################
# - 독립변수와 종속변수가 1개인 경우

# 단순선형회귀 모델 생성  
# 형식) lm(formula= y ~ x 변수, data) 
setwd("C:/ITWILL/Work/2_Rwork/Part-IV")
product <- read.csv("product.csv", header=TRUE)
head(product) # 친밀도 적절성 만족도(등간척도 - 5점 척도)

str(product) # 'data.frame':  264 obs. of  3 variables:
y = product$'제품_만족도' # 종속변수
x = product$'제품_적절성' # 독립변수
df <- data.frame(x, y)

# 회귀모델 생성 
result.lm <- lm(formula=y~x, data=df)
result.lm # 회귀계수 
# Coefficients:
# (Intercept)     x  
#  0.7789       0.7393
#   y절편       기울기

# 회귀방정식(y) = a.X + b(a: 기울기, b: y절편)
head(df)
X <- 4  # 입력변수(독립변수)
Y <- 3  # 정답
a <- 0.7393
b <- 0.7789

y <- a*X + b
cat('y의 예측치 =', y)
# y의 예측치 = 3.7361

err <- y - Y
cat('model error =', err)  # model error = 0.7361

names(result.lm)
# "coefficients" : 회귀계수
# "residuals" : 오차(잔차)
# ~
# "fitted.values" : 적합치(예측치)
# ~
result.lm$residuals
result.lm$coefficients
result.lm$fitted.values  

shapiro.test(result.lm$residuals)
# W = 0.93931, p-value = 5.742e-09 < 0.05이므로
# 귀무가설(정규분포와 차이가 없다) 기각.
# 정규분포와 차이가 있다. 정규분포 아님.
re <- result.lm$residuals
re <- as.data.frame(re)
hist(re)
curve(dnorm(re),
      col='blue', add=T)
?curve


# 회귀모델 예측 
# predict(model, x)
predict(result.lm, data.frame(x=5))  # 4.475239 
predict(result.lm, data.frame(x=10) )   # 8.17162 

# (2) 선형회귀 분석 결과 보기
summary(result.lm)
# <회귀모델 해석 순서>
# 1. F-statistic:   374 on 1 and 262 DF,  p-value: < 2.2e-16
#    F value & p-value 값을 토대로 통계가 유의미한지 : 매우 유의미하다
# 2. 모델의 설명력(예측력) - 1에 가까울수록 예측력 good
#    Adjusted R-squared:  0.5865  : 약 60%
# 3. x의 유의성 검정 : x가 y에 어떤 영향을 미치는지
#    Coefficients:
#    Estimate    Std. Error  t value    Pr(>|t|)    
#    (Intercept)  0.77886    0.12416   6.273 1.45e-09 ***
#    x            0.73928    0.03823  19.340  < 2e-16 ***
# t value를 토대로 p value 값 확인.
# t가 -1.96~+1.96 사이에 있으면 채태역. 현재 기각역에 있다.
# 따라서 x는 y에 유의미한 수준에서 영향을 미친다.

cor(df)  # 상관계수
#           x         y
# x 1.0000000 0.7668527
# y 0.7668527 1.0000000
# 비교적 높은 상관관계를 보인다.
r <- 0.7668527
r_squared <- r**2  # R-squared는 상관계수의 제곱
r_squared  # 0.5880631


# (3) 단순선형회귀 시각화
# x,y 산점도 그리기 
plot(formula=y ~ x, data=df, xlim=c(0,5), ylim=c(0,5))
# 회귀분석
result.lm <- lm(formula=y ~ x, data=df)
# 회귀선 
abline(result.lm, col='red', )
?abline
result.lm$coefficients
# (Intercept)         x 
# 0.7788583   0.7392762

y <- product$'제품_만족도'
x <- product$'제품_적절성'

# 기울기 = Covxy공분산 / Sxx x변수의편차의제곱의평균
Covxy = mean((x-mean(x))*(y-mean(y)))
Sxx = mean((x-mean(x))**2)
a <- Covxy / Sxx  
a   # 0.7392762

b <- mean(y) - (a*mean(x))
b


###################################
## 2. 다중회귀분석
###################################
# - 여러 개의 독립변수 -> 종속변수에 미치는 영향 분석
# 가설 : 음료수 제품의 적절성(x1)과 친밀도(x2)는 제품 만족도(y)에 정의 영향을 미친다.

product <- read.csv("product.csv", header=TRUE)
head(product) # 친밀도 적절성 만족도(등간척도 - 5점 척도)


#(1) 적절성 + 친밀도 -> 만족도  
y = product$'제품_만족도' # 종속변수
x1 = product$'제품_친밀도' # 독립변수2
x2 = product$'제품_적절성' # 독립변수1

df <- data.frame(x1, x2, y)
df

result.lm <- lm(formula=y ~ x1 + x2, data=df)
#result.lm <- lm(formula=y ~ ., data=df)

# 계수 확인 
result.lm
# Coefficients:
# (Intercept)           x1           x2  
#  0.66731           0.09593      0.68522  

summary(result.lm)
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -2.01076 -0.22961 -0.01076  0.20809  1.20809 
# 
# Coefficients:
#               Estimate  Std. Error  t value   Pr(>|t|)    
#   (Intercept)  0.66731    0.13094   5.096    6.65e-07 ***
#   x1           0.09593    0.03871   2.478    0.0138 *  
#   x2           0.68522    0.04369  15.684    < 2e-16 ***
#   ---
#   Signif. codes:  
#   0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.5278 on 261 degrees of freedom
# Multiple R-squared:  0.5975,	Adjusted R-squared:  0.5945 
# F-statistic: 193.8 on 2 and 261 DF,  p-value: < 2.2e-16




# [ 더 적절한 독립변수 조합 찾기]

library(car)
Prestige  # 102개 직업군 평판 dataset
str(Prestige)  # 'data.frame':	102 obs. of  6 variables:
# $ education: 교육수준(x1)
# $ income   : 수입(y)
# $ women    : 여성 비율 (x3)
# $ prestige : 평판(x2)
# $ census   : 직업수
# $ type     : Factor w/ 3 levels "bc","prof","wc": 

row.names(Prestige)

df <- Prestige[,c(1:4)]
str(df)

model <- lm(formula=income~., data=df)
summary(model)
# 1. p-value: < 2.2e-16 통계가 유의미하다
# 2. Adjusted R-squared:  0.6323  예측력이 다소 높다. 약 63%
# 3. education 0.944    0.347    
#    women     -5.948 4.19e-08 ***
#    prestige  4.729 7.58e-06 ***
# 교육수준은 유의미한 수준에서 y에 영향을 미치지 않는다.
# 여성 비율과 평판은 유의미한 수준에서 y에 영향을 미친다.
# 특히 여성 비율은 y에 부(-)의 상관관계를 갖는다.

res <- model$residuals  # 잔차(오차) = 정답-예측치
summary(res)   # scaling 안되어있음을 알 수 있음
length(res)  # 102

shapiro.test(res)
# W = 0.76541, p-value = 1.816e-11  정규분포임
# MSE Mean Square Error  : 표준화?
mse <- mean(res**2) # 평균제곱오차

cat('MSE =', mse)  # MSE = 6369159  : 표준화 전
# MSE 값이 0에 수렴할수록 오차가 적다. 표준화가 안되어있음
# 따라서 이 분석방법으로 수입을 예측하기는 어렵다.?
mean(res)  # 1.704083e-14   0에 수렴한다.
# 정규분포0, 표준정규분포X

  
# 잔차 표준화
res_scale <- scale(res)  # mean=0, sd=1
shapiro.test(res)  # p-value = 1.816e-11

mse <- mean(res_scale**2)
cat('MSE =', mse)  # MSE = 0.9901961 : 표준화 후

# 제곱 : 부호 절대값, 패널티
# 평균 : 전체 오차에 대한 평균




#################################################
## 3. 변수 x 선택
#################################################

 new_data <- Prestige[,c(1:5)]
dim(new_data)  # 102   5

model2 <- lm(income~., data=new_data)

library(MASS)
step <- stepAIC(model2, direction = 'both')
# Step:  AIC=1604.96
# income ~ women + prestige
# AIC 값이 가장 작은것이 가장 적합한 변수 구성
# 100% 신빙성 있는 값 아니므로 참고자료로만 활용하고 맹신하지 말 것. 


model3 <- lm(income~prestige+women, data= new_data)
summary(model3)
# Adjusted R-squared:  0.6327
# 0.6323 vs 0.6327




###################################
# 4. 다중공선성(Multicolinearity)
###################################
# - 독립변수 간의 강한 상관관계로 인해서 회귀분석의 결과를 신뢰할 수 없는 현상
# - 생년월일과 나이를 독립변수로 갖는 경우
# - 해결방안 : 강한 상관관계를 갖는 독립변수 제거

# (1) 다중공선성 문제 확인

install.packages("car")  #  다중공선성 문제 확인
library(car)
library(car)
fit <- lm(formula=Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=iris)

vif(fit)  # 분산 팽창 요인을 제공하는 함수
# Sepal.Width Petal.Length  Petal.Width 
# 1.270815    15.097572    14.234335 

sqrt(vif(fit))>2 # root(VIF)가 2 이상인 것은 다중공선성 문제 의심 
# Sepal.Width Petal.Length  Petal.Width 
# FALSE         TRUE         TRUE 
# 둘 중 하나 빼면 좋음



# (2) iris 변수 간의 상관계수 구하기
cor(iris[,-5]) # 변수간의 상관계수 보기(Species 제외) 
#x변수 들끼 계수값이 높을 수도 있다. -> 해당 변수 제거(모형 수정) <- Petal.Width
#                Sepal.Length Sepal.Width Petal.Length Petal.Width
# Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
# Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
# Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
# Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000




# Petal.Width 변수 제거하면?
result.lm <- lm(formula = Sepal.Length~Sepal.Width+Petal.Length, data=iris)
vif(result.lm)
# Sepal.Width Petal.Length 
# 1.224831     1.224831 





# (3) 학습데이터와 검정데이터 분류
x <- sample(1:nrow(iris), 0.7*nrow(iris)) # 전체중 70%만 추출
x <- sample(nrow(iris), 0.7*nrow(iris))
train <- iris[x, ] # 학습데이터 추출  >> 70%
test <- iris[-x, ] # 검정데이터 추출  >> 30%
dim(train)  # 105   5  -> model 학습용
dim(test)  # 45  5  -> model 검정용. 테스트용



# (4) model생성(훈련용) : Petal.Width 변수를 제거한 후 회귀분석 
iris_model <- lm(formula=Sepal.Length ~ Sepal.Width + Petal.Length, data=train)
iris_model   # 랜덤 샘플이다. 새로 실행할 때마다 예측력 달라짐
# Coefficients:
#(Intercept)   Sepal.Width  Petal.Length  
# 2.3697        0.5596        0.4686  

summary(iris_model)
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -0.72793 -0.21021 -0.02213  0.19251  0.79310 
# 
# Coefficients:
#                Estimate  Std. Error  t value Pr(>|t|)    
#   (Intercept)   2.36966    0.26727   8.866   2.61e-14 ***
#   Sepal.Width   0.55963    0.07412   7.550   1.90e-11 ***
#   Petal.Length  0.46858    0.01852  25.297    < 2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.3027 on 102 degrees of freedom
# Multiple R-squared:  0.8667,	Adjusted R-squared:  0.864 
# F-statistic: 331.5 on 2 and 102 DF,  p-value: < 2.2e-16


# (5) model예측치 : test set
y_pred <- predict(iris_model, test)
y_pred
length(y_pred)  #  45

y_true <- test$Sepal.Length

# (6) model 평가 : MSE, cor

# MSE(표준화 된 경우)
Error <- y_true - y_pred  #정답-예측치
mse <- mean(Error^2)
cat('MSE =', mse)  # MSE = 0.1558699 오차가 작은 편.


# 상관계수 r 이용해서 모델평가 : 표준화 안됐어도 ok
r <- cor(y_true, y_pred)
cat('r =', r)  # r = 0.8800613  1에 가까울수록 좋은 예측


y_pred[1:10]
y_true[1:10]



# 시각화 평가
plot(y_true, col='blue', type='l', label='y true')
points(y_pred, col='red', type='l', label='y pred')
?points
#범례추가
legend("topleft", legend=c('y true', 'y pred'),
       col=c('blue', 'red'), pch-'-')


##########################################
##  5. 선형회귀분석 잔차검정과 모형진단
##########################################

# 잔차 : predicted - true (error)

# 1. 변수 모델링  : x, y변수 선정
# 2. 회귀모델 생성 :lm()
# 3. 모형의 잔차검정 
#   1) 잔차의 등분산성 검정
#   2) 잔차의 정규성 검정 
#   3) 잔차의 독립성(자기상관) 검정 
# 4. 다중공선성 검사 
# 5. 회귀모델 생성/ 평가 


names(iris)

# 1. 변수 모델링 : y:Sepal.Length <- x:Sepal.Width,Petal.Length,Petal.Width
formula = Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width


# 2. 회귀모델 생성 
model <- lm(formula = formula,  data=iris)
model
# Coefficients:
# (Intercept)   Sepal.Width  Petal.Length   Petal.Width  
# 1.8560        0.6508        0.7091       -0.5565 
names(model)


# 3. 모형의 잔차검정
plot(model)
#Hit <Return> to see next plot: 잔차 vs 적합값 -> 패턴없이 무작위 분포(포물선 분포 좋지않은 적합) : 등분산성 분포(포물선 분포)
#Hit <Return> to see next plot: Normal Q-Q -> 정규분포 : 대각선이면 잔차의 정규성 
#Hit <Return> to see next plot: 척도 vs 위치 -> 중심을 기준으로 고루 분포 
#Hit <Return> to see next plot: 잔차 vs 지렛대값 -> 중심을 기준으로 고루 분포 

# (1) 등분산성 검정 
plot(model, which =  1) 
methods('plot') # plot()에서 제공되는 객체 보기 

# (2) 잔차 정규성 검정
attributes(model) # coefficients(계수), residuals(잔차), fitted.values(적합값)
res <- residuals(model) # 잔차 추출 
shapiro.test(res) # 정규성 검정 - p-value = 0.9349 >= 0.05
# 귀무가설 : 정규성과 차이가 없다.

# 정규성 시각화  
hist(res, freq = F) 
qqnorm(res)

# (3) 잔차의 독립성(자기상관 검정 : Durbin-Watson) 
install.packages('lmtest')
library(lmtest) # 자기상관 진단 패키지 설치 
dwtest(model) # 더빈 왓슨 값
# DW = 2.0604, p-value = 0.6013
# 보통 DW : 2~4이면 채택역.
# [해설] 특정한 잔차가 다른 잔차와 상관성이 없다.



# 4. 다중공선성 검사 
library(car)
sqrt(vif(model)) > 2 # TRUE 

# 5. 모델 생성/평가 
formula = Sepal.Length ~ Sepal.Width + Petal.Length 
model <- lm(formula = formula,  data=iris)
summary(model) # 모델 평가




###########################################
### 6. x변수로 범주형 번수 사용
###########################################

# - 범주형 번수를 먼저 더미변수로 만들어줘야 함
#   gender -> (0, 1)
# - 범주형 변수는 기울기에 영향 X but, y절편에 영향 O
# - 범주형 번주가 n개이면, 더비변수의 수 : n-1
#   ex) 혈액형(AB, A, B, O) -> 적어도 3개 변수 필요
#          x1, x2, x3
#       A   1   0   0
#       B   0   1   0
#       O   0   0   1
#      AB   0   0   0 (base, 기준)
#   Factor : 범주형 -> 더미변수


# 의료비 예측
insurance  <- read.csv(file.choose())  # "insurance.csv"
str(insurance)
# 'data.frame':	1338 obs. of  7 variables:
# $ age     : 나이 : int  19 18 28 33 32 31 46 37 37 60 ...
# $ sex     : 성별 : Factor w/ 2 levels "female","male": 1 2 2 2 2 1 1 1 2 1 ...
# $ bmi     : 비만도지수 : num  27.9 33.8 33 22.7 28.9 ...
# $ children: 자녀수 : int  0 1 3 0 0 0 1 3 2 0 ...
# $ smoker  : 흡연유무 : Factor w/ 2 levels "no","yes": 2 1 1 1 1 1 1 1 1 1 ...
# $ region  : 지역 : Factor w/ 4 levels "northeast","northwest",..: 4 3 3 2 2 3 3 2 1 2 ...
# $ charges : 의료비(y)  num  16885 1726 4449 21984 3867 ...

# 번주형 변수 : sex(2), smoker(2), region(4)
# 기준(base) : level1(base)=0, level2(the others)=1

# 회귀모델 생성
insurance2 <- insurance[,-c(5,6)]
head(insurance2)
# female = 0, male = 1

ins_model <- lm(charges~., data=insurance2)
ins_model
# Coefficients:
# (Intercept)      age      sexmale          bmi     children  
# -7460.0        241.3       1321.7        326.8        533.2 
#                            ㄴ 여자에 비해 남자의 의료비가 1321.7 더 많다는 뜻

# [해석] 여성에 비해서 성의 의료비 증가
# y = a.X + b
y_male = 1321*1 + (-7460.0)
y_female = 1321*0 + (-7460.0)                         
y_male  # -6139 
y_female  # -7460


x <- c('male', 'female')
insurance2$sex <- factor(insurance2$sex, levels=x)

insurance2$sex  # factor level이 바뀌었음. 이제 남자가 0 base
# Levels : male(base)=0, female=1

ins_model <- lm(charges~., data=insurance2)
ins_model
# Coefficients:
# (Intercept)      age    sexfemale          bmi     children  
# -6138.2        241.3      -1321.7        326.8        533.2  
# [해석] 여성이 남성에 비해서 의료비 절감(-1321.7)

male <-subset(insurance2, sex=='male')
female <-subset(insurance2, sex=='female')

mean(male$charges)  # 13956.75
mean(female$charges)  # 12569.58
# 실제로 남녀별 평균 의료비는 여자가 더 작음


## dummy 변수 vs 절편 : 어떤 연관성?
insurance3 <- insurance[,-6]  # 거주지역만 제외
head(insurance3)

ins_model2 <- lm(charges ~ smoker, data=insurance3)
ins_model2
# (Intercept) smokeryes  >> nonsmokers are coded '0'
# 8434        23616

# base : smokerno=0, smokeryes=1
# [해석]  흡연자는 비흡연자에 비해 23616만큼 의료비가 증가한다.

no <- subset(insurance3, smoker=='no')
yes <- subset(insurance3, smoker=='yes')

mean(no$charges)  # 8434.268
mean(yes$charges)  # 32050.23


## 4개 범주 -> 3(n-1)개 더미변수 생성 : region 칼럼 사용
insurance4 <- insurance

ins_model3 <- lm(charges~., data=insurance4)
ins_model3
# (Intercept)          age          sexmale              bmi         children  
# -11938.5            256.9           -131.3            339.2          475.5  
# smokeryes  regionnorthwest  regionsoutheast  regionsouthwest  
# 23848.5           -353.0          -1035.0           -960.1  

#  이 중에서
# regionnorthwest   : x1
#           -353.0        
# regionsoutheast   : x2
#         -1035.0
# regionsouthwest   : x3
#        -960.1 
# regionnortheast   : x0(base) : 절편으로 표현






































