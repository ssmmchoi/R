# chap06_Datahandling


# 1. dplyr 패키지 활용

install.packages("dplyr")
library(dplyr)

library(help=dplyr)

# 파이프 연산자 : %>%
# 형식) df%>%func1()%>%func2() : func2(func1(df))
#       df는 데이타프레임
head(iris)
iris %>% head()
iris %>% head() %>% filter(Sepal.Length>=5.0)
# 150 관측치 > 6 관측치 > 3 관측치

install.packages("hflights")
library(hflights)
str(hflights)
?hflights

hflights %>% head()

# 2) tbl_df() : 콘솔 크기만큼 자료 나타내기
hflights_df <- tbl_df(hflights)
hflights_df

# 3) filter() : 조건에 맞는 '행' 추출
# 형식) df %>% filter(조건식)
iris %>% head()
names(iris)
iris %>% filter(Species == 'setosa') %>% head()
iris %>% filter(iris[,2] > 3) %>% head()
iris_df <- iris %>% filter(Sepal.Width >3)
str(iris_df)
iris_df


# 형식) filter(df, 조건식)
filter(hflights_df, Month ==1& DayofMonth ==1)
filter(iris, Sepal.Width>3)
filter(hflights, Month==1 | Month==2) %>% tbl_df()

# 4) arrange() : 정렬 함수
# 형식) df %>% arrange(칼럼명, 기본값은 오름차순, 내림차순은desc())
iris %>% arrange(Sepal.Width) %>% head()
iris%>%head()
iris %>% arrange(desc(iris[,2])) %>% head()

# 형식) arrange(df, 칼럼명)
head(hflights)
arrange(hflights, Month, DayofMonth, ArrTime)
tbl_df(arrange(hflights, Month, DayofMonth, desc(ArrTime)))

# 5) select 열 불러오기
# df %>% select

hflights_df %>% select(Year, Month, DayOfWeek, FlightNum)
hflights %>% select(Year, Month, DayOfWeek, FlightNum)

# 형식) select(df, col1, col2...)
hflights_df
select(hflights_df, Year, Month, DayOfWeek, FlightNum) %>% arrange(DayOfWeek)

names(hflights_df)

select(hflights_df, DepTime, ArrTime, TailNum, Cancelled)

select(hflights_df, Year:DayOfWeek)
select(hflights,-(Year:DayOfWeek)) %>% head()

# 문) Month 기준으로 내림차순 정렬하고 Year, Month, AirTime
#     칼럼 선택하기

arrange(hflights, Month) %>% 
  select(Year, Month, AirTime)

# 6) mutate() : 열 추가 (변형)
# 형식) df %>% mutate(변수=함수)   ### 함수는 주로 통계함수
mutate(hflights_df, gain=ArrDelay-DepDelay) %>% select(ArrDelay, DepDelay, gain)
mutate(hflights, gain=ArrDelay-DepDelay) %>%
  select(ArrDelay, DepDelay, gain) %>% tbl_df()


iris%>% head()
iris %>% mutate(diff=iris[,1]-iris[,2]) %>% head()
iris_diff <- iris %>% mutate(diff.Width=iris[,2]-iris[,4],
                diff.Length=Sepal.Length-Petal.Length) %>% head()
iris_diff

str(hflights_df)
str(iris)

select((iris %>% mutate(diff=iris[,1]-iris[,2]) %>% head()),
       Species, diff)


# 7) summarise() : 통계 구하기
# 형식) df %>% summarise(변수=통계함수())
iris%>% summarise(col1_avg=mean(iris[,1]),
                  col1_sd=sd(iris[,1]))
# col1_avg   col1_sd
# 1 5.843333 0.8280661
 ?n()

summarise(hflights_df, '총'=n())
summarise(hflights_df, cnt=n(),
          delay=mean(DepDelay, na.rm=T),
          delay_tot=sum(DepDelay, na.rm=T))
# cnt delay delay_tot
# <int> <dbl>     <int>
#  1 227496  9.44   2121251


# 8) group_by(dataset, 집단변수)
# 항공기별로 비행편수가 20편 이상,
# 평균 비행거리 2,000 마일 이내의 평균 연착시간

