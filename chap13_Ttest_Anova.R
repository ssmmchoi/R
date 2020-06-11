# chap13_Ttest_Anova


##################################
##  표본의 확률분포
##################################
# 모집단으로 부터 추출한 표본들의 통계량에 대한 분포 
# - z, chi^2, t, f분포


# 1. z분포(표준정규분포) 
# 모집단의 모표준편차(σ)/모분산(σ^2)이 알려진 경우 사용 
# 용도: 평균치와 표준편차를 달리하는 모든 정규분포를 µ=0, σ=1을 
# 갖는 표준정규분포로 표준화 
# 표준화공식(Z) = (X - mu) / sigma : 정규분포 -> 표준정규분포 

# 2. chi^2 분포
# 표준정규분포를 따르는 변수의 제곱합에 대한 분포
# chi^2 =  (X - mu)^2 / sigma^2 : 표준정규분포 Z를 제곱한 것
# 몇개를 합햇는냐에 따라서 카이제곱분포의 모수인 '자유도'가 결정 
# 용도: 정규분포를 따르는 변수의 분산에 대한 신뢰구간을 구할 때 이용 

# 3. t분포
# 모집단의 모표준편차(σ)/모분산(σ^2)이 알려지지 않은 경우 사용
# z분포와 유사
# 용도: 정규분포를 따르는 집단의 평균에 대한 가설검정(모평균 추정)
#  or 두 집단의 평균차이 검정을 할 경우 이용
# 표본의 표준편차(S)를 이용하여 모집단 추정 
# T =  (X - mu) / S -> 표본의 표준편차 

# 4. F분포
# 두 카이제곱분포를 각각의 자유도로 나눈 다음, 그것의 비율을 나타낸 분포 
# 서로 다른 카이제곱 분포의 비율의 형태로 표현 
# F = V1/u1 / V2/u2
# 용도: 정규분포를 따르는 두 집단의 분산에 대한 가설검정을 할 경우 이용 

#####################
## 표준화 vs 정규화
#####################

# 1. 표준화 : 척도를(평균0, 표준편차1로) 일치시키기.
# - 정규분포 -> 표준정규분포

# 샘플링
n <- 1000
z <- rnorm(n, mean=100, sd=10)
# shapiro.test(z)
# data:  z
# W = 0.99818, p-value = 0.3673 >0.05

hist(z)
hist(z, freq = F)  #: 정규분포인데 표준정규분포는 아님

# 1) 표준화공식(Z) = (X - mu) / sigma : 정규분포 -> 표준정규분포 
mu = mean(z)
Z =(z-mu)/sd(z)
mean(Z)  # [1] 5.313605e-16
sd(Z)  # 1
hist(Z)

# 2) 표준화함수
z2 <- scale(Z)
z2
mean(z2)  # 5.29141e-16
sd(z2)  # 1
hist(Z)
# 표준정규분포의 +- 1 편차 영역 :약 68%,
# +-2 영역 : 약 95%, +-3 영역 : 약 99%


# 2. 정규화 : 값의 범위(0~1) 일치
# x1(-100~100), x2(-0.1~0.9), x3(-1000~1000) -> y
# - 서로 다른 변수의 값을 일정한 값으로 조정
# nor = (x-min)/max-min

nor <- function(x){   # 0~1로 정규화
  re = (x-min(x)) / (max(x)-min(x))
  return(re)
}

summary(iris[-5])
# Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
# Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100  
# 1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300  
# Median :5.800   Median :3.000   Median :4.350   Median :1.300  
# Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199  
# 3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800  
# Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500  
nor_re <- apply(iris[-5], 2, nor)
nor_re
summary(nor_re)
# Sepal.Length     Sepal.Width      Petal.Length     Petal.Width     
# Min.   :0.0000   Min.   :0.0000   Min.   :0.0000   Min.   :0.00000  
# 1st Qu.:0.2222   1st Qu.:0.3333   1st Qu.:0.1017   1st Qu.:0.08333  
# Median :0.4167   Median :0.4167   Median :0.5678   Median :0.50000  
# Mean   :0.4287   Mean   :0.4406   Mean   :0.4675   Mean   :0.45806  
# 3rd Qu.:0.5833   3rd Qu.:0.5417   3rd Qu.:0.6949   3rd Qu.:0.70833  
# Max.   :1.0000   Max.   :1.0000   Max.   :1.0000   Max.   :1.00000  


###################################################
#### 2. 일원배치 분산분석
##################################################

#############################################
# 추론통계분석 - 1-1. 단일집단 비율차이 검정
#############################################
# - 단일 집단(new)의 비율이 어떤 특정한 값(old)과 같은지를 검증

