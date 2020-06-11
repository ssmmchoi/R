# chap02_datastructure

#자료구조의 유형(5)

# 1. vector 자료구조
# - 동일한 자료형을 갖는 일차원 배열구조
# - 생성함수 : c(), seq() 시퀀서, rep()리플리케이션

# (1) c()
x <- c(1,3,5,7)
x
y <- c(3,5)
length(x)
length(y)

# 집합관련 함수(ex. 합집합, 교집함, 여집합)
union(x,y)  #합집함 x+y
setdiff(x,y)  #차집합, x-y, [1] 1 7
setdiff(y,x)
intersect(x,y)  #교집합, [1] 3 5

# 벡터 변수 유형
num <- 1:5  # = c(1,2,3,4,5) c(1,2...5)
num

num<-c(-10:5)
num

num<-c(1,2,3,"4")
num  # 문자로 통일되어 있음.
     # 메트릭스는 동일 문자열만 입력 가능

# 각각의 벡터 원소에이름 지정
names<- c('hong','lee','kang')
names  # "hong" "lee"  "kang"

age<-c(35,45,55)
age

names(age) <- names
age  # 표 느낌으로 이름이 붙어 나옴
names  # 변화 없음
mode(age)
mean(age)  #45
str(age)
# Named num [1:3] 35 45 55
# - attr(*, "names")= chr [1:3] "hong" "lee" "kang"

# 2) seq()
help(seq)
num <- seq(1, 10, by=2)
num <- seq(1,10,2)
num <- seq(from =1, to=10, by=2)
print(num)

num2 <- seq(10,1,-2)
num2

# 3) rep() 반복
?rep  #rep(x, ...)  /  rep(x, times = 1, length.out = NA, each = 1)
rep(1:3, times=3)  #1 2 3 1 2 3 1 2 3
rep(1:3, each=3)  #1 1 1 2 2 2 3 3 3

# 색인(index) :저장 위치
# 형식 : object[n]

a <-1:50
a  # 전체 원소
a[10]  #10
a[10:20]  #10 11 12 13 14 15 16 17 18 19 20
a[10:20, 30:35]  #Error in a[10:20, 30:35] : incorrect number of dimensions
                 # 1차원에서는 콤마를 넣어 [행,열]형태를 사용할 수 없음
a[c(10:20, 30:35)]  # 따라서 중간에 콤마를 쓰고자 할 때는 이렇게 c함수를 사용

b <- seq(1, 100, 13)
b
length(b)
b[7]
b[b>=13 & b<=50]


# 함수 이용
length(a)  # 원소 개수. 50개
a[10:length(a)-5]  # 5~45
a[10:(length(a)-5)]
a[seq(2, length(a), by=2)]  # a의 2,4,6...50번째

# 특정 원소 제외(-)
a[-c(20:30)]  # 20, 30번째 위치 원소 제외하고 검색
a[-c(15,25, 30:35)]

# boolean(조건식)
a[a>=10 & a<=30]  #10~30 식에 들어간 수는 인덱스넘버가 아니라 원소 자체의 크기
a[a>10 | a>30]  #or
a[a>10 | a<30]
# !는 not
a[!(a>=10)]  # 1 2 3 4 5 6 7 8 9


# 2. Matrix 자료구조
# - 동일한 자료형을 갖는 2차원 배열 구조
# - 생성 함수 : matrix(), rbind(), cbind()
#                         row(행) column(열)
# - 처리 함수 : apply() : 통계

# (1) matrix
m1 <- matrix(data=c(1:5)) 
m1  ## 행(n), 열(1)
dim(m1)  #5 1  5행, 1열,(5x) 2차원이라는 뜻
mode(m1)  #numeric 자료형
class(m1)  #matrix 자료 구조
 
?matrix
m2 <- matrix(data=c(1:9), nrow=3, ncol=3, byrow=FALSE)
m2
dim(m2)  # 3 3

# (2) rbind
x <-1:5
y<-6:10
x
y

m3<-rbind(x,y)
m3

z<-matrix(c(x,y), nrow=5, ncol=2, byrow=TRUE)
z

# (3) cbind
m4<-cbind(x,y)
m4
dim(m4)  # 5x2

