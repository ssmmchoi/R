# chap03_DataIO

# 1. Data 불러오기 (Data Input) : 키보드 입력, 파일 가져오기

# 1) 키보드 입력 - 주로 소량의 데이터를 넣어 테스트할 때 씀
# 숫자입력
x<-scan()  #  우측 콘솔 창에 직접 입력.
x  #10 20 30
x[3]  # 30
sum(x)
mean(x)

string <- scan(what = character())
string  # "홍길동" "이순신" "유관순"
string <-scan(what=character())

# 2) 파일 읽기
# (1)read.table() : 칼럼 구분(공백, 특수문자)

setwd("C:/ITWILL/Work/2_Rwork/Part-I")

# - txt file 가져오기
read.table('student.txt')  # 제목없음, 공백으로 구분
                           # 기본 제목을 제공

# - 칼럼명(제목)이 있는 경우
student2<-read.table("student2.txt", header=T, sep=";")
student2
student2<-read.table("student2.txt", header=T, sep=" ")

student3<- read.table("student3.txt", header=T, sep=" ")
student3

student3$'키'
# [1] 175 185 173 -  
#   Levels: - 173 175 185  >>요인형이 들어왔다.
## 연산이 불가능한 문자타입으로 읽어왔다는 뜻.

# - 결측치 처리하기 : -, &
student3<- read.table("student3.txt", header=T, 
                      na.strings=c("-", "&"))
student3
student3$'키'  # [1] 175 185 173  NA 이제 숫자형 됐음
mean(student3$'키', na.rm=T)

str(student3)
class(student3)  # [1] "data.frame"

# (2) read.csv() : 구분자 - 콤마(,)
student4<-read.csv("student4.txt", na.strings = "-")  # header, sep는 T, ","가 기본
student4


# 탐색기 이용 파일 선택
excel<-read.csv(file.choose())
excel
## 마지막의 [ reached 'max' / getOption("max.print") -- omitted 202 rows ]
# 는 402개의 데이터 중 202개 생략되었다는 뜻


# xls / xlsx 불러오기(read.xlsx()) : 패키지 설치 필요함
install.packages("xlsx")
## install.packages("rJava") 의존성 패키지도 설치가 자동으로 안 되었다면, 하면됨
                            #그런경우 rJava를 먼저 올릴 것
library(rJava)
library(xlsx)

cospi<-read.xlsx("sam_kospi.xlsx", sheetIndex=1)
cospi

# 한글이 포함된 엑셀 파일 읽기
st_excel<-read.xlsx("studentexcel.xlsx", sheetIndex = 1, encoding = 'UTF-8')
st_excel  # 한글이 포함되었으므로 인코딩 방식 지정 필수

# (3) 인터넷 파일 읽기
# 데이터 셋 제공 사이트 
# http://www.public.iastate.edu/~hofmann/data_in_r_sortable.html - Datasets in R packages
# https://vincentarelbundock.github.io/Rdatasets/datasets.html
# https://r-dir.com/reference/datasets.html - Dataset site
# http://www.rdatamining.com/resources/data

tit<-read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/COUNT/titanic.csv")
tit
str(tit)
dim(tit)
head(tit)

# 생존여부
table(tit$survived)
# no yes 
# 817 499

# 성별 구분
table(tit$sex)

# class 구분
table(tit$class)
# 1st class 2nd class 3rd class 
# 325       285       706 

# 성별에 따른 생존여부 : 교차분할표crosstable(성별vs생존여부)
tab<-table(tit$survived, tit$sex)
# man women
# no  694   123
# yes 175   324
?table

barplot(tab, col=rainbow(2))

getOption("max.print")  #[1] 1000
#  tit는 200줄, 5개 변수로 구성되어 있으므로 1000개. 나머지는 생략됨

options(max.print=9999999)
tit


# 2. 데이터 저장(출력)하기

# 1) 화면 출력
x=20
y=30
z=x+y
z

cat('x+y의 결과는\n',z,'입니다.')
print(z)  # 함수 내에서 출력
print('z=', z)  #Error. cannot be used with characters
print(z*2) # calculation ok

# 2) 파일 저장(출력)
# read.table -> write.table : 구분자 공백, 특수문자
# read.csv -> write.csv : 구분자 쉼표
# read.xlsx -> write.xlsx : 엑셀파일로 직접 저장(별도의 패키지 필요)

# (1) write.table : 공백
setwd("C:/ITWILL/Work/2_Rwork/output")

write.table(tit, "titanic.txt", row.names=F)
write.table(tit, "titanic2.txt", row.names=F, quote=F)

# (2) write.csv : 콤마
head(tit)
tit_df <- tit[-1]
tit_df
str(tit_df)

write.csv(tit_df, "titanic_df.csv", row.names=F, quote=F)

# (3) write.xlxs : 엑셀 파일, 패키지 필요

search()  # "package:xlsx" 존재함

write.xlsx(tit, "titanic.xlsx", sheetName = "titanic",
           row.names = F)