names(iris)
table(iris$Species)
group<-iris %>% group_by(Species)
head(iris[-5])
summarise(group, mean(Sepal.Length))
# Species    `mean(Sepal.Length)`
# <fct>                     <dbl>
# 1 setosa                     5.01
# 2 versicolor                 5.94
# 3 virginica                  6.59

summarize(group, sd(Sepal.Length))

# group_by 실습
install.packages("ggplot2")
library(ggplot2)

data("mtcars")
head(mtcars)
str(mtcars)

table(mtcars$cyl)
# 4  6  8 
# 11  7 14

table(mtcars$gear)
# 3  4  5 
# 15 12  5 

# cyl 실린더를 집단변수를 사용해보기로.
grp<-group_by(mtcars, cyl)
grp
summarise(grp)
# 1     4
# 2     6
# 3     8

# 각 집단별 연비 평균과 표준편차
summarise(grp, mpg_avg=mean(mpg),
          sd_avg=sd(mpg))
#      cyl   mpg_avg sd_avg
#     <dbl>   <dbl>  <dbl>
# 1     4    26.7   4.51
# 2     6    19.7   1.45
# 3     8    15.1   2.56

# 차체와 기어와의 상관관계. grou_by gear
# 각 기어 집단별 무게의 평균, 표준편차
grp2<- group_by(mtcars, gear)
grp2

summarise(grp2, avg_wt = mean(wt),
          sd_wt = sd(wt))
# gear avg_wt sd_wt
# <dbl>  <dbl> <dbl>
# 1     3   3.89 0.833  3단기어는 다른 것 보다 무거운
# 2     4   2.62 0.633  경향이 있네욤.
# 3     5   2.63 0.819

# 두 개의 집단변수 -> 그룹화
grp2<-group_by(mtcars, cyl, gear)  #cyl:1st, gear:2nd
grp2

summarise(grp2, avg_mpg = mean(mpg),
          sd_mpg=sd(mpg))
#     cyl  gear avg_mpg  sd_mpg
#    <dbl> <dbl>   <dbl>   <dbl>
# 1     4     3    21.5   NaN    
# 2     4     4    26.9   4.81 
# 3     4     5    28.2   3.11 
# 4     6     3    19.8   2.33 
# 5     6     4    19.8   1.55 
# 6     6     5    19.7   NaN    
# 7     8     3    15.0   2.77 
# 8     8     5    15.4   0.566

# group_by실습
# 예제) 각 항공기별! 비행편수가 40편 이상이고,
#       평균 비행거리가 2,000마일 이상인 경우의
#       평균도착지연시간을 확인하라
######## 항상 '별'로 groupby

names(hflights)

# 1) 항공기별 그룹화
str(hflights_df)
planes <-group_by(hflights, TailNum)  # 항공기일렬번호

# 2) 항공기별 요약 통계
planes_stats<-summarise(planes,count=n(),
          dist_avg = mean(Distance, na.rm=T),
          delay_avg = mean(ArrDelay, na.rm=T))
planes_stats
sol <- planes_stats %>% filter(count>=40 &
                        dist_avg>=2000)

sol
# TailNum   count dist_avg delay_avg
# <chr>     <int>    <dbl>     <dbl>
# 1 N66056     47    2038.      3.21
# 2 N69063     81    3619.     22.2 
# 3 N76062     43    2033.     15.6 
# 4 N76064     77    3579.     11.7 
# 5 N76065     90    3607.      2.89
# 6 N77066     85    3579.     13.7 

# 3. reshape2 기존의 모양을 다른 모양으로 바꿔주는.
install.packages("reshape2")
install.packages('reshape2')
library("reshape2")
library(reshape2)
??reshape2

# 1) dcast() : long -> wide (| -> ㅡ)

data <- read.csv(file.choose())
data  # part||/data.csv
# Date = 구매일자 (col)
# ID = 고객 구분자 (row)
# Buy = 그매수량  ()

# 형식) dcast(dataset, row~col, func)

dcast(data, Customer_ID~Date, sum)
wide <-dcast(data, Customer_ID~Date, sum)
wide
library(ggplot2)
data(mpg)
str(mpg)
mpg
head(mpg)

