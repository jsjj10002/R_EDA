#|복습
#데이터 불러오기(사전준비)
read.csv("r_stat.csv",
         fileEncoding = "euc-kr",
         stringsAsFactors = T) -> rr1
str(rr1)#어떻게 생긴 데이터셋인지 확인(습관)

#막대도표 
barplot(table(rr1$성별1))
a<-table(rr1$성별1)
barplot(a,
        xlab = "성별",
        ylab = "빈도",
        main = "성별의 막대도표",
        col = rainbow(2),
        names=c("male","female"),
        las=3)


#|점분포
r<-read.csv("khkh.csv", fileEncoding = "euc-kr",
            stringsAsFactors = T)
str(r)
#lifemoney: 양적변수 >점도표: 질적자료는의미없음 
dotchart(r$lifemoney,
         labels = row.names(r))


#|세로 막대 차트
rr<-read.csv("kh.csv",
         fileEncoding = "euc-kr",
         stringsAsFactors = T)

str(rr)

barplot(table(rr$gender),
        xlab = "gender",
        ylab = "빈도",
        main = "성별의 막대ㄷ표",
        ylim = c(0,300),
        border = NA,
        las=2)

#|히스토그램: 계급 수 설정 가능 
str(rr)
hist(rr$money)#연봉

hist(rr$money,
     xlab = "연봉",
     ylab = "계급의 빈도수",
     main = "연봉의 히스토그램",
     border = "blue", #테두리색
     col = "red",
     breaks = 14, #계급의 수 정함 (10~20사이 적절)
     
     )
#히스토그램 비율로 나타내기(기본설정은 빈도)
hist(rr$money,
     xlab = "연봉",
     ylab = "계급의 비율",
     main = "연봉의 히스토그램",
     border = "blue", #테두리색
     col = "red",
     breaks = 14, #계급의 수 정함 (10~20사이 적절)
     freq = F  #비율로 
)

#|파이차트
library(ggplot2)
str(rr)

#설명변수에 값(레이블) 추가
rr$gender1 <- factor(rr$gender, 
                     levels = c(1,2),
                     labels = c('남','여'))
money<-rr$money
gender1<-rr$gender1
ggplot(r,aes(x=" ", 
             y=money, 
             fill=gender1))+
    geom_bar(stat = "identity",
             width = 1)

##라인차트
r<-read.csv("weather.csv")
install.packages("dplyr")
library(dplyr)
qplot(month, temporary, data = r, geom = "line")

##산점도
 install.packages("labelling")
##상자그림
r <- read.csv("kh.csv")
r$study1 <- factor(r$study, levels = c(2,3,4,5,6,7,8,9), 
                   labels= c("중학교 중퇴", "중학교졸업","고등학교중퇴","고등학교졸업","전문대","대졸","석사", "박사"))
ggplot(r,aes(study1,money))+geom_boxplot()+ggtitle("박스플롯")


##산점도
library(labeling)
r$baby1<-factor(r$baby, levels = c(1,2), labels = c("예","아니오"))
ggplot(data=r, aes(x=lifemoney, y=money))+
    geom_point(shape=19,size=3,colour="black")
ggplot(data=r, aes(x=lifemoney, y=money, colour=baby1))+
    geom_point(shape=19,size=3)

#산점도 line추가
plot(r$money, r$lifemoney)
abline(a=40.3791, b=0.0336, col='red')

##버블플롯
ggplot(r, aes(x=money, y=age)) +
    geom_point( aes(size=lifemoney), 
               shape=21, colour="grey90", fill="green",
       alpha=0.5)+
    geom_text(aes(y=as.numeric(age)-sqrt(lifemoney)/10, 
                  label=study),
              vjust=1, colour="grey40",size=3)+
    scale_size_area(max_size = 15)
