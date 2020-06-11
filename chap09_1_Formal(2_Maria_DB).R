# chap09_1_Formal(2_Maria_DB)

# Maria DB 정형 데이터 처리

# 패키지 설치
# - RJDBC 패키지를 사용하기 위해서는 우선 java를 설치해야 한다.
install.packages("rJava")
install.packages("DBI")
install.packages("RJDBC") # JDBC()함수 제공 

# 패키지 로딩
library(DBI)
# 경로 수정 
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jdk1.8.0_151')
library(rJava)
library(RJDBC) # rJava에 의존적이다.


################ MariaDB or MySql ###############
# classPath 수정 
drv <- JDBC(driverClass="com.mysql.jdbc.Driver", 
            classPath="C:/ITWILL/Work/2_Rwork/tools(R)/mysql-connector-java-5.1.46/mysql-connector-java-5.1.46/mysql-connector-java-5.1.46-bin.jar")

# driver가 완전히 로드된 후 db를 연결한다.
conn <- dbConnect(drv, "jdbc:mysql://127.0.0.1:3306/work", "scott", "tiger")
#################################################           

# DB 연결 확인 :  테이블의 컬럼 보기 
query <- "show tables"
dbGetQuery(conn, query)


