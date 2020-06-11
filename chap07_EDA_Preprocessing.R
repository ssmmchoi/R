# chap07_EDA_Preprocessing

# 1. 탐색적 데이터 조회

# 실습 데이터 읽어오기
setwd("C:/ITWILL/Work/2_Rwork/Part-II")
dataset <- read.csv("dataset.csv", header=TRUE) # 헤더가 있는 경우우
 #  dataset.csv - 칼럼과 척도 관계 
dataset %>% head()
install.packages("dplyr")

# 1) 데이터 조회
# - 탐색적 데이터 분석을 위한 데이터 조회 

# (1) 데이터 셋 구조
names(dataset) # 변수명(컬럼)
attributes(dataset) # names(), class, row.names
str(dataset) # 데이터 구조보기
dim(dataset) # 차원보기 : 300 7
nrow(dataset) # 관측치 수 : 300
length(dataset) # 칼럼수 : 7 
length(dataset$resident) # 300

# (2) 데이터 셋 조회
# 전체 데이터 보기
dataset # print(dataset) 
View(dataset) # 뷰어창 출력

# 칼럼명 포함 간단 보기 
head(dataset)
head(dataset, 10) 
tail(dataset) 

# (3) 칼럼 조회 
# 형식) dataframe$칼럼명   
dataset$resident
length(dataset$age) # data 수-300개 

# 형식) dataframe["칼럼명"] 
dataset["gender"] 
dataset["price"]

# 형식) dataframe[색인] : 색인(index)으로 원소 위치 지정 
res <- dataset$resident  # $
res2 <- dataset['resident']  # index
str(res)  # int [1:300] 1 2 NA 4 5 3 2 5 NA 2 ...
str(res2)  
# 'data.frame':	300 obs. of  1 variable:   >> 2차원으로.
# $ resident: int  1 2 NA 4 5 3 2 5 NA 2 ...

## 둘은 벡터로들어오냐, 행렬로 들어오냐의 차이가 있음

dataset[2] # 두번째 컬럼   == dataset['gender']
dataset[6] # 여섯번째 컬럼
dataset[3,] # 3번째 관찰치(행) 전체
dataset[,3] # 3번째 변수(열) 전체  -- vector dataset$job

# dataset에서 2개 이상 칼럼 조회
dataset[c("job", "price")]
dataset[c("job":"price")] # error 
dataset[c(2,6)] 
dataset[c(2:6)]

dataset[c(1,2,3)] 
dataset[c(1:3)] 
dataset[c(2,4:6,3,1)] 
dataset[-c(2)] # dataset[c(1,3:7)] 

# 2. 결측치(NA) 발견과 처리
# 9999999 - NA

# 결측치 확인
summary(dataset$price)
#   Min.  1st Qu.  Median   Mean  3rd Qu.    Max.   NA's 
# -457.200  4.425   5.400  8.752  6.300   675.000    30 

table(is.na(dataset$price))  ## 특정 컬럼을 대상으로 결측치 확인
# FALSE  TRUE 
# 270    30 

table(is.na(dataset))    ## 전체 컬럼을 대상으로
# FALSE  TRUE 
# 1982   118 

# 1) 결측치 제거
price2 <- na.omit(dataset$price)  # 특정 컬럼 대상
length(price2)  # 270 : 30개의 na가 지워진것.
price2

dataset2 <- na.omit(dataset)  # 전체 컬럼 대상
dim(dataset2)  # 209  7

## 이렇게 무식하게 omit 시키면 다른 데이타가 함께 날라감.


# 특정 칼럼 기준으로 결측치 제거 -> subset 생성
stock <- read.csv(file.choose()) #part1/stock.csv
str(stock)  #5028   69

library(dplyr)
stock_df <- stock %>% filter(!is.na(Market.Cap))  ## Market.Cap은 시가총액
dim(stock_df)  # 5028   69

stock_df2 <- subset(stock, !is.na(Market.Cap))
dim(stock_df2)  # 5028   69

# 2) 결측치 처리(0으로 대체)
x <- dataset$price
dataset$price2 <- ifelse(is.na(x), 0, x)
dim(dataset)   # 300   8   7개였는데 price2 가 하나 늘어남

# 3) 결측치 처리(평균으로 대체)
dataset$price3 <- ifelse(is.na(x), round(mean(x, na.rm=T),1), x)
dim(dataset)   # 300   9

head(dataset[c('price', 'price2', 'price3')], 30)


########################################################
########################################################

# 4) 통계적 방법의 결측치 처리
# 1학년~4학년 : age 결측치 -> 각 학년별 평균으로 대체
age <- round(runif(12, 20, 25))
age  # 22 23 23 20 25 21 24 24 22 21

grade <- rep(1:4, 3)
grade  #   1 2 3 4 1 2 3 4 1 2 3 4