# 1. 실습데이터 가져오기
setwd("C:/ITWILL/Work/2_Rwork/Part-III")
data <- read.csv("one_sample.csv", header=TRUE)
head(data)
x <- data$survey

# 2. 빈도수와 비율 계산
summary(x) # 결측치 확인
length(x) # 150개
table(x) # 0:불만족(14), 1: 만족(136) 

prop.table(table(x))
# 0          1 
# 0.09333333 0.90666667 

install.packages("prettyR")
library(prettyR) # freq() 함수 사용
freq(x) 

# 3. 가설검정 

# 형식) binom.test(성공횟수, 시행횟수, p = 확률)

# 1) 불만족율 기준 검정
# 양측검정 : 귀무가설 채택/기각 결정
binom.test(14, 150, p=0.2) # 기존 20% 불만족율 기준 검증 실시
binom.test(14, 150, p=0.2, alternative="two.sided", conf.level=0.95)
# p-value = 0.0006735 < 0.05 귀무가설은 기각됨.
# 귀무가설 : 2014년과 2015년 불만족도의 차이가 없다.
# 해석 : 2014년과 2015년 설문조사 결과 불만족도에 차이가 있다.
# 그렇다면, 세부적으로는 어떤 차이?

# 방향성이 있는 대립가설 단측검정 (new>old인가?)
binom.test(14, 150, p=0.2, alternative="greater", conf.level=0.95)
# p-value = 0.9999 > 0.05
# 가설 기각. 

# [실습]방향성이 있는 대립가설 단측 검정 (new<old인가?)
binom.test(14, 150, p=0.2, alternative="less", conf.level=0.95)
# p-value = 0.0003179  <  0.05
# 가설 채택. new<old이다.
# 즉, 2014년에 비해 2015년의 불만족 비율은 감소했다.


#############################################
# 추론통계분석 - 1-2. 단일집단 평균차이 검정
#############################################
# - 단일 집단의 평균이 어떤 특정한 값과 차이가 있는지를 검증
# t분포 용도: 정규분포를 따르는 집단의 평균에 대한 가설검정

# 1. 실습파일 가져오기
data <- read.csv("one_sample.csv", header=TRUE)
str(data) # 150
head(data)
x <- data$time
head(x)

# 2. 기술통계량 평균 계산
summary(x) # NA-41개
mean(x) # NA
mean(x, na.rm=T) # NA 제외 평균(방법1)  # 5.556881

x1 <- na.omit(x) # NA 제외 평균(방법2)
mean(x1)

# 3. 정규분포 검정
# 정규분포(바른 분포) : 평균에 대한 검정 
# 정규분포 검정 귀무가설 : 정규분포와 차이가 없다.
# shapiro.test() : 정규분포 검정 함수

shapiro.test(x1) # 정규분포 검정 함수(p-value = 0.7242) 
# p > 0.05 정규분포와 차이가 없다. 정규분포다 -> t.test

# 4. 가설검정 - 모수/비모수
# 정규분포(모수검정) -> t.test()
# 비정규분포(비모수검정) -> wilcox.test()

# 1) 양측검정 - 정제 데이터와 5.2시간 비교
t.test(x1, mu=5.2) 
t.test(x1, mu=5.2, alter="two.side", conf.level=0.95) # p-value = 0.0001417
#t = 3.9461, df = 108, p-value = 0.0001417
# t,z,F 검정통계량 채택역 : -1.96~+1.96 : 실제 t값은 3.9461 채택역 밖에 있음.
# 해설 : 귀무가설 기각. 평균 사용시간 5.2시간과 차이가 있다.

# 2) 방향성이 있는 연구가설 검정 
t.test(x1, mu=5.2, alter="greater", conf.level=0.95) 
# p-value = 7.083e-05 < 0.05
# 해설 : 5.2보다 크다

# 반대로해보면
t.test(x1, mu=5.2, alter="less", conf.level = 0.95)
# t = 3.9461, df = 108, p-value = 0.9999
# p > 0.05 이므로 귀무가설 채택
# 귀무가설 : 평균이 5.2보다 작지 않다.
# 해설 : 평균이 5.2보다 크다.



#############################################
# 추론통계분석 - 2-1. 두집단 비율차이 검정
#############################################

# 1. 실습데이터 가져오기
data <- read.csv("two_sample.csv", header=TRUE)
data
head(data) # 변수명 확인


# 2. 두 집단 subset 작성
data$method # 1, 2 -> 노이즈 없음
data$survey # 1(만족), 0(불만족)