#ADSP에서 나온 시험 문제 - 다음 보기 중 틀린 것?
xy <- rbind(x,y)
xy
# 1. xy[1,]는 x와 같다.
# 2. xy[,1]은 y와 같다.
# 3. dim(xy)는 2x5이다.
# 4. class(xy)는 matrix이다.

# 답 :1번, 2번 - 틀림 ㅎ
# 1번 해설 - xy의 첫 번째 행은 x와 같다.
# 2번 해설 - xy의 첫 번째 열은 y와 같다.
# 답 : 2

# 색인(index) : matrix에서 쓰는
# 형식 : object[row,column]
m5 <- matrix(data=c(1:9), nrow=3, ncol=3)
m5

# 특정 행/열 색인
m5[1,]
m5[,1]
m5[2:3, 1:2]
m5[1,1:2]

# 속성
m5[-2,]  # 2행만 제외하고 나타남
m5[,-3]  # 3열만 제외하고 나타남
m5[,-c(1,3)]  # 2개 이상 제외

# 각각의 열과 행은 통계에서는 변수, 변인이라고 부른다.
# 따라서 각 열과 행에 이름을 지정할 수 있음
colnames(m5) <- c("one", 'two', 'three')
#조회
m5[,'one']
m5[,'one':'two'] ##error
m5[,1:2]
rownames(m5) <- c('four', 'five', 'six')
m5

# broadcast 연산
# - 작은 차원->큰 차원 늘어나서 연산

x<-matrix(1:12, nrow=4, ncol=3, byrow=T)
dim(x)  # 4x3
x

# 1) scala(0dim) vs matrix(2dim)
0.5*x
## if, 같은 차원의 (예,메트릭스)구조끼리 연산시키면
## 메트릭스의 경우, matrix1[1,1]xmatrix2[1,1] ...

# 2) vactor(1) vs matrix
y <- 10:12
y
x+y

# 3) 동일한 모양(shape)
x + x
x - x

# 4) 전치행렬 : 행->열, 열->행
t(x)

# 처리 함수 : apply()
?apply   #apply(X, MARGIN(1(행)혹은 2(열)), FUN(function), ...)
x
apply(x, 1, sum)  #6 15 24 33
apply(x, 2, mean)  #5.5 6.5 7.5
apply(x, 1, var)  # 행 단위 분산 1 1 1 1
apply(x, 2, var)
apply(x, 1, sd)  # 행 단위 표준편차 1 1 1 1

# 3. array 자료구조
# - 동일한 자료형을 갖는 3차원 배열구조
# - 생성 함수 : array()
?array

# 1 dim -> 3 dim
arr<-array(data=c(1:12), dim=c(3,2,2))
arr  # , , 1 은 1면이라는 뜻
dim(arr)  # 3행 2열 2면

data()
data('iris3')
##iris3는
##Edgar Anderson's Iris Data
##각 면은 각 아이리스 꽃의 종류
##각 컬럼은 각 꽃 종의 속성(예 : 꽃받침의 너비..)
##각 행은 한 꽃 종에 속한 각각의 꽃 개체
iris3
dim(iris3)  # 50 4 3
50*4*3

# 색인(index)
# arr[r,c,s] >> 각각 생략하면 전체가 나옴
arr[,,1]  #1면
arr[,,2]  #2면

iris3[,,1]  # 꽃의 종1
iris3[,,2]  # 꽃의 종2
iris3[,,3]  # 꽃의 종3

iris3[10:20, 1:2, 1]

# 4. data.frame
# - '열 단위 서로다른 자료형'을 갖는 2차원 배열구조
# - 생성함수 :data.frame()
# - 처리 함수 : appy() : 행렬처리함수임. 그래서 벡터도되고

# 1) vector이용
no <- 1:3
name <- c('홍길동','이순신','유관순')
pay <- c(250,350,200)

?data.frame
emp <- data.frame(NO=no, NAME=name, PAY=pay)
emp
dim(emp)  #3*3
mode(emp)  #"list" 2개 이상의 자료형이 포함된 경우
class(emp)  #"data.frame"

# 자료 참조 : 칼럼 참조 or index 참조
# 형식 : object$칼럼
pay <- emp$PAY
pay  # 250 350 200
mean(pay)
sd(pay)
emp[,3]  # auch 250 350 200

mean(pay)  # 266.6667 pay칼럼의 평균
mean(emp[,3])  # auch 266.6667