age[c(5,8)] <- NA
age

DF <- data.frame(age, grade)
DF

age <- DF$age
age

ex <- group_by(DF, grade)
avg_age_grade <- summarise(ex, avg_grade = mean(ex$age, na.rm=T))
#    grade      avg_grade
#    <int>          <dbl>
# 1     1             22
# 2     2             22
# 3     3             22
# 4     4             22

# age 칼럼 대성 학년별 결측치 처리 -> age2 만들기

age_1 <- filter(DF, grade==1)
age_2 <- filter(DF, grade==2)
age_3 <- filter(DF, grade==3)
age_4 <- filter(DF, grade==4)

# grade <- DF$grade 
# DF$age2 <- if(is.na(age){
#   
# } 
#                   ifelse(grade == 1, avg_age_grade$avg_grade[1],
#                          ifelse(grade==2))
#                   mean(age, na.rm = T), age) 
# 

# age_sample <- function(a,b){
#   for(a in age){
#     
#   if(is.na(a)){
#   if(DF$grade==1){print(mean(age_1$age, na.rm=T))
#   }else if(DF$grade==2){print(mean(age_2$age, na.rm=T))
#   }else if(DF$grade==3){print(mean(age_3$age, na.rm=T))
#   }else{print(mean(age_4$age, na.rm=T))}
# }else{print(a)}
# }
# }




DF <- data.frame(age, grade)
DF
age <- DF$age
age
ex <- group_by(DF, grade)
summ_age <- summarise(ex, avg_grade = mean(ex$age, na.rm=T))
#    grade      avg_grade
#    <int>          <dbl>
# 1     1             22
# 2     2             22
# 3     3             22
# 4     4             22
a1 <- filter(DF, grade==1)
a1<-round(mean(a1$age, na.rm=T))
a1
a2 <- filter(DF, grade==2)
a2 <- round(mean(a2$age, na.rm=T))
a2
a3 <- filter(DF, grade==3)
a3 <- round(mean(a3$age, na.rm=T))
a4 <- filter(DF, grade==4)
a4<-round(mean(a4$age, na.rm=T))

a<-c(a1,a2,a3,a4)

# DF$age2 <- for(i in DF$age){
#   if(is.na(i)){
#     
#     if(DF$grade==1){print(a1)}
#     else if(DF$grade==2){print(a2)}
#     else if(DF$grade==3){print(a3)}
#     else{print(a4)}
#   }
#   else{print(i)}
# }


idx <- 1:12
idx
for(i in idx){
   cat(DF$age[i], ' ')
   cat(DF$grade[i], '\n')
}

IDX <- function(i){
  print(DF$grade[i])
}
IDX(1)
IDX(2)
IDX(4)
IDX(5)


print(a1)

DF$age2 <- DF$age
 for(i in idx){
  if(is.na(DF$age[i])){
    
    if(DF$grade[i]==1){DF$age2[i] <- a1}
    else if(DF$grade[i]==2){DF$age2[i] <- a2}
    else if(DF$grade[i]==3){DF$age2[i] <- a3}
    else{DF$age2[i] <- a4}
  }
  else{print(DF$age[i])}
}




DF$age2 <- DF$age
for (i in idx){
  if(is.na(DF$age[i])){
    DF$age2[i] <- a[DF$grade[i]]
  }else{
    DF$age2[i] <- DF$age[i]
  }
}

DF


########################################################
########################################################

# 3. 이상치(outlier)발견과 정제
# - 정의 : 정상 범주에서 크게 벗어난 값

# 2) 범주형(집단) 변수
gender <- dataset$gender
gender
str(dataset)  # 00 obs. of  7 variables:


# 이상치 발견 : table(),chart
table(gender)
# 0   1   2   5 
# 2 173 124   1 
# number 0, 5 is an outlier

pie(table(gender))

# 이상치 정제
dataset <- subset(dataset, gender==1|gender==2)
str(dataset)  # 297 obs. of  7 variables:
              # 성별이 이상하게 코딩된 row는 모두 사라짐
pie(table(dataset$gender))

# 2) 연속형 변수
price <- dataset$price
length(price)  # 297
table(is.na(price))
# FALSE  TRUE 
# 267    30 
dotchart(price)
summary(price)
# Min.       1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
# -457.200    4.400    5.400    8.784    6.300  675.000       30 

# if 2~10 정상 범주라고 하면
dataset2 <-subset(dataset,price>=2&price<=10)
dataset2
dim(dataset2)  #[1] 248   7  297개에서 49개가 지워짐
plot(dataset2$price)
plot(price)
boxplot(dataset2$price)
boxplot(price)

# dataset2를 대상으로 age(20~69)이 정상범주
dataset2 <- subset(dataset2, age>=20&age<=69)
dim(dataset2)  # 232   7

boxplot(dataset2$age)
plot(dataset2$age)