# - 데이터 정체/전처리
x<- data$method # 교육방법(1, 2) -> 노이즈 없음
y<- data$survey # 만족도(1: 만족, 0:불만족)

x;y

# 1) 데이터 확인
# 교육방법 1과 2 모두 150명 참여
table(x) # 1 : 150, 2 : 150
# 교육방법 만족/불만족
table(y) # 0 : 55, 1 : 245

# 2) data 전처리 & 두 변수에 대한 교차분석
table(x, y, useNA="ifany") 


# 3. 두집단 비율차이검증 - prop.test( )

# 양측가설 검정 - 카이스퀘어테스트, 프랍 테스트 결과는 같음
chisq.test(x,y)
# p-value = 0.0003422
prop.test(c(110,135), c(150, 150)) # 14와 20% 불만족율 기준 차이 검정
prop.test(c(110,135), c(150, 150), alternative="two.sided", conf.level=0.95)
# p-value = 0.0003422 < 0.05 귀무가설 기각
# 귀무가설 : 두 방법 만족도에 차이가 없다.
# 해설 : 두 방법 만족도에 차이가 있다.

# # 방향성이 있는 대립가설 검정  PT > Code인가?
prop.test(c(110,135), c(150, 150), alternative="greater", conf.level=0.95)
# p-value = 0.9998 > 0.05 귀무가설 채택

prop.test(c(110,135), c(150, 150), alternative="less", conf.level=0.95)
# p-value = 0.0001711 < 0.05 귀무가설 기각
# 해설 : PT 강의 방식 불만족도가 더 높다.



#############################################
# 추론통계분석 - 2-2. 두집단 평균차이 검정 : 독립 표본 T 검정
#############################################

# 1. 실습파일 가져오기
data <- read.csv("two_sample.csv")
data 
head(data) #4개 변수 확인
summary(data) # score - NA's : 73개

# 2. 두 집단 subset 작성(데이터 정제,전처리)
#result <- subset(data, !is.na(score), c(method, score))
dataset <- data[c('method', 'score')]
table(dataset$method)
head(dataset$score)

# 3. 데이터 분리
# 1) 교육방법 별로 분리
method1 <- subset(dataset, method==1)
method2 <- subset(dataset, method==2)


# 2) 교육방법에서 점수 추출
method1_score <- method1$score
method2_score <- method2$score
mean(method1$score, na.rm=T)  # 5.556881
mean(method2$score, na.rm = T)  # 5.80339

# 3) 기술통계량 
length(method1_score); # 150
length(method2_score); # 150

# 4. 분포모양 검정 : 두 집단의 분포모양 일치 여부 검정
var.test(method1_score, method2_score) 
# p 0.3002 > 0.05 두 집단의 분포모양은 차이가 없다.(귀무가설 채택)
# 동질성 분포 : t.test()
# 비동질성 분포 : wilcox.test()

# 5. 가설검정 - 두집단 평균 차이검정
t.test(method1_score, method2_score)
t.test(method1_score, method2_score, alter="two.sided", conf.int=TRUE, conf.level=0.95)
# p-value = 0.0411 - 두 집단간 평균에 차이가 있다.

# # 방향성이 있는 연구가설 검정   ppt > code?
t.test(method1_score, method2_score, alter="greater", conf.int=TRUE, conf.level=0.95)
#  p-value = 0.9794 > 0.05 
#  ppt가 code보다 높지 않다.(귀무가설) 채택










################################################
# 추론통계분석 - 2-3. 대응 두 집단 평균차이 검정
################################################
# 조건 : A집단  독립적 B집단 -> 비교대상 독립성 유지
# 대응 : 표본이 짝을 이룬다. -> 한 사람에게 2가지 질문
# 사례) 다이어트식품 효능 테스트 : 복용전 몸무게 -> 복용후 몸무게 

# 1. 실습파일 가져오기
getwd()
setwd("c:/Rwork/Part-III")
data <- read.csv("paired_sample.csv", header=TRUE)
data
length(data$no)  # 100


# 2. 두 집단 subset 작성

# 1) 데이터 정제
#result <- subset(data, !is.na(after), c(before,after))
result <- subset(data, !is.na(after), c(before,after))
dataset <- result[ c('before',  'after')]
dataset

# 2) 적용전과 적용후 분리
before <- dataset$before# 교수법 적용전 점수
after <- dataset$after # 교수법 적용후 점수
before; after



# 3) 기술통계량 
length(before) # 100
length(after) # 100
mean(before) # 5.145
mean(after, na.rm = T) # 6.220833 -> 1.052  정도 증가


