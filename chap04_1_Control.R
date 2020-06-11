# chap04_1_Control

# <실습> 산술연산자 
num1 <- 100 # 피연산자1
num2 <- 20  # 피연산자2
result <- num1 + num2 # 덧셈
result # 120
result <- num1 - num2 # 뺄셈
result # 80
result <- num1 * num2 # 곱셈
result # 2000
result <- num1 / num2 # 나눗셈
result # 5

result <- num1 %% num2 # 나머지 계산
result # 0

result <- num1^2 # 제곱 계산(num1 ** 2)
result # 10000
result <- num1^num2 # 100의 20승
result # 1e+40 -> 1 * 10의 40승과 동일한 결과


# <실습> 관계연산자 
# (1) 동등비교 
boolean <- num1 == num2 # 두 변수의 값이 같은지 비교
boolean # FALSE
boolean <- num1 != num2 # 두 변수의 값이 다른지 비교
boolean # TRUE

# (2) 크기비교 
boolean <- num1 > num2 # num1값이 큰지 비교
boolean # TRUE
boolean <- num1 >= num2 # num1값이 크거나 같은지 비교 
boolean # TRUE
boolean <- num1 < num2 # num2 이 큰지 비교
boolean # FALSE
boolean <- num1 <= num2 # num2 이 크거나 같은지 비교
boolean # FALSE

# <실습> 논리연산자(and, or, not, xor)
logical <- num1 >= 50 & num2 <=10 # 두 관계식이 같은지 판단 
logical # FALSE
logical <- num1 >= 50 | num2 <=10 # 두 관계식 중 하나라도 같은지 판단
logical # TRUE

logical <- num1 >= 50 # 관계식 판단
logical # TRUE
logical <- !(num1 >= 50) # 괄호 안의 관계식 판단 결과에 대한 부정
logical # FALSE

x <- TRUE; y <- FALSE
xor(x,y) # [1] TRUE
x <- TRUE; y <- TRUE
xor(x,y) # FALSE


############################
## 1. 조건문
############################

# 1) if(조건식) - 조건식? 산술, 관계, 논리연산자

x<-10
y<-5
z<-x*y

# 형식1)
if(z>=20){
  cat('z는 20과 같거나 크다.\n','z=',z)
}else{
  cat('z는 20보다 작다.\n','z=',z)
}

# 형식2)
score <- 84 # c(55,65,75,85,95) <- not available likethis
score

grade<-""
if(score>=90){
  grade<-"A"
}else if(score>= 80 & score<90){
  grade<-"B"
}else if(score>=70 & score<80){
  grade<-"C"
}else if(score>=60 & score<70){
  grade<-"D"
}else {grade<-"F"}

grade

# ifelse(조건식, 참, 거짓)

score<-c(52,60,87,77,63,64)
result_score<-ifelse(score>=60, "합격", "불합격")
result_score
  

# 3) switch문
# 형식) switch(비교 구문, 실행구문1, 실행구문2, 실행구문3)

switch("name", age=105, name="홍길동", id='hong', pw='1234')
#"홍길동"
switch("pw", age=105, name="홍길동", id='hong', pw='1234')
# "1234"

switch("name", age=45, name='최수미', sex='F', id='815')


# 4) which문
name<-c('kim', 'lee', 'choi', 'park')
which(name == 'choi')  #[1] 3
print(name[3])  # [1] "choi"
name[3]  #[1] "choi"

which(name != 'choi')
print(name[c(1,2,4)])
cat('수미를 제외한 사람은 ', print(name[1]),", ", 
    print(name[2]),", ", print(name[4]), ' 입니다.')

# 데이터프레임에서 사용

no<- c(1:5)
name<- c('홍길동', '이순신', '강감찬', '유관순', '김유신')
score<- c(85,78,89,90,74)

exam <- data.frame('학번'=no, '이름'=name, '성적'=score)
exam
which(exam$'이름'=='유관순')  #4
exam[4]  # Error
exam[4,]
#  학번   이름 점수
#4    4 유관순   90
exam[4,2]
# [1] 유관순
# Levels: 강감찬 김유신 유관순 이순신 홍길동

library(MASS)
data("Boston")
str(Boston)  #'data.frame':	506 obs. of  14 variables:

name <- names(Boston)
name
?"Boston"
length(name)  #14

# x(독립변수), y(종속변수) 선택
# 보스톤 데이타의 앞 13가지 변수를 x, 14번째 중앙값을 y라고 하면
which(name == "medv")  #14
which(name == name[14])  #14
y_col <- which(name == 'medv')
y_col

Y <- Boston[y_col]  # Y 종속변수
Y
head(Y)

X <- Boston[-y_col]  # X 독립변수
X
head(X)

# 문) iris 데이터셋을 대상으로 x 변수(1~4th 칼럼)와 y(5th 칼럼) 할당하기
data(iris)
library(iris)
iris
?iris
str(iris)  # 'data.frame':	150 obs. of  5 variables:
head(iris)

name_iris <- names(iris)
name_iris  # "Sepal.Length" "Sepal.Width"  "Petal.Length" "Petal.Width"  "Species"  

which(name_iris == "Species")  #5
y <- which(name_iris == 'Species')
y  # 5

Y <- iris[y]
Y
head(Y)

X <- iris[-y]
X
head(X)

head(iris)
iris_name <- names(iris)
iris_name