# 3) 이상치 발견이 어려운 경우
boxplot(dataset$price)$stats  # 정상범주에서 상하위 0.3%
#      [,1]
# [1,]  2.1
# [2,]  4.4
# [3,]  5.4
# [4,]  6.3
# [5,]  7.9

re <- subset(dataset, price>=2.1&price<=7.9)
boxplot(re$price)$stats
#      [,1]
# [1,]  2.3
# [2,]  4.6
# [3,]  5.4
# [4,]  6.2
# [5,]  7.9

# [실습]
library(ggplot2)
str(mpg)

hwy<-mpg$hwy
length(hwy)  # 234

boxplot(hwy)$stats
#      [,1]
# [1,]   12
# [2,]   18
# [3,]   24
# [4,]   27
# [5,]   37

# 정제 방법 1) subset
mpg_df <- subset(mpg, hwy>=12&hwy<=37)
dim(mpg_df)  # 231  11
boxplot(mpg_df$hwy)

# 정제 방법 2) NA 처리
mpg$hwy2 <- ifelse(mpg$hwy<12 | mpg$hwy>37, NA, mpg$hwy)
mpg %>% head()
select(mpg, hwy, hwy2)
mpg_df <- as.data.frame(mpg)

mpg_df[c('hwy','hwy2')]

# 4. 코딩 변경
# -데이터 가독성, 척도 변경, 최초 코딩 내용 변경

# 1) 데이터 가독성
# 형식) dataset$새칼럼[조건식] <- "값"
dataset$gender2[dataset$gender==1] <- '남자'
dataset$gender2[dataset$gender==2] <- '여자'
dataset$gender2 %>% head(15)
table(dataset$gender2)

table(dataset2$resident)
# 1     2   3   4   5 
# 102  46  22  13  34 
head(dataset2)
table(is.na(dataset2$resident))

head(dataset2)
dataset2$resident2[dataset2$resident==1] <- "1. 서울특별시"
dataset2$resident2[dataset2$resident==2] <- "2. 인천광역시"
dataset2$resident2[dataset2$resident==3] <- "3. 대전광역시"
dataset2$resident2[dataset2$resident==4] <- "4. 대구광역시"
dataset2$resident2[dataset2$resident==5] <- "5. 시구군"
head(dataset2)

# 2) 척도 변경 : 연속형 -> 범주형
range(dataset2$age)  # 20 69
# 20~30청년층, 31~55중년층, 56~장년층
dataset2$age2[dataset2$age<=30] <- "청년층"
dataset2$age2[dataset2$age>=31 & dataset2$age<= 55] <- "중년층"
dataset2$age2[dataset2$age>=56] <- "장년층"

dataset2$age2
table(dataset2$age2)
head(dataset2)

# 3) 역코딩 : 1->5, 5->1
table(dataset$survey)
#  1   2   3   4   5     1번이 매우 만족, 5번이 매우 불만족이라고 치면
# 17 115 123  36   6     5번을 매우만족으로, 1번을 매우불만족으로 바꾸겟다
# 6을 기준으로 대상값을 빼면 됨.

survey <- dataset2$survey
survey
csurvey <- 6-survey
csurvey
data.frame('역코딩 이전'=survey, '역코딩 이후'=csurvey)
table(csurvey)
# 1  2  3  4  5 
# 6 27 93 91 15 

# 5. 탐색적 분석을 위한 시각화
# - 변수 간의 관계 분석

setwd("C:/ITWILL/Work/2_Rwork/Part-II")
new_data <- read.csv("new_data.csv")
dim(new_data)   # 231  15
str(new_data)

# 1) 범주형(명목/서열 척도) vs 범주형(명목/서열)
# - 방법 : 교차테이블, barplot

# 거주지역(5) vs 성별(2)
tab1 <- table(new_data$resident2, new_data$gender2)
tab1
#               남자 여자
# 1.서울특별시   67   43
# 2.인천광역시   26   20
# 3.대전광역시   16   10
# 4.대구광역시    6    9
# 5.시구군       19   15

barplot(tab1, beside=T, horiz = T, col=rainbow(5),
        main='성별에 따른 거주지역 분포 현황',
        xlim= c(0,70),
        legend=row.names(tab1))

install.packages("reshape2")
library(reshape2)
tab3 <- dcast(tab1, col~row)
######????????????????????????????????????????????????????

# 이번엔 거주지역에 따른 성별 분포 현황
tab2 <- table(new_data$gender2, new_data$resident2)
tab2

barplot(tab2, beside=T, horiz = T, col=rainbow(2),
        main='거주지역에 따른 성별의 분포 현황',
        xlim= c(0,70),
        legend=row.names(tab2))

# 정사각형 기준
mosaicplot(tab1, col=rainbow(5),
           main = '성별에 따른 거주지 분포 현황')

