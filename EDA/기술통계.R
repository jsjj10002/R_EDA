getwd()
setwd("E:\\3. My lecture note\\EDA\\데이터\\")
getwd()

rr1 <- read.csv("r_stat.csv", stringsAsFactor=TRUE,
                fileEncoding = "euc-kr")
str(rr1)
x1 <- na.omit(rr1$연간소득)

## 자료의 중심위치를 나타내는 대표값
# 평균
mean(x1)
# 중위수
median(x1)
# 최빈수
mode(x1)

x <- c(1,2,3,3)
xx <- unique(x)
xx[which.max(tabulate(match(x, xx)))]

## 최빈수를 구하는 함수 
Mode <- function(t) {
  tt <- unique(t)
  tt[which.max(tabulate(match(t, tt)))]
}

Mode(x1)

# 최소값, 1사분위수, 중위수, 평균, 3사분위수, 최대값
summary(x1)

## 자료의 퍼짐정도를 나타내는 값
# 분산
var(x1)

# 표준편차
sd(x1)

# 범위
max(x1)
min(x1)
max(x1)-min(x1)
range(x1)

# 사분위범위
# 제1사분위수
quantile(x1, 0.25)
# 제3사분위수
quantile(x1, 0.75)
IQR(x1)
quantile(x1, 0.75)-quantile(x1, 0.25)

str(rr1)
# 빈도분석
table(rr1$성별1)
table(rr1$자격증)
table(rr1$직급1)
table(rr1$혼인상태)

# 막대도표
barplot(table(rr1$성별1), 
        xlab="성별",
        ylab="빈도", 
        main="성별의 막대도표")

a <- table(rr1$성별1)
barplot(a, 
        xlab="성별",
        ylab="빈도", 
        main="성별의 막대도표",
        col=c("blue", "red"))

     
barplot(a, 
        xlab="성별",
        ylab="빈도", 
        main="성별의 막대도표",
        col=rainbow(2) )


barplot(a, 
        ylab="성별",
        xlab="빈도", 
        main="성별의 막대도표",
        col=rainbow(2) , horiz=TRUE )

barplot(a, 
        xlab="성별",
        ylab="빈도", 
        main="성별의 막대도표",
        col=rainbow(2),
        names=c("남자","여자") )

barplot(a, 
        xlab="성별",
        ylab="빈도", 
        main="성별의 막대도표",
        col=rainbow(2),
        names=c("남자","여자"),
        las=3)


barplot(a, 
        xlab="성별",
        ylab="빈도", 
        main="성별의 막대도표",
        col=rainbow(2),
        names=c("남자","여자"),
        las=3, legend.text=T
        )

barplot(a, 
        xlab="성별",
        ylab="빈도", 
        main="성별의 막대도표",
        col=rainbow(2),
        names=c("남자","여자"),
        las=3
)

legend("topright",
       legend=c("남자","여자"),
       fill=rainbow(2))

barplot(a, 
        xlab="성별",
        ylab="빈도", 
        main="성별의 막대도표",
        col=rainbow(2),
        names=c("남자","여자"),
        las=3
)

barplot(table(rr1$성별1,rr1$최종학력1), 
        xlab="직급",
        ylab="빈도", 
        main="성별과 최종학력의 막대도표",
        col=rainbow(2),
        las=1,
        beside=T
)

barplot(table(rr1$최종학력1,rr1$성별1), 
        xlab="직급",
        ylab="빈도", 
        main="성별과 최종학력의 막대도표",
        col=rainbow(2),
        las=3,
        beside=T
)

## 점도표
r <- read.csv("khkh.csv", stringsAsFactors = T)
str(r)
dotchart(r$lifemoney)
dotchart(r$lifemoney, label=row.names(r))

## 세로막대차트
r <- read.csv("kh.csv", stringsAsFactors = T)
str(r)
barplot(table(r$gender),
        xlab="성별", 
        ylab="빈도",
        main="성별의 막대도표",
        ylim=c(0,300),
        border=NA, las=1
)

## 히스토그램
hist(r$money,
     xlab="연봉",
     ylab="계급빈도",
     main="연봉의 히스토그램")

hist(r$money,
     xlab="연봉",
     ylab="계급분포",
     main="연봉의 히스토그램",
     freq=F,    # 계급비율
) 

