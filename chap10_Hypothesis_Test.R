# chap10_Hypothesis_Test (추론통계분석)



# 가설(Hypothesis) : 어떤 사건을 설명하기 위한 가정 
# 검정(test) : 표본에 의해서 구해진 통계량으로 가설 채택/기각 과정 
# 추정(estimation) : 표본을 통해서 모집단을 확률적으로 추측   


# 검정통계량 : 표본에 의해서 계산된 통계량(표본평균, 표본표준편차)
# 모수 : 모집단에 의해서 나온 통계량(모평균, 모표준편차)  
# 오차 : 검정통계량과 모수 간의 차이 
# 오차범위 : 오차범위가 벗어나면 모수와 차이가 있다고 본다.
# 유의수준 : 오차 범위의 기준(통상 : 알파=0.05)


# 추정 방법 
# 1) 점 추정 : 제시된 한 개의 값과 검정통계량을 직접 비교하여
#    가설 기각유무를 결정 
# ex) 우리나라 중학교 2학년 남학생 평균키는 165.2cm로 추정

# 2) 구간 추정 : 신뢰구간과 검정통계량을 비교하여 가설 기각유무 결정 
# 신뢰구간 : 오차범위에 의해서 결정된 하한값과 상한값의 범위 
# ex) 우리나라 중학교 2학년 남학생 평균키는 164.5 ~ 165.5cm로 추정

#######################################
### 가설과 검정
#######################################

# 귀무 가설(H0) : 중2 남학생 평균키는 165.1~165.3cm 추정()

# 모집단 -> 표본추출(1000명)
x <-rnorm(1000, mean=165.2, sd=0.5)
length(x)

hist(x)
# 정규성 검정(H0 : 정규분포와 차이가 없다.)
shapiro.test(x)  # W = 0.9987, p-value = 0.6908
                # w 검정통계랑 p-value 유의확률
# 검정 : p-value >= 알파(0.05) 
# 귀무가설 채택


# 1. 평균차이 검정 - 채택역에 속하는 수로.
t.test(x, mu=165.2) 
# One Sample t-test
# 
# data:  x
# t = -0.78871, df = 999, p-value = 0.4305         : 검정통계량(t,df자유도)
# p-value가 0.4305 이므로 p>=알파(0.05)
#  귀무가설 채택
#alternative hypothesis: true mean is not equal to 165.2
# 95 percent confidence interval: 알파 0.05
#   165.1554 165.2190 : 신뢰 구간
# sample estimates:
#   mean of x   : x의 실제 평균
# 165.1872 



# 2. 기각역의 평균 검정
t.test(x, mu=165.1)
# 귀무가설 : 평균키가 165.1cm와 차이가 없다
# t = 5.3845, df = 999, p-value = 9.056e-08
# 9.056e-08 < 알파(0.05)
# alternative hypothesis: true mean is not equal to 165.1
# 95 percent confidence interval:
#   165.1554 165.2190   : 기각역
# sample estimates:
#   mean of x 
# 165.1872 


# 3. 신뢰수준 : 99%
?t.test
t.test(x, mu=165.21, conf.level = 0.99)
# t = -1.406, df = 999, p-value = 0.16
# alternative hypothesis: true mean is not equal to 165.21
# 99 percent confidence interval:
#   165.1454 165.2290   : 평균이 채택역에 속하게됨
# sample estimates:
#   mean of x 
# 165.1872 
# [해설] 신뢰수준 향상->채택역 확장