# 고급시각화 : 직업유형(범주형) vs 나이(범주형)
library(ggplot2)  # chap08

obj <- ggplot(data=new_data, aes(x=job2, fill=age2))
obj + geom_bar()
# 객체에 직접 차트 유형 추가
?ggplot

# 막대차트 밀도 비교 가능하도록, 밀도1 기준으로 채우기
obj + geom_bar(position="fill")

table(new_data$job2, new_data$age2, useNA= 'ifany')
# useNA는 결측치 데이타를 추가해줌
#            장년층 중년층 청년층 <NA>
# 개인사업     18     30     29    8
# 공무원       20     20     14    4
# 회사원       11     49     14    2
# <NA>          2      3      7    0


# 2) 숫자형(비율/등간) vs 범주형(명목/서열)

install.packages("lattice")  # chap08
library(lattice)

# 나이(비율) vs 직업유형(명목)
# densityplot( ~ x축, data= dataset)
densityplot( ~ age, data= new_data)
barplot(table(new_data$age))

densityplot( ~ age, groups= job2, data = new_data,
             auto.key =T)
#groups= 집단변수 는 각 격자 내에 그룹 효과
#auto.key=T 는 범례 추가

# 3) 숫자형(비율) vs 범주형(명목) vs 범주형(명목)
# (1) 구매금액을 성별과 직급으로 분류

densityplot(~price | factor(gender2),
            groups = position2,
            data = new_data, auto.key = T)
# |factor(집단변수) : 범주의 수만큼 격자 생성
# groups = 집단변수 : 각 격자 내의 그룹 효과

# 구매 금액을 직급과 성별로 분류
densityplot(~price |factor(position2),
           groups=gender2, data=new_data,
           auto.key=T)

# 4) 숫자형 vs 숫자형 or 숫자형 vs 숫자형 vs 범주형
# - 방법 : 상관계수, 산점도, 산점도 행렬

# (1) 숫자형(age) vs 숫자형(price)
cor(new_data$age, new_data$price)  #NA

new_data2 <- na.omit(new_data)
new_data2

cor(new_data2$age, new_data2$price)
# 0.0881251 : +-0.3~0.4이상이 나와야 상관성이 있다고 볼 수 있음
plot(new_data2$age, new_data2$price)

# (2) 숫자형 vs 숫자형vs 범주형(성별)
# xyplot(y~x, data)
xyplot(price~age, data=new_data)
xyplot(price~age |factor(gender2),
       data=new_data)


# 6. 파생변수 생성
# - 기존변수 이용해서 새로운 변수
# 1) 사칙연산
# 2) 1:1 :기존 컬럼 하나를 가지고 새로운 칼럼 생성(1개)
# 3) 1:n : 기준변수를 토대로 새로운 변수를 만들기(n개)

# 고객정보 테이블
user_data <- read.csv("user_data.csv")
str(user_data)

# 1) 1:1 : 기존칼럼 -> 새로운 칼럼(1)
# 더미 변수 : 1,2 -> 1, 3,4 -> 2
user_data$house_type2 <-
  ifelse(user_data$house_type == 1|
           user_data$house_type ==2, 1, 2)
user_data$house_type2
table(user_data$house_type2)
# 1   2 
# 79 321 

# 원래는 
# table(user_data$house_type)
# 1   2   3   4 
# 32  47  21 300 

# 2) 1:n 기존변수 -> 새로운 칼럼(n)
# 지불 정보 테이블
pay_data <- read.csv("pay_data.csv")
str(pay_data)
# "user_id" "product_type" "pay_method" "price"(비율)

library(dplyr)
library(reshape2)
#dcast(dataset, 행집단변수~열집단변수, func)
# long -> wide

# 고객별 상품유형에 따른 구매금액 합계
product_price <- dcast(pay_data,
                       user_id~product_type, sum)
product_price %>% head()

dim(product_price)  # 303   6

names(product_price) <- c('user_id', '식료품(1)', '생필품(2)',
                          '의류(3)', '잡화(4)', 
                          '기타(5)')
product_price %>% head()

# 3) 이 파생변수를 특정 테이블에 추가(join)
library(dplyr)
# 형식) left_join(df1, df2, by='컬럼명')
                      # join하려는 df
user_pay_data <- left_join(user_data, product_price,
                           by='user_id')
user_pay_data %>% head()
dim(user_pay_data)  # 400  11
str(user_pay_data)

# 4) 사칙연산

user_pay_data$tot_price <- user_pay_data[,7] + user_pay_data[,8] + user_pay_data[,9] + user_pay_data[,10]+ user_pay_data[,11]
# user_pay_data$'식료품(1)'.... 도 가능
user_pay_data$tot_price %>% head()

dim(user_pay_data)  # 400  12
str(user_pay_data)

user_pay_data %>% head(10)


