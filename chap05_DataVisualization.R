# chap05_DataVisualization


# 차트 데이터 생성
chart_data <- c(305,450, 320, 460, 330, 480, 380, 520) 
names(chart_data) <- c("2016 1분기","2017 1분기","2016 2분기","2017 2분기","2016 3분기","2017 3분기","2016 4분기","2017 4분기")
str(chart_data)
chart_data

max(chart_data)  # 520

# 1. 이산변수 시각화
# - 정수단위로 나누어지는 수(자녀수, 판매수)

# (1) 막대차트 - 세로가 기본값
barplot(chart_data, ylim= c(0,600),
        main = "2016 vs 2017 판매현황", width = 0.2,
        density = 80,
        col = rainbow(8))

?barplot

# 가로 막대 차트
barplot(chart_data, ylim=c(0,600),
        main = "2016년 vs 2017년 판매현황",
        density = 80, width = 50,
        col = rainbow(8),
        horiz =T)

?barplot

# 1행 2열 구조
par(mfrow=c(1,2))    # 한번에 두개보기
VADeaths
str(VADeaths)

row_names <- row.names(VADeaths)
row_names
col_names <- colnames(VADeaths)
col_names

max(VADeaths)
# beside 有無 비교
barplot(VADeaths, beside = F,                 #누적
        horiz=F, main="버지니아  사망비율",
        col=rainbow(5))
barplot(VADeaths, beside = T,                 #누적x
        horiz=F, main="버지니아  사망비율",
        col = rainbow(5))


par(mfrow=c(1,1))


# 범례 추가
legend(x=4, y=200, legend=row_names,
       fill = rainbow(5))


# (2) 점 차트
dotchart(chart_data, color=c("black","red"), 
         lcolor="black", pch=1:2,  
         labels=names(chart_data),       ## y축에 라벨달기
         xlab="매출액",
         main="분기별 판매현황 점 차트 시각화", 
         cex=1) 

# (3) 파이 차트

pie(chart_data, labels=names(chart_data),
    border='black', col=rainbow(8),
    cex=1)
# 차트에제목추가
title("2016~2017년도 분기별 매출현황")

table(iris$Species)
pie(table(iris$Species), col = rainbow(3),
    border='blue', main="iris 꽃 종별 빈도수")

# 2. 연속변수 시각화
# - 시간, 길이 등의 연속성을 갖는 변수

# 1) 상자 그래프 시각화 - summary에 대한 내용 시각화
summary(VADeaths)  # 요약통계량
VADeaths
boxplot(VADeaths)   ####???????????????????????????????뭘그린건지모르겟음

# 2) 히스토그램 시각화 - 대칭성확인
data(iris)
iris
names(iris)
str(iris)
head(iris)

range(iris$Sepal.Width)  # [1] 2.0 4.4

hist(iris$Sepal.Width, xlab="iris$Sepal.Width",
     col="mistyrose", main="iris 꽃받침 넓이 histogram",
     xlim=c(2.0, 4.5),
     freq=F)

par(mfrow=c(1,2))
hist(iris$Sepal.Width, xlab="iris#Sepal.Width",
     col='green', main="iris 꽃받침 넓이 histogram",
     freq=T,
     xlim=c(2.0, 4.5))

par(mfrow=c(1,1))

hist(iris$Sepal.Width, xlab="iris$Sepal.Width",
     col="mistyrose", main="iris 꽃받침 넓이 histogram",
     xlim=c(2.0, 4.5),
     freq=F)
# 밀도분포곡선 추가

lines(density(iris$Sepal.Width), col='red')  # y축을 density형태로 설정한 후에 해야함
curve(dnorm(x, mean=mean(iris$Sepal.Width), sd=sd(iris$Sepal.Width)),
      col="blue",add=T)

lines(density(x), col='black')  ##########????????????????????????????

# 3) 산점도 시각화
?runif
x <- runif(n=15, min=1, max=100)
x
plot(x)  # 데이터가하나일때 x->y, index->y
y <- runif(n=15, min=5, max=120)
y
plot(x,y)  # (y~x)
plot(x~y)
plot(y~x)

head(iris)
plot(iris$Sepal.Length, iris$Petal.Length,
     col =iris$Species)              ###   범주상의 꽃의 종

par(mfrow=c(2,2))

price <- runif(10, min=1, max=10)
plot(price, type="l") # 유형 : 실선
plot(price, type="o") # 유형 : 원형과 실선(원형 통과)
plot(price, type="h") # 직선
plot(price, type="s") # 꺾은선

plot(price, type="o", pch=5, col="blue")
plot(price, type="o", pch=15, col="orange", cex=1.5)
plot(price, type="o", pch=20, col="grey", cex=1.2, lwd=2)


# 만능차트
methods(plot)

# plot.ts : 시계열자료
WWWusage
par(mfrow=c(1,1))
plot(WWWusage)
plot(WWWusage, type='h', lwd=1.5, xlab="분")

# plt.lm* : 회귀모델
install.packages("UsingR")
library(UsingR)
Galton
data("Galton")
library(help=UsingR)
str(galton)
data(galton)
# 유전학자 갈톤 : '회귀' 용어 제안
model <- lm(child~parent, data=galton)
model
plot(model)  #다음 플랏을 보기 위해서는 <Return>키를 치세요

# 4) 산점도 행렬(scatter metrix) : 변수 간의 비교
pairs(iris[-5])

# iris 꽃의 종별 산점도 행렬
# pairs(iris[row, col])
table(iris$Species)
pairs(iris[iris$Species=='setosa', 1:4])  #전체 꽃의 setosa 종 50개를 가지고.
pairs(iris[iris$Species=='virginica', 1:4])


# 5) 차트 파일 저장

setwd("C:/ITWILL/work/2_Rwork/output")
jpeg("iris.jpg", width=720, height=480)
plot(iris$Sepal.Length, iris$Petal.Length, col=iris$Species)
title(main="iris 데이터 테이블 산포도 차트")
dev.off()



#########################
### 3차원 산점도 
#########################
install.packages('scatterplot3d')
library(scatterplot3d)

# scatterplot3d(밑변, 오른쪽변, 왼쪽변, type='n')

# 꽃의 종류별 분류 
iris_setosa = iris[iris$Species == 'setosa',]
iris_versicolor = iris[iris$Species == 'versicolor',]
iris_virginica = iris[iris$Species == 'virginica',]

# scatterplot3d(밑변, 오른쪽변, 왼쪽변, type='n') # type='n' : 기본 산점도 제외 
d3 <- scatterplot3d(iris$Petal.Length, iris$Sepal.Length, iris$Sepal.Width, type='n')

d3$points3d(iris_setosa$Petal.Length, iris_setosa$Sepal.Length,
            iris_setosa$Sepal.Width, bg='orange', pch=21)

d3$points3d(iris_versicolor$Petal.Length, iris_versicolor$Sepal.Length,
            iris_versicolor$Sepal.Width, bg='blue', pch=23)

d3$points3d(iris_virginica$Petal.Length, iris_virginica$Sepal.Length,
            iris_virginica$Sepal.Width, bg='green', pch=25)








