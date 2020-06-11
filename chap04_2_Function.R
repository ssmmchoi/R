# chap04_2_Function

# 1. 사용자 정의함수
# 형식) 함수명 <- function[(인수)]{      # 인수는 외부에서 값을 받는 역할
#                   실행문
#                   실행문
#                  [{return 값}]
#                  }                     # [] 속은 생랴 가능

# 1) 매개변수없는 함수
f1 <- function(){
  cat('f1 함수')
}                         ## 함수 정의함. 호출해야 쓸 수 있음

f1
# function(){
#   cat('f1 함수')
# }
f1()  #f1 함수

# 2) 매개변수 있는 함수
f2 <- function(x){
  x2 <- x^2
  cat('x2 =', x2)
}

f2(10)   # x2 = 100  -> 실인수
f2(c(1,2,3,4,5,5,6,7,8,9,10))   # x2 = 1 4 9 16 25 25 36 49 64 81 100

# 3) 리턴이 있는 함수
f3 <- function(x, y){
  add <- x+y
  return(add)              ## 반환
}

# 함수 호출 -> 반환값
f3(10,5)  # [1] 15   >> 실인수
add_re <- f3(10, 5)
add_re  [1] 15

num <- 1:10
tot_func <- function(x){
  tot <- sum(x)
  return(tot)
}

tot_re <- tot_func(num)
tot_re  # 55

avg <- tot_re / length(num)
avg  # 5.5

# 문) calc 함수를 정의하기
# 100 + 20 = 120
# 100 - 20 = 80
# 100 * 20 = 200
# 100 / 20 = 5

x=0
y=0
calc <- function(x,y){
  cat('x + y = ', (x+y), '\n')
  cat('x - y = ', (x-y), '\n')
  cat('x * y = ', x*y, '\n')
  cat('x / y = ', x/y, '\n')
}

calc(100,20)

# or

calc<-function(x,y){
  add <- x + y
  sub <- x -y
  mul <- x*y
  div <- x/y
  cat(x, '+', y, '=', add, '\n')
  cat(x, '-', y, '=', sub, '\n')
  cat(x, '*', y, '=', mul, '\n')
  cat(x, '/', y, '=', div, '\n')
  calc_df <- data.frame(add,sub, mul, div)
  return(calc_df)
  ## 오류: return(add, sub, mul,div)  리턴 함수는 하나의 값만 반환할 수 있다.
}

calc(100,20)
df <- calc(100,20)
df

# 구구단의 단을 인수로 받아서 구구단 출력하기
gugu <- function(dan){
  cat('***', dan, '단***\n\n')
  for(i in 1:9){
    cat(dan, '*', i, '=', dan*i, '\n')
  }
}

gugu(2);gugu(5)
# *** 2 단***

# 2 * 1 = 2 
# 2 * 2 = 4 
# 2 * 3 = 6 
# 2 * 4 = 8 
# 2 * 5 = 10 
# 2 * 6 = 12 
# 2 * 7 = 14 
# 2 * 8 = 16 
# 2 * 9 = 18 


s <- seq(1,20,2)
s
stats <- function(fname, data){
  switch(fname,
         SUM = sum(data),
         AVG = mean(data),
         VAR = var(data),
         SD = sd(data))
}

stats(SUM, s) ##오류
stats("SUM", s)  # 100
stats("AVG", s)  # 10
stats("VAR", s)  # [1] 36.66667
stats("SD", s)  # 6.055301
round(stats("SD", s))  # 6

# 결측치(NA) 처리 함수
# 결측치가 있는 벡터를 함수에 넣어 평균을 구해보자.
na <- function(x){
  # 1. NA제거해서 처리
  x1 <- na.omit(x)
  cat('x1 = ', x1, '\n')
  cat('mean(x1) = ', mean(x1), '\n')
  
  # 2. NA -> 평균으로 대체
  x2 <- ifelse(is.na(x), mean(x, na.rm=T), x)
  cat('x2 = ', x2, '\n')
  cat('mean(x2) = ', mean(x2), '\n')
  
  # 3. NA -> 0
  x3 <- ifelse(is.na(x), 0, x)
  cat('x3 = ', x3, '\n')
  cat('mean(x3) = ', mean(x3), '\n')
}

