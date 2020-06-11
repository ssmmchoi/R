# chap01_Basic

# 수업내용
# 1. 패키지와 세션
# 2. 패키지 사용법
# 3. 변수와 자료형
# 4. 기본함수와 작업공간

# 1. 패키지와 세션
dim(available.packages())
# [1] 15297(패키지 수)    17(패키지 정보) >> 15297 open source
# 하루지난 200227 오늘은 15305


15305-15297  #8, 하루사이 8개 늘었다
getOption("max.print")  # 1000
"max.print"


# session
sessionInfo() # 세션 정보 제공
# R 실행시부터 종료시까지 처리하는 모든 정보
# 리부팅하면 새로운 세션
# R 환경, OS 환경, 다국어(locale) 정보, 7 패키지

# 주요 단축키 :
# script 싱행 : ctrl +Enter
# save : ctrl + s
# 자동완성 : ctrl + space bar
# 여러줄 주석 : strl + shift+ c(토글)
# a <- 10
# b <- 20
# c <- a + b
# print(c)


# 2. 패키지 사용법 : package = function + dataset

# 1) 패키지 설치
install.packages('stringr')
install.packages
('https://cran.rstudio.com/bin/windows/
  contrib/3.2/패키지이름.zip', repos=NULL)
# reposit를 NULL값으로 입력하면, 기존 버전 패키지를 현재 위치에 설정
# 이렇게 직접입력해도 다운됨
# 인스톨은 꼭 ''
# 패키지(1) + 의존성 패키지(3)

# 패키지가 설치된 경로
.libPaths()
# [1] "C:/Users/user/Documents/R/win-library/3.6" - 확장 패키지
# [2] "C:/Program Files/R/R-3.6.2/library" - 기본 30개 패키지

# 3. in memory : 패키지를 upload(다운받은 stringr패키지)
library(stringr)
library(help='stringr') 
# library('stringr')도 가능
# str_    이라고 치면 {}안에 stringr이라는 텍스트가 찍히는
# 자동완성이 생긴다. 그러면 메모리에 업로드 완료된 것.

# memory 로딩된 패키지 확인
search()

str_extract('홍길동35이순신45', '[가-힣]{3}')
# [1] "홍길동"
str_extract_all('홍길동35이순신45', '[가-힣]{3}')
# [[1]] [1] "홍길동" "이순신"

# 4. 패키지 삭제
remove.packages('stringr') # 물리적 삭제

############################################
##############################
## 패키지 설치 Error 해결법
##############################

# 1. 최초 패키지 설치에서 발생한 문제
# - RStudio를 관리자모드로 실행
#  - 아이콘 오른쪽 마우스 > 자세히 > 관리자 권한으로 실행

# 2. 기존 패키지 설치에서 발생한 문제
# 1) remove.packages('패키지')
# 2) rebooting
# 3) install.packages('패키지')
# 즉, 삭제하고 다시 설치한다. 

############################################

# 3. 변수와 자료형

# 1) 변수 : 메모리의 이름

# 2) 변수 작성 규칙
# - 첫자는 영문, 두번째는 숫자, 특수문자(_, .)
#    (.은 다른 툴에서는 객체표현을 할 때 쓰지만 R에서는 X)
#    ex) score2020, score_2020, score.2020
# - 예약어, 함수명 사용 불가
# - 대소문자 구분
#    ex) NUM=100, num=10
# - 변수 선언시 type 선언 없음

# - score = 90(R) vs int score = 90(C언어)
# - 가장 최근값으로 변경됨(변수라는 이름에서 알 수 있듯이, 언제든지 변한다.)
# - R에서 모든 변수는 객체(object)

var1 <- 0  # var1 = 0 와 같음. 대입연산자는 <-를 써서 관계식과 혼동되지 않을 것을 권장함.
var1 <- 1  # var1이 가장 최근값인 1로 변경됨

print (var1)

var2 <- 10
var3 <- 20

var1; var2; var3
# [1] 1  -- 여기서 [1]은 색인! 즉 저장 위치.
# [1] 10 -- 첫 번째에 저장되어 있다는 뜻
# [1] 20

# 색인(index) : 저장 위치
var3 <- c(10, 20, 30, 40, 50) #하나의 변수에 5개 원소 저장
var3
#[1] 10 20 30 40 50 >> 10은 [1], 20은 [2] ...
var3[5] #50

# 대소문자
NUM = 100
num = 200
print(NUM == num) #관계식. sql의 =과 같음
# 이런 관계식은 항상 true나 false로 나타남
# [1] FALSE

# object.member
member.id = 'hong' # = "hong"
member.name = "홍길동"
member.age = 35

member.id; member.age
#[1] "hong"
#[1] 35

# scala(0 demension) vs vector(1 demension)
score <- 95
scores <- c(85,75,95,100)
score  #[1] 95 얘는 스칼라
scores  #[1]  85  75  95 100 얘는 벡터 85 > 75 > 95 > 100 이렇게 방향이 있음
# 즉 두 개 이상의 값이 일정한 방향을 가지고 있으면 벡터
# (참고) 행열구조는 2차원. 가로, 세로 방향 모두 가지고 있음

# 3) 자료형(data type) : 숫자형, 문자형, 논리형
int <- 100
float <- 125.23
string <- "대한민국"
bool <- TRUE  # T, FALSE는 F

# 자료형을 반환하는 함수
mode(int)  #[1] "numeric"
mode(float)  #[1] "numeric"
mode(string)  #[1] "character"
mode(bool)  #[1] "logical"

# is.xxxx 함수
is.numeric(int)  # [1] TRUE
is.character(string)  # [1] TRUE
is.logical(bool)  # [1] TRUE
is.numeric(string)  # [1] FALSE

datas <- c(84,85,62,NA,45)
datas  # 84 85 62 NA 45

is.na(datas)  #[1] FALSE FALSE FALSE  TRUE FALSE
# 결측치 -> TRUE

# 4) 자료 형변환 함수 : [PART-I. 1장 설치 및 기초 문법]p.20

# (1) 문자형 -> 숫자형 변환
x <- c(10,20,30)  # = vector
mode(x)  #[1] "numeric"
x  #[1] 10 20 30

x <- c(10,20,30,'40')  # 40을 싱글쿼트에 넣어 문자형으로 넣어버렸으니 자동으로 x 전체가 character 타입으로 바뀜
mode(x)  #[1] "character"
x*2  # error

x <-as.numeric(x)
x*2  #[1] 20 40 60 80
x**2  # 제곱. [1]  100  400  900 1600
# 연산이 되는 것으로 type이 숫자로 바뀌었다는 사실을 알 수 있음

plot(x)  # 그래프 생성

# (2) 요인형(factor)
# 범주(집단)형 변수(=catagory) 생성

gender <- c('남', '여', '남','여','여')  #범주형속성을 갖고있음
mode(gender)  #[1] "character"

# 문자형 -> 요인형 변환
fgender <- as.factor(gender)
mode(fgender) #[1] "numeric" : 안에 있는 2,3 이라는 숫자
plot(fgender)
class(fgender)  # factor

fgender
#[1] 남 여 남 여 여
#Levels: 남 여
# - 두 개의 집단으로 구성되어 있다는 뜻(범주)
# 레벨의 순서는 기본적으로 문자형의 오름차순으로 나타남

str(fgender)
# Factor w/ 2 levels "남","여": 1 2 1 2 2
# 저 1과 2는 더미변수!! 즉 avg따위 함수를 사용해도 의미x
# 더미변수 : 숫자에 의미가 없는 숫자형

# mode vs Class
mode(fgender)  #[1] "numeric" -> 자료형 확인
class(fgender)  #[1] "factor" -> 자료형 구조 확인

#숫자형 변수
x <- c(4,2,4,2)
mode(x)  #[1] "numeric"

#숫자형 -> 요인형
f <- as.factor(x)
f  #[1] 4 2 4 2 Levels: 2 4

#요인형 -> 숫자형
x2 <- as.numeric(f)
x2  #[1] 2 1 2 1
# 숫자형 > 요인형 > 숫자형으로 다시 바꾸면 원래의 숫자형
# 데이트가 그대로 출력되는 것이 아니라
# 요인형에서의 더미 변수가 나옴

# 해결 방법: 중간에 한번 문자형으로 변환을 한다.


#숫자형 변수
x <- c(4,2,4,2)
mode(x)  #[1] "numeric"

#숫자형 -> 요인형
f <- as.factor(x)
f  #[1] 4 2 4 2 Levels: 2 4

# 요인형 -> 문자형
c <- as.character(f)

# 문자형 -> 숫자형
x2 <- as.numeric(c)
x2

# 4. 기본함수와 작업공간

# 1) 기본 함수 : 바로 사용할 수 있는 함수
#                (앞선 패키지는 library함수를 통해 등록해야했다)
#                즉, 7개 패키지에 속한 함수
sessionInfo()
#attached base packages:
#[1] stats     graphics  grDevices utils    
#[5] datasets  methods   base 

library(stringr) # RStudio를 종료했다가 다시 켜서 이를 실행하니
#Error in library(stringr) : ‘stringr’이라고 불리는 패키지가 없습니다
#라고 에러가 남. stringr은 기본 패키지가 아니다

# 패키지 도움말
library(help='stats')

# 함수 도움말
help(sum)  # 웹문서 형식으로 오른쪽 하단에 제공
x <- c(10,20,30,NA)
sum(x)  #[1] NA
sum(x, na.rm = TRUE)  #[1] 60

sum(1:5)
sum(1, 2, 3, 4, 5)
sum(1:2, 3:5)
sum(1:5, NA)
sum(1:5, NA, na.rm = TRUE)

?mean  # help와 똑같음
       # mean(x, ...)
mean(10,20,30,NA, na.rm=TRUE)  #[1] 10
                              # 오류는 없지만 값이 잘못됨
mean(x, na.rm=TRUE)  #[1] 20

# 2) 기본 데이터셋
data()  #데이터셋 확인
data(Nile)

Nile
length(Nile)  #[1] 100
mode(Nile)  #[1] "numeric"
plot(Nile)  #연속성을 가짐
hist(Nile)  #histogram of Nile

# 3) 작업공간
getwd()  #[1] "C:/ITWILL/Work/2_Rwork"
         #=get working directory = 우측 하단 경로와 같음
setwd("C:/ITWILL/Work/2_Rwork/part-i")
getwd()  #경로가 위와 같이 변경됨
         #[1] "C:/ITWILL/Work/2_Rwork/part-i"
emp <-read.csv("emp.csv", header=T)
emp
