#또 다른 형식 : object[row,column]
emp_row <- emp[c(1,3),]  # or emp[-2,]
emp_row

# 2) csv, text file, db table
setwd("C:/ITWILL/Work/2_Rwork/Part-I")
getwd()

emp_txt <- read.table("emp.txt")
emp_txt <- read.table('emp.txt', header = T, sep = '') # 뭐니?
emp_txt
class(emp_txt)  # "data.frame"
mode(emp_txt)  # "list"

emp_csv <- read.csv('emp.csv')
emp_csv
class(emp_csv)  # "data.frame"
mode(emp_csv)  # "list"

# [실습]
sid <- 1:3  # 학번(이산형 변수.)
score <- c(90,80,83)  # 여긴 소숫점이 포함되어 있는 수가 올 수 있음. 연속형 변수
gender <- c('M', 'F', 'M')  # 범주형. 카테고리형성가능

student <- data.frame('학번'=sid, '점수'=score, '성별'=gender)
student

# 자료구조 보기
str(student)
#'data.frame':	3 obs. of  3 variables:
# $ 학번: int  1 2 3
# $ 점수: num  95 95 95
# $ 성별: Factor w/ 2 levels "F","M": 2 1 2

# facor를 만들고 싶지 않은 경우
student2 <- data.frame('학번'=sid, '점수'=score, '성별'=gender,
                       stringsAsFactors = F)
student2
str(student2)


# 특정 칼럼 -> vector
score <- student$점수
mean(score)
sum(score)
var(score)

# 표준편차
sqrt(var(score))
sd(score)


# 산포도 : 분산, 표준편차

# 모집단에 대한 분산, 표준편차
# 분산 = sum((x-산술평균)^2) / n
# 표준편차 = sqrt(분산)

# 표본에 대한 분산, 표준편차 <- R 함수
# 분산 = sum((x-산술평균)^2) / n-1
# 표준편차 = sqrt(분산)

score
avg <- mean(score)
avg
diff <- (score - avg)^2
var <- sum(diff) / (length(score) - 1)
var

sd <- sqrt(var)
sd

# 5. list 자료구조
# - key와 value 한쌍으로 자료가 저장된다.
# - key는 중복 불가, value 중복 가능
# - key를 통해서 값(value)을 참조한다.
# - 다양한 자료형, 자료형구조를 갖는 자료구조이다.

# 1) key생략 : [key=value, key2=value]
#  예 :벡터에서는 ['홍길동', '이순신'
#      리스트는 [key='홍길동', key2='이순신']
?list

lst <- list('lee', '이순신', 35, 'hong', '홍길동',30)  #기본키생성
lst
# [[1]]  ->  기본키(defualt key)
# [1]    -> "lee" 값(value)
# 한 번 쓴 키는 중복 안됨

# [[2]]  ->  기본키(default key)
# [1] "이순신" 값2(value)

lst[1]
lst[6]

# key를 통해 value 참조
lst[[5]]  #[1] "홍길동"

# 2) key=value
lst2 <- list(first=1:5, seond=6:10)
lst2
##$first   이렇게 직접 이름을 지정한 키는 달러표시와 함께 나옴
##[1] 1 2 3 4 5
##$seond
##[1]  6  7  8  9 10

# key를 통해 value 값 참조
lst2$first
lst2$first[3]  #3 벨류의 특정 원소에 접근할 때
lst2$seond
lst2$seond[2:4]

# data.frame($) vs list($)
# data.frame$컬럼명
# list$k키명

# 3) 다양한 자료형(숫자형, 문자령, 논리형)

lst3 <- list(name=c('홍길동','유관순'),
             age=c(35,25),
             gender=c('M','F'))
lst3
lst3$age  # 35 25
mean(lst3$age)  # 30

# 4) 다양한 자료구조(vector, matrix, array)
lst4 <- list(one=c('one','two','three'),
             two=matrix(1:9, nrow=3),
             three=array(1:12, c(2,3,2)))
lst4
# $one : 1차원
# $two : 2차원
# $three : 3차원

# 5) list 형변환
multi_list <- list(r1=list(1,2,3),
                   r2=list(10,20,30),
                   r3=list(100,200,300))   ## 중첩 리스트

multi_list
# 위 중첩 리스트를 각각을 하나의 열로, 메트릭스 형태로 형변환하겠다
# do.call(func. object)
mat <- do.call(rbind, multi_list)
mat