x <- c(10,5,NA,4,2,6,3, NA, 7,5,8,10)  ## 얘가 function에 들어가면 실인수
x
length(x)  #12
mean(x, na.rm=T)  #6

na(x)
# x1 =  10 5 4 2 6 3 7 5 8 10 
# mean(x1) =  6 
# x2 =  10 5 6 4 2 6 3 6 7 5 8 10 
# mean(x2) =  6 
# x3 =  10 5 0 4 2 6 3 0 7 5 8 10 
# mean(x3) =  5 






###################################
### 몬테카를로 시뮬레이션 
###################################
# 현실적으로 불가능한 문제의 해답을 얻기 위해서 난수의  
# 확률분포를 이용하여 모의시험으로 근사적 해를 구하는 기법

# 동전 앞/뒤 난수 확률분포 함수 
coin <- function(n){
  r <- runif(n, min=0, max=1)
  #print(r) # n번 시행 
  
  result <- numeric()
  for (i in 1:n){
    if (r[i] <= 0.5)
      result[i] <- 0 # 앞면 
    else 
      result[i] <- 1 # 뒷면
  }
  return(result)
}


# 몬테카를로 시뮬레이션 
montaCoin <- function(n){
  cnt <- 0
  for(i in 1:n){
    cnt <- cnt + coin(1) # 동전 함수 호출 
  }
  result <- cnt / n
  return(result)
}

montaCoin(5)  #0.6
montaCoin(1000)  #0.496
montaCoin(10000)  #0.499
# 중심극한정리라고 함. 중심으로 몰림. 정규분포와 관련 有

# 2. R의 주요 내장함수
# 1) 기술통계함수 

vec <- 1:10          
min(vec)                   # 최소값
max(vec)                   # 최대값
range(vec)                  # 범위
mean(vec)                   # 평균
median(vec)                # 중위수
sum(vec)                   # 합계
prod(vec)                  # 데이터의 곱
1*2*3*4*5*6*7*8*9*10
summary(vec)               # 요약통계량 
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 1.00    3.25    5.50    5.50    7.75   10.00 

rnorm(10) # 평균0, 표준편차1(근사)인 10개의 난수 탄생
sd(rnorm(10))      # 표준편차 구하기
n<-rnorm(1000)
sd(n)
mean(n)
factorial(5) # 팩토리얼=120
sqrt(49) # 루트

install.packages("RSADBE")
library(RSADBE)
?RSADBE
library(help="RSADBE")
data(Bug_Metrics_Software)
str(Bug_Metrics_Software)  # 'xtabs' num [1:5, 1:5, 1:2]
                                       #   행  열    면
Bug_Metrics_Software
Bug_Metrics_Software[,,1]  #before만 보기

# 행별, 열별 합계 구하기
# 행 단위 합계
rowSums(Bug_Metrics_Software[,,1])
# JDT     PDE Equinox  Lucene   Mylyn 
# 23750   10552    1959    3428   31014

# 열 단위 합계, 버그별
colSums(Bug_Metrics_Software[,,1])
# Bugs    NT.Bugs      Major   Critical H.Priority 
# 34024      24223       2245        838       9373

rowSums(Bug_Metrics_Software[,,2])
colSums(Bug_Metrics_Software[,,2])

bug_yg_removed_row <- rowSums(Bug_Metrics_Software[,,1]) - rowSums(Bug_Metrics_Software[,,2])
bug_yg_removed_row

bug_yg_removed_col <- colSums(Bug_Metrics_Software[,,1]) - colSums(Bug_Metrics_Software[,,2])
bug_yg_removed_col