mpg_df <- as.data.frame(mpg)
str(mpg_df)                 ## 본래 tbl_df가 걸려잇던 자료가 dataframe으로 변환됨

mpg_df

names(mpg)
mpg_df <- select(mpg_df, c(cyl, drv, hwy))
head(mpg_df)
table(mpg_df$cyl)
table(mpg_df$drv)
table(mpg_df$hwy)


# 교차셀에 hwy 합계

tab <- dcast(mpg_df, cyl~drv, sum)
##############?????????????????????????????????????????

# 교차셀에 hwy 출현 건수
tab2<-dcast(mpg_df, cyl~drv, length)

# 교차분할표(ㄴ위와 같은 결과 나타남)
# table(행집단변수, 열집단변수)
table(mpg$drv)

table(mpg_df$cyl, mpg_df$drv)

unique(mpg_df$cyl)  # 4 6 8 5 -> 네 개의 범주를 갖는 집단이다.
unique(mpg_df$drv)  # "f" "4" "r"


# 2) melt() : wide -> long(ㅡ -> |)
long <- melt(wide, id="Customer_ID")
# Customer_OD : 기준칼럼
# variable : 열이름
# value :  교차셀의 값
long

names(long) <- c("User_ID", "Date", "Buy")
long

# example
data("smiths")
smiths

# wide -> long
long <- melt(smiths, id='subject') %>% arrange(subject)
long

long2 <- melt(smiths, id=1:2) %>% arrange(subject)
long2

# long <- wide 원위치.
 wide <- dcast(long, subject~...)   # ...은 나머지컬럼
 wide



# 3. acast(dataset, 행~열~면)
data("airquality")
str(airquality)
airquality %>% head()
## 얘를 월별로 다른 면에 쪼개보자.?

table(airquality$Month)
#  5  6  7  8  9   : 월
# 31 30 31 31 30   : 일

table(airquality$Day)
dim(airquality)  # 153 6

# wide -> long
air_melt <- melt(airquality, id=c("Month", "Day"), na.rm=T)
air_melt %>% arrange(Month, Day)
dim(air_melt)  #  568   4  col은 설정한 것 외에 variable과 value가 붙음

table(air_melt$variable)
# Ozone Solar.R    Wind    Temp 
# 116     146     153     153 

# [일, 월, variable] : [행, 열, 면]
# acast(dataset, Day~Month~variable)
array_3d <- acast(air_melt, Day~Month~variable)  # [31행, 5열, 4면]
array_3d 

array_3d_2 <- acast(air_melt, Day~variable~Month)
array_3d_2

# 오존 data
array_3d[,,1]  %>% head()
# 태양열 data
array_3d[,,2]  %>% head()


############################################################
################### 추가 내용 #######################
###########################################################
# 4. URL만들기 : http://www.naver.com?name='홍길동' 
#                                     네이버 상에서 이름이 홍길동인것을 찾아줌

# 1) base url 만들기
baseUrl <- "http://www.sbus.or.kr/2018/lost/lost_02.htm"
baseUrl

# 2) page query 추가(1~5p.)
# http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=3&search=&selectstate=&bus_no=&sear=

no <- 1:5
library(stringr)
page <- str_c('?Page=', no)
page  # "?Page=1" "?Page=2" "?Page=3" "?Page=4" "?Page=5"

# outer(x(1), y(n), func) : x 한개를 기준으로 y를 함수추출해줌.
page_url<-outer(baseUrl, page, str_c)
page_url
#        [,1]                                                
# [1,] "http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=1"
#        [,2]                                                
# [1,] "http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=2"
#        [,3]                                                
# [1,] "http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=3"
#        [,4]                                                
# [1,] "http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=4"
#        [,5]                                                
# [1,] "http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=5"

dim(page_url)  #1 5

# reshape : 2d -> 1d
page_url <- sort(as.vector(page_url))
page_url

# 3) sear query 추가
# http://www.sbus.or.kr/2018/lost/lost_02.htm?Page=3&sear=2
no <- 1:3
sear <- str_c("&sear=", no)
sear  # "sear=1" "sear=2" "sear=3"

page_url2 <- outer(page_url, sear, str_c)
page_url2

page_url2 <- sort(as.vector(page_url2))
page_url2






