# 3. 분포모양 검정 
var.test(before, after, paired=TRUE) 
# 동질성 분포 : t.test()
# 비동질성 분포 : wilcox.test()
# p-value = 0.7361 > 0.05 이므로 귀무가설 채택
# 귀무가설 : 두 집단의 분포 모양은 차이가 없다.
# 해설 : 분포모양 같다. >> t.test

# 4. 가설검정
t.test(before, after, paired=TRUE) # (p-value < 2.2e-16 ) <0.0.5 이므로 귀무가설 기각
# 귀무가설 : 두 집단의 평균에 차이가 없다.
# 해설 : 두 집단의 평균에는 차이가 있다.
# 어떤 차이가 있나?


# 방향성이 있는 연구가설 검정 
t.test(before, after, paired=TRUE,alter="greater",conf.int=TRUE, conf.level=0.95) 
#p-value = 1 -> x을 기준으로 비교 : x가 y보다 크지 않다.

#  방향성이 있는 연구가설 검정
t.test(before, after, paired=TRUE,alter="less",conf.int=TRUE, conf.level=0.95) 
# p-value < 2.2e-16 -> x을 기준으로 비교 : x가 y보다 적다.










############################################
# 추론통계분석 - 3-1. 두 집단 이상 비율차이 검정
############################################
# - 두 집단 이상 비율차이 검정

# 1. 파일가져오기 
data <- read.csv("three_sample.csv", header=TRUE)
data

# 2. 두 집단 이상 subset 작성(데이터 정제,전처리) 
method <- data$method 
survey<- data$survey
method
survey 

# 3.기술통계량(빈도분석)
table(method, useNA="ifany") # 50 50 50 -> 3그룹 모두 관찰치 50개
table(method, survey, useNA="ifany") # 그룹별 클릭수 : 1-43, 2-34, 3-37


# 4. 두 집단 이상 비율차이 검정
# prop.test(그룹별 빈도, 그룹수) -> 집단이 늘어나도 동일한 함수 사용-땡큐
prop.test(c(34,37,39), c(50,50,50)) # p-value = 0.5232 -> 귀무가설 채택
# 해설 : 방법에 따라 만족도에 차이가 있다.




############################################
# 추론통계분석 - 3-2. 두 집단 이상 평균차이 검정 : 분산분석(Anova분석)
############################################
# 두 집단 이상 평균차이 검정 
# 독립변수 : 집단변수(범주형)
# 종속변수 : 숫자변수(연속형) - 평균을 구해야 하기 때문

# 1. 파일 가져오기
data <- read.csv("three_sample.csv")

# 2. 데이터 정제/전처리 - NA, outline 제거
data <- subset(data, !is.na(score), c(method, score)) 
data # method, score

# (1) 차트이용 - ontlier 보기(데이터 분포 현황 분석)
length(data$method)
plot(data$score) # 차트로 outlier 확인 : 50이상과 음수값
barplot(data$score) # 바 차트
mean(data$score) # 14.45
boxplot(data$score)$stats
#      [,1]
# [1,] 2.00
# [2,] 4.35
# [3,] 5.80
# [4,] 6.50
# [5,] 8.50

# (2) outlier 제거 - 8.50 이상 제거
length(data$score)#91
data2 <- subset(data, score <= 8.5)
length(data2$score) #88(3개 제거)

# (3) 정제된 데이터 보기 
x <- data2$score
boxplot(x)
plot(x)

# 3. 집단별 subset 작성
# method: 1:방법1, 2:방법2, 3:방법3
data2$method2[data2$method==1] <- "방법1" 
data2$method2[data2$method==2] <- "방법2"
data2$method2[data2$method==3] <- "방법3"

table(data2$method2) # 교육방법 별 빈도수 

# 4. 동질성 검정 - 정규성 검정
# bartlett.test(종속변수 ~ 독립변수(formula), 소속) # 독립변수(세 집단)
bartlett.test(score ~ method2, data=data2)

# 귀무가설 : 집단 간 분포의 모양이 동질적이다.
# 해설 : 유의수준이 0.05보다 크기 때문에 귀무가설을 기각할 수 없다. 

# 동질한 경우 : aov() - Analysis of Variance(분산분석)
# 동질하지 않은 경우 - kruskal.test()

# 5. 분산검정(집단이 2개 이상인 경우 분산분석이라고 함)
# aov(종속변수 ~ 독립변수, data=data set)

# 귀무가설 : 집단 간 평균에 차이가 없다.
result <- aov(score ~ method2, data=data2)
result