# 3면에 diff값 뜨기

str(Bug_Metrics_Software)
bug <- Bug_Metrics_Software

bug_new <- array(bug, dim = c(5,5,3))
?array
dim(bug_new)
bug_new

bug_new[,,3] <- Bug_Metrics_Software[,,1] - Bug_Metrics_Software[,,2]
bug_new  ## 3번째 추가된 면에 diff 값 입력


bug <- Bug_Metrics_Software
bug_new <- array(bug, c(5,5,3))
bug_new

bug_new[,,3] <- Bug_Metrics_Software[,,1]-Bug_Metrics_Software[,,2]
bug_new

setwd("C:/ITWILL/Work/2_Rwork/output")
write.table(bug_new, "Bug_Metrics_Software_wthDIFF.txt", row.names=F) ## 이상함
write.csv(bug_new, "Bug_Metrics_Software_wthDIFF.csv")   ## 이상함
writeLines(bug_new, "Bug_Metrics_Software_wthDIFF.txt")  ## 안됨

















# 2) 반올림 관련 함수 
x <- c(1.5, 2.5, -1.3, 2.5)
round(mean(x)) # 1.3 -> 1
ceiling(mean(x)) # x보다 큰 정수 
floor(mean(x)) # 1보다 작은 정수 

# 3) 난수 생성과 확률분포

# (1) 정규분포를 따르는 난수 - 연속확률분포(실수형)
# 형식) rnorm(n, mean=0, sd=1)  >> mean,sd기본셋

n <- 1000
r <- rnorm(n, mean=0, sd=1)

mean(r)
sd(r)
hist(r)  # 좌우대칭성을 가짐

# (2) 균등분포를 따르는 난수 - 연속확률분포(실수형형)
# 형식) runif(n, min=0, max=1)
r2<-runif(n, min=10, max=100)
hist(r2)

# (3) 이항분포를 따르는 난수 - 이산확률분포(정수형)
# 형식) rbinom(n, size, prob)
n<-10
r3 <- rbinom(n, 1, 0.5)  # 1이 나타난 화률이 0.5인 10개 난수
r3
hist(r3)

set.seed(123)
n<-10
r3 <- rbinom(n, 1, 0.5)  # 1이 나타난 화률이 0.5인 10개 난수
r3
## seed값을 지정하면, 동일한 seed 값에 대해 실행된 rbinom
## 함수는 동일한 난수를 생성한다.

r3 <- rbinom(n, 1, 0.25)
r3

# (4) sample 함수 - 데이터 샘플링시 사용(base소속)
# 형식) sample(x, size, replace=F, prob=NULL)
#           모집단 샘플수 비복원(=중복x)
sample(10:20, 5)
sample(c(10:20, 50:100), 10)

# 홀드아웃방식
# train(70%) / test(30%) 데이터셋
#   훈련        검증

dim(iris) # [1] 150   5

idx<-sample(nrow(iris), nrow(iris)*0.7)
idx
range(idx)  # 최소,최댓값-2 149
idx  # 행번호
length(idx)  #105

train <- iris[idx,]  # 학습용
test <- iris[-idx,]  # 모델이 제대로 작동하는지, 검증용
# 이런걸 홀드아웃 방식이라고 함.

dim(train)  # 105   5  ?????????????????????????????? 5?
dim(test)  # 45    5

# 4) 행렬연산 내장함수
x <- matrix(1:9, nrow=3, byrow=T)
x
y <- matrix(1:3, nrow=3)
y
dim(x)
dim(y)

z <-x %*% y
#      [,1]
# [1,]   14     x의 행, y의 열을 곱해서 각각을 모두 더한 것
# [2,]   32     즉 ㅡ x |
# [3,]   50

# 행렬곱의 전제조건
# 1. x,y 모두 행렬
# 2. x(열) = y(행) 일치 : 수일치














