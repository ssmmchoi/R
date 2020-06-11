# chap09_1_Formal (oracle)

# chap09_1_Formal(1_Oracle)

########################################
## Chapter09-1. 정형데이터 처리 
########################################

# Oracle DB 정형 데이터 처리

# 1. 패키지 설치
# - RJDBC 패키지를 사용하기 위해서는 우선 java를 설치해야 한다.
#
install.packages("rJava")
install.packages("DBI")
install.packages("RJDBC")

remove.packages("rJava")
remove.packages("DBI")
remove.packages("RJDBC")

# 2. 패키지 로딩
library(DBI)
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_151')
library(rJava)
library(RJDBC) # rJava에 의존적이다.(rJava 먼저 로딩)

# 3) Oracle 연동   

############ Oracle 11g ##############
# driver  object 만들기
drv<-JDBC("oracle.jdbc.driver.OracleDriver", 
          "C:/oraclexe/app/oracle/product/11.2.0/server/jdbc/lib/ojdbc6.jar")
# db연동(driver, url,uid,upwd)  object (db연동객체)
conn<-dbConnect(drv, "jdbc:oracle:thin:@//127.0.0.1:1521/xe","scott","tiger")
####################################

# 이제부터 더블쿼트 안에 sql문을 그대로 쓸 수 있음
query <- "select * from  tab"

# dbGetQuery(db연동객체, 쿼리문)
dbGetQuery(conn, query)

# table 생성
query <- "create table db_test(
sid int,
pwd char(4),
name varchar(20),
age int)"

dbSendUpdate(conn, query)
###############################################error
dbGetQuery(conn, "select * from tab")  ## 나오긴함

q <- "drop tabel db_test purge"
dbGetQuery(conn, q)  ############# auch error

# db 내용 수정 : inset, update, delete
query <- "insert into db_test 
values(1001, '1234', '홍길동', 35)"

dbSendQuery(conn, query)
dbGetQuery(conn, "select * from db_test")

# 2. update
dbSendUpdate(conn, "update db_test set
             name='김길동' where sid=1001")
dbGetQuery(conn, "select * from db_test")

# 3. delete
dbSendUpdate(conn, "delete from db_test where sid=1001")
dbGetQuery(conn, "select * from db_test")

# 4. table drop
dbSendUpdate(conn, "drop table db_test purge")
dbGetQuery(conn, "select * from tab")

EMP <- dbGetQuery(conn, " select * from emp")
EMP
str(EMP) # data.frame

mean(EMP$SAL)  # 2073.214
round(mean(EMP$SAL))  # 2073
summary(EMP$SAL)

# 문1) SAL 2500이상, 직책(JOB) MANAGER인 사원만 조회하기
dbSendUpdate(conn, "select * from EMP where SAL>=2500 and JOB='MANAGER'")
dbGetQuery(conn, "select * from EMP where SAL>=2500 and JOB='MANAGER'")
#or
query <- "select * from EMP where SAL>=2500 and JOB='MANAGER'"
manager_2500 <- dbGetQuery(conn, query)
manager_2500
str(manager_2500)

# 문2) sub query 관련 문제
# 부서가 'SALES'인 전체 사원의 이름, 급여, 직책 출력하기
# sub : DETP, main : EMP
dbGetQuery(conn, "select * from DEPT")
dbGetQuery(conn, "select * from EMP")

query <- "select ENAME, SAL, JOB from EMP
where DEPTNO=(select DEPTNO from DEPT where DNAME='SALES')"

sub_sol <- dbGetQuery(conn, query)

sub_sol

# 문3) join 쿼리문
dbGetQuery(conn, "select * from product")
dbGetQuery(conn, "select * from sale")

query <- "
select p.code, p.name, s.sdate, s.price
from product p, sale s
where p.code=s.code and p.name like '%기'"

join <- dbGetQuery(conn, query)

join


# db 연결 종료
dbDisconnect(conn)





# chap09_1_Formal(2_Maria_DB)

# Maria DB 정형 데이터 처리

# 패키지 설치
# - RJDBC 패키지를 사용하기 위해서는 우선 java를 설치해야 한다.
#install.packages("rJava")
#install.packages("DBI")
#install.packages("RJDBC") # JDBC()함수 제공 

# 패키지 로딩
library(DBI)
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_111')
library(rJava)
library(RJDBC) # rJava에 의존적이다.

################ MariaDB or MySql ###############
drv <- JDBC(driverClass="com.mysql.jdbc.Driver", 
            classPath="C:\\Rwork\\util\\mysql-connector-java-5.1.37\\mysql-connector-java-5.1.37\\mysql-connector-java-5.1.37-bin.jar")

# driver가 완전히 로드된 후 db를 연결한다.
conn <- dbConnect(drv, "jdbc:mysql://127.0.0.1:3306/work", "scott", "tiger")
#################################################           

# DB 연결 확인 :  테이블의 컬럼 보기 
dbListFields(conn, "goods") # conn, table name












