# aov()의 결과값은 summary()함수를 사용해야 p-value 확인 
summary(result) 
#              Df  Sum   Sq Mean Sq   F value    Pr(>F)    
# method2      2   99.37     49.68     43.58     9.39e-14 ***
# Residuals   85   96.90     1.14                     
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# 해설 : 매우 유의미한 수준에서 적어도 한 집단에서 평균에 차이를 보인다.

# F value(F 검정 통계량)이 채택역 (-1.96 ~ +1.96)속하면 귀무가설 채택
#                                                속하지 않으면 귀무가설 기각
# F value가 커질수록 p-value는 작아진다. (p/F)


# 사후검정
TukeyHSD(result)
# $method2
#                  diff        lwr        upr     p adj
# 방법2-방법1  2.612903  1.9424342  3.2833723 0.0000000
# 방법3-방법1  1.422903  0.7705979  2.0752085 0.0000040
# 방법3-방법2 -1.190000 -1.8656509 -0.5143491 0.0001911
#              ㄴ 1과 2차이가 가장큼 
#                         ㄴ 95%에서 상한값
#                                   ㄴ 하한값
#                                               ㄴ 각 경우에서 p-value : 유의미한 수준에서 귀무가설이 기가고딤
# [해설] 95% 신뢰수준에서(유의미한 수준에서) 세 집단 모두 집단 간 평균의 차이를 보인다.


plot(TukeyHSD(result))
# 그래프 가로 막대기가 0점에 겹쳐져 있으면 '집단 간 평균의 차이가 없다'고 해석할 수 있다.
# 즉 신뢰구간에서 0을 포함하면 집단간 차이 없음




###################################################
#### 2. 이원배치 분산분석
##################################################
# 종속변수 ~ 독립변수1 + 독립변수2
# - 쇼핑몰 고객의 연령대별(20~50대), 시간대별(오전, 오후) 구매
# - 독립변수 : 연령대, 시간대
# - 종속변수 : 구매현황

# 1. dataset 생성
age <- round(runif(100, 20, 59))
age
time <- round(runif(100,0,1))
time
buy <- round(runif(100,0,1))
buy

df <- data.frame(age, time, buy)
df %>% head()
# age, time 을 독립변수로 사용할 것.
# age는 연속변수이기 때문에 독립변수로 쓰기 위해 범주형으로 바꿔줄 것.

# 연속형 -> 범주형
df$age2[df$age <= 29] <- 20
df$age2[df$age > 30 & df$age <= 39] <- 30
df$age2[df$age > 40 & df$age <= 49] <- 40
df$age2[df$age > 50] <- 50

head(df)

# 2. 동질성 검정
bartlett.test(buy ~ age2, data=df)
# p-value = 0.9555 >= 0.05 이므로 귀무가설 채택. 분포모양 동질하다.
bartlett.test(buy ~ time, data=df)
# p-value = 0.9187 >= 0.05 이므로 귀무가설 채택. 분포모양 동질하다.

# 3. 분산분석
# 귀무가설 : 집단간 평균에 차이가 없다.
# 대립가설 : 적어도 한 집단에 평균에 차이가 있다.

result <- aov(formula=buy~age2+time, data=df)
summary(result)
#             Df Sum Sq Mean Sq      F value     Pr(>F)
# age2         1  0.137 0.13675       0.549      0.461
# time         1  0.061 0.06054       0.243      0.623
# Residuals   97 24.163 0.24910  
# F value가 -1.96~+1.96 이내에 있으므로 귀무가설 채택역
# p-value도 모두 알파 0.05이상이므로 귀무가설 채택역
# [해설] 연령대와 시간대별로 구매율에는 차이가 없다. 랜덤하다.


# 4. 사후검정
TukeyHSD(result)
# Error in TukeyHSD.aov(result) : 적합된 모델에 요인들이 없습니다
# 추가정보: 경고메시지(들): 
# 1: In replications(paste("~", xx), data = mf) :
#   다음과 같이 요인이 아닌 것들은 무시됩니다: age2
# 2: In replications(paste("~", xx), data = mf) :
#   다음과 같이 요인이 아닌 것들은 무시됩니다: time
# Tukey로 사후검정 안된다~~

# 따라서 집단별 분산차이를 구해야 함
library(dplyr)
df %>% group_by(age2) %>% summarise(buy_age = mean(buy))
#    age2   buy_age
#    <dbl>   <dbl>
# 1    20   0.28 
# 2    30   0.571
# 3    40   0.424
# 4    50   0.429

df %>% group_by(time) %>% summarise(buy_time = mean(buy))
#     time    buy_time
#     <dbl>    <dbl>
# 1     0    0.442
# 2     1    0.396