# 6) list 처리 함수
x <- list(1:10)  # key 생략 -> [[n]]
x

# list -> vector
v <- unlist(x)
v  # [1]  1  2  3  4  5  6  7  8  9 10 키가 제거됨

a <- list(1:5)
b <- list(6:10)
a;b

# list 객체에 함수 적용 
# 형태 : lapply(x, Func)
lapply(c(a,b), max)  # list로 반환
# [[1]]
# [1] 5
#
# [[2]]
# [1] 10

sapply(c(a,b), max)  # vector로 반환
# [1]  5 10

# 6. 서브셋(subset)
# - 특정 행 또는 열 선택하여 새로운 dataset 생성

x<- 1:5
y<- 6:10
z<- letters[1:5]
z

df <- data.frame(x,y,z)
df
?data.frame

help(subset)
# subset(x, subset, select, drop = FALSE,...)

# 1) 조건식으로 subset 생성 : 행 기준
df2<-subset(df, x>=2)
df2

# 2) select로 subset 생성  : 열 기준
df3 <- subset(df, select = c(x,z))
df3

# 3) 조건식&select
df4 <- subset(df, x>=2 & x<=4, select=c(x,z))
df4

class(df2)
class(df3)
class(df4)

df

# 특정 컬럼의 특정 값으로 subset 생성하기
df5<-subset(df, z %in% c('a','c','e'))  #%in% 연산자
df5


# [실습] iris dataset 이용 subset생성
iris
mode(iris)
str(iris)
#'data.frame':	150 obs.(=관측치, 즉 행) of  5 variables:
#  $ Sepal.Length: num(=숫자형)  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#$ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#$ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#$ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#$ Species     : Factor(=요인형) w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

## 주석처리 ctrl + shift + c

?subset
iris_df = subset(iris, Sepal.Length>=mean(Sepal.Length),
                 select=c(Sepal.Length, Petal.Length,Species))
str(iris_df)
# 'data.frame':	70 obs. of  3 variables:
#   $ Sepal.Length: num  7 6.4 6.9 6.5 6.3 6.6 5.9 6 6.1 6.7 ...
# $ Petal.Length: num  4.7 4.5 4.9 4.6 4.7 4.6 4.2 4 4.7 4.4 ...
# $ Species     : Factor w/ 3 leve


# 7. 문자열 처리와 정규 표현식
install.packages('stringr')
library(stringr)

string = "hong35lee45kang55유관순25이사도시45"
string
#[1] "hong35lee45kang55유관순25"


# 메타문자 : 문자열을 추출할 수 있는 패턴을 지정하는 특수 기호

# 1. str_extract_all

# 1) 반복관련 메타문자 : [x]=x 1개, {n}=n개연속
str_extract_all(string, "[a-z]{3}") #영소문자 3개연속인 것을 추출
# [[1]] 이건 키 (자료 구조가 list라는 뜻)
# [1] "hon" "lee" "kan" 이건 키에 저장된 value 값

str_extract_all(string, "[a-z]{3,}")  #브레이스에 콤마를 찍으면 3개 이상.
# [[1]]
# [1] "hong" "lee"  "kang"

str_extract_all(string, "[가-힣]{3,}")
# [[1]]
# [1] "유관순"   "이사도시"

name <- str_extract_all(string, "[가-힣]{3,}")
unlist(name) # 리스트를 벡터로 [1] "유관순"   "이사도시"

name <- str_extract_all(string, "[가-힣]{3,5}")
name
unlist(name)

# 숫자(나이) 추출
ages <- str_extract_all(string, "[0-9]{2,}")
unlist(ages)  #[1] "35" "45" "55" "25" "45"
#이것을 우선 벡터로 변경
ages_vec <- unlist(ages)
ages_vec
#숫자형으로 변환
num_ages <- as.numeric(ages_vec)
num_ages

cat('나이 평균=', mean(num_ages))  #나이 평균= 41
## cat는 출력에 관련된 함수.

# 2) 단어와 숫자 관련 메타문자
# 단어 : \\w
# 숫자 : \\d