hist(r$money,
     xlab="연봉",
     ylab="계급분포",
     main="연봉의 히스토그램",
     freq=F,    # 계급비율
     border="blue",# 테두리색
     col="red",    # 막대내부색
     breaks=10     # 몇개의 구간
     
     ) 
lines(density(r$money))


## 파이차트
r <- read.csv("kh.csv", stringsAsFactors = T)
str(r)

library(ggplot2)

## 성별변수에 값(레이블) 추가하기
r$gender1 <- factor(r$gender, 
                    levels=c(1,2), 
                    labels=c("남자", "여자"))
ggplot(r, 
       aes(x="",
           y=r$money,
           fill=gender1)) +
  ## 막대도표: geom_bar()
  geom_bar(stat="identity",
           width =1) +
  #원그림(Pie Chart): geom_bar() + coord_polar()  
  coord_polar(theta="y") +
  ggtitle("파이차트")


## 누적막대차트
r <- read.csv("kh.csv", stringsAsFactors = T)
str(r)


r$study1  <-  factor(r$study, 
                     levels=c(2,3,4,5,6,7,8,9), 
                     labels=c("중학교중퇴","중학교졸업","고등학교중퇴","고등학교졸업","전문대","대졸","석사","박사"))
r$gender1  <-  factor(r$gender, 
                      levels=c(1,2), 
                      labels=c("남","여"))

## 장점: 반대를 나타내는 빨간색에서 
## 찬성을 나타내는 파란색으로 감정 데이터 표현시 유용.
ggplot(r, aes(study1)) + 
  geom_bar(aes(fill=gender1), colour="black") +
  ggtitle("누적 막대 차트")


### 라인차트

r <- read.csv("weather.csv")
#install.packages("dplyr")
library(dplyr)
library(ggplot2)

qplot(month, temporary, 
      data = r, geom = "line")


## 상자그림
r <-  read.csv("kh.csv")
library(ggplot2)
r$study1  <-  factor(r$study, 
                     levels=c(2,3,4,5,6,7,8,9), 
                     labels=c("중학교중퇴","중학교졸업","고등학교중퇴","고등학교졸업","전문대","대졸","석사","박사"))

ggplot(r, aes(study1, money)) + 
  geom_boxplot(fill= rainbow(8)) + 
  ggtitle("박스 플롯")



## 산점도
r  <-  read.csv("kh.csv")

library(ggplot2)
#install.packages("labeling")
### 만약, no packages가 나타나면 "labeling" 패키지 설치
library(labeling)

r$baby1  <-  factor(r$baby, 
                    levels=c(1,2), 
                    labels=c("예","아니오")) 

ggplot(data=r, aes(x=lifemoney, y=money)) + 
  geom_point(shape=19, size=3,
                                                       colour="black")
ggplot(data=r, 
       aes(x=lifemoney, y=money, colour=baby1)) + 
  geom_point(shape=19, size=3) # 추가로 자녀의 유무에 따른 연봉과 생활비 산점도

## 산점도+라인추가
plot(r$money, r$lifemoney)
abline(a=40.3791, b=0.0336, 
       col="red")


## 버블플롯
r  <-  read.csv("kh.csv")
str(r)

library(ggplot2)
r$study1  <-  factor(r$study, 
                     levels=c(2,3,4,5,6,7,8,9), 
                     labels=c("중학교중퇴","중학교졸업","고등학교중퇴","고등학교졸업","전문대","대졸","석사", "박사"))

## 버블차트
## 세변수 간의 관계, 패턴 강조 
# money=연봉, lifemoney=생활비
ggplot(r, aes(x=money, y=age)) +
  geom_point(aes(size=lifemoney), 
             shape=21, 
             colour="grey90", 
             fill="green",
             alpha=0.5) + 
  geom_text(aes(y=as.numeric(age) - sqrt(lifemoney)/10, 
                label=study), 
            vjust=1,
            colour="grey40", 
            size=3) + 
  scale_size_area(max_size = 15)+
# 범례 없애려면 guide=FALSE
ggtitle("버블 차트")


## 산점도행렬
str(r)
r1  <-  r[c("age","money","lifemoney")] # 정량데이터만 추출

plot(r1) # 기존 r에서 제공해주는 함수 사용
pairs(r1, main="산점도행렬", col="blue", pch=2) 
pairs(r1, main="산점도행렬", col=c(1,3), pch=c(3,18)) 
 