which(iris_name=='Species')
y_iris <- which(iris_name=='Species')
y_iris

Y <- iris[y_iris]
Y
head(Y)

X <- iris[-y_iris]
head(X)

############################
## 2. 반복문
############################

# 1) for(변수 in 열거형객체){실행문}

num <- 1:10  # 열거형객체
num

for(i in num){
  if(num%%2==0){
    cat(i,'는 짝수\n')
  }else{next}
}#############################?????????????????????????

for(i in num) {
  cat('i=', i,'\n')
}
# i= 1 
# i= 2 
# i= 3 
# i= 4 
# i= 5 
# i= 6 
# i= 7 
# i= 8 
# i= 9 
# i= 10 

i <- c(1:10)
for(n in i){
  print(n*10)  # 여기엔 라인브레이크가 포함되어있음
}
# [1] 10
# [1] 20
# [1] 30
# [1] 40
# [1] 50
# [1] 60
# [1] 70
# [1] 80
# [1] 90
# [1] 100

for(n in i){
  print(n*10)
  print(n)
}
# [1] 10
# [1] 1
# [1] 20
# [1] 2
# [1] 30
# [1] 3
# [1] 40
# [1] 4
# [1] 50
# [1] 5
# [1] 60
# [1] 6
# [1] 70
# [1] 7
# [1] 80
# [1] 8
# [1] 90
# [1] 9
# [1] 100
# [1] 10

for(n in num){
  if(num%%2 != 0){cat('n=', n, '\n')}
  else{next}
}  ## 틀렸어요!!!!!!!!!!!!!!!!!!!!!!!

for(n in num){
  if(n %% 2 != 0){cat('n=',n,'\n')}
  else{next}
}
# n= 1 
# n= 3 
# n= 5 
# n= 7 
# n= 9 

# 문) 키보드로 5개의 정수를 입력받아서 짝수/홀수 구분하기
num <- scan()
num

for(n in num){
  if(n%%2 == 0){cat(n,'은(는) 짝수','\n')}
  else{cat(n,'은(는) 홀수','\n')}
}  ##?????????????????????????????????????

num<-1:100
num

# 문2) 1~100까지 홀수의 합과 짝수의 합 출력하기
even <-0 # 짝수합
odd <-0  #홀수합

for(i in num){
  if(i%%2==0){print(i)}
  else{next}
}


# 답?

cnt=0
for(i in num){
  cnt=cnt+1
  if(i%%2 ==0){even = even+i}  # 짝수 누적
  else{odd=odd+i}  # 홀수 누적
}

cnt

even  # [1] 2550
odd  # [1] 2500

cat('카운터 변수=', cnt)  ## ??????????????????????????
cat('짝수의 합 =', even, '홀수의 합 =', odd)

kospi <- read.csv(file.choose())  # sam_kospi
str(kospi)

kospi$diff <- kospi$High - kospi$ Low
str(kospi)
kospi$diff

row <- nrow(kospi)  # diff평균이상 '평균이상', 아니면'평균미만'
row

diff_result = ""  # 변수초기화

for(i in 1:row){  #247회 반복
  if(kospi$diff[i] >= mean(kospi$diff)){
    diff_result[i] = '평균이상'
  }else{
    diff_result[i]='평균미만'
  }
}   ## ??????????????????????????????????

diff_result  ##?? 평균이상 only??????????

table(diff_result)


# 이중 for문
# for(변수 in 열거형){     # 여기서의 변수i와
#   for(변수in 열거형){    # 여기서의 변수j는 서로 다르다
#   실행문
#   }
# }

#구구단
for(i in 2:9){                        #i는단수
  cat('***', i, '단***\n\n')
  for(j in 1:9){                      #j는 곱수
    cat(i, '*', j, '=', (i*j), '\n')
  }   
    cat('\n')                         #inner for
}                                     #outer for

### 참조) cat문은 뒤에 파일 경로를 지정하여 파일로 save가능

for(i in 2:9){                        #i는단수
  cat('***', i, '단***\n\n',
      file="C:/ITWILL/Work/2_Rwork/output/gugu.txt",
      append = T)
  for(j in 1:9){                      #j는 곱수
    cat(i, '*', j, '=', (i*j), '\n',
        file="C:/ITWILL/Work/2_Rwork/output/gugu.txt",
        append = T)
  }   
  cat('\n',                          #inner for
      file="C:/ITWILL/Work/2_Rwork/output/gugu.txt",
      append = T)                        
}   

setwd("C:/ITWILL/Work/2_Rwork/output")
read.table("gugu.txt")   ## 실패...

gugu.txt <- readLines("C:/ITWILL/Work/2_Rwork/output/gugu.txt")
gugu.txt


# 2) while(조건식){실행문}
i = 0   # 초기화
while(i<5){
  cat("i = ", i, "\n")
  i = i + 1        # 카운터
}
# i =  0 
# i =  1 
# i =  2 
# i =  3 
# i =  4 


x <-c(2,5,8,6,9)
x# 각 변량에 제곱 취하기
n <-length(x) 
n


i <- 0         #인덱스 효과
while(i<n){
  i <- i+1
  x[i] <- x[i]^2
}

x  # 4 25 64 36 81   ?????????????? 왜 9까지 나오지????

i <- 0         #인덱스 효과
y<-0
while(i<n){
  i <- i+1
  y[i] <- x[i]^2
}

y  # 16  625 4096 1296 6561