jumin <- "123456-4234567"
str_extract_all(jumin, "[0-9]{6}-[1-4][0-9]{6}")
# [[1]]
# [1] "123456-1234567"
str_extract_all(jumin, "[0-9]{6}-[1-4]\\d{6}")  #둘이 같음
# [[1]]
# [1] "123456-1234567"
# 패턴이 일치하지 않는 경우는(예: 주민번호 성별 자리가 5) [[1]]
# character(0)
str_extract_all(jumin, "\\d{6}-[1-4]\\d{6}")

email <- "kp1234@naver.com"
#이메일 양식이 제대로 됐는지 패턴을 사용해서 알아보자.
str_extract_all(email,"[a-z]{3,}@[a-z]{3,}.com$")  #[[1]] character(0)

# \\w : 영, 숫, 한 -> 특수문자 제외
str_extract_all(email, "[a-z]\\w{3,}@[a-z]{3,}.com$")  # 첫문자 알파벳 이후 어떤 문자 형태이든지 3개 이상 오면 정상판정
# [[1]]
# [1] "kp1234@naver.com"

email2 <- "kp1$234@naver.com"
str_extract_all(email2, "[a-z]\\w{3,}@[a-z]{3,}.[a-z]{2,}")
# [[1]]
# character(0)  특수문자 때문.

# 3) 접두어(^)/ 접미어($) 메타문자
email3 <- "1kp1234@naver.com"
str_extract_all(email3,"[a-z]{3,}@[a-z]{3,}.[a-z]{2,}")  #nope.
str_extract_all(email3,"[a-z]\\w{3,}@[a-z]{3,}.[a-z]{2,}")
# [[1]]
# [1] "kp1234@naver.com" 첫 글자인 1 숫자를 감지하지 않고 넘어감
# "문장의 시작이 영문자냐?" 하는 조건을 추가해줘야 틀린 이메일 양식이라고 감지함
str_extract_all(email3, "^[a-z]\\w{3,}@[a-z]{3,}.[a-z]{2,}")  #character(0)
# 앞의 ^[a-z]가 접두어 역할

str_extract_all(email3, "^[a-z]\\w{3,}@[a-z]{3,}.com$")
# 맨 뒤가 com으로 끝나는지.

str_extract_all(email, "^[a-z]\\w{3,}@[a-z]{3,}.com$")

# 4) 특정 문자 제외 메타문자
string
# [1] "hong35lee45kang55유관순25이사도시45"

#숫자 제외 나머지 문자 반환 : 괄호 안에 ^
str_extract_all(string, "[^0-9]{3,}")
# [[1]]
# [1] "hong"     "lee"      "kang"     "유관순"   "이사도시"

result <- str_extract_all(string, "[^0-9]{3,}")
result  # [[1]] : 기본키

# 불용어 제거 : 여기선  숫자, 영문자, 특수문자
str_extract_all(result[[1]], "[가-힣]{3,}")
name <-str_extract_all(result[[1]], "[가-힣]{3,}")
name

# 2. string_length : 문자열 길이 반환
length(string)  #[1] 1
str_length(string)  #[1] 28

# 3. str_locate / str_locate_all : 문자열의 위치 반환
str_locate(string, 'g')  # 리스트 형식
#        start end
# [1,]     4   4
str_locate_all(string, 'g')
# [[1]]
#        start end
# [1,]     4   4
# [2,]    15  15

# 4. str_replace / str_replace_all : 특정 문자열을 다른 문자열로 교체
str_replace(string, "[0-9]{2}", "")  #숫자제거됨
# [1] "honglee45kang55유관순25이사도시45"
str_replace_all(string,"[0-9]{2}", "")  #[1] "hongleekang유관순이사도시"

# 5. str_sub : 부분 문자열
str_sub(string, start=3, end=5)  #[1] "ng3"

# 6. str_split : 문자열 분리(토큰)
string2 <- "홍길동, 이순신, 강감찬, 유관순"
str_split(string2, ",")
# [[1]]
# [1] "홍길동"  " 이순신" " 강감찬" " 유관순"
result <- str_split(string2, ",")  # 콤마아닌 공백으로 분리될 경우 쿼트 안에 공백 넣어줌
result

name <- unlist(result)
name  #[1] "홍길동"  " 이순신" " 강감찬" " 유관순"

# 7. 문자열 결합(join) : 기본함수
paste(name, collapse=", ")  # [1] "홍길동,  이순신,  강감찬,  유관순"
            ## ㄴ 뭘 기준으로 구분해서 결합할 것인지









