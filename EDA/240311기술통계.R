getwd()
#인적자원기업 패널데이터
rr1 <- read.csv("r_stat.csv",
                stringsAsFactors = T,
                fileEncoding = "euc-kr")
str(rr1)
rr1$연간소득#결측치가 많음, 양적자료
#결축차제거 na.omit
x1 <- na.omit(rr1$연간소득) 
mean(x1)
median(x1)

x <- c(1, 2, 3, 4)
xx<- unique(x) #중복되지 않는 값만 추출 
match(x,xx) #위치가 동일한 벡터 찾음 

Mode <- function(t) {
    tt <- unique(t)
    tt[which.max(tabulate(match(t, tt)))] }

Mode(x1)

#범위, 분산,표준분표 4분위수
range(x1)
max(x1)-min(x1)
var(x1)
sd(x1)
IQR(x1)
quantile(x1,0.75)-quantile(x1,0.25) 
#범주형변수
#table함수: 도수분포표
table(rr1$성별1) -> a
table(rr1$자격증) -> b
table(rr1$직급1) -> c
table(rr1$혼인상태1) -> d
#막대그래프
barplot(a,
        xlab = "성별", ylab = "수",
        main = "성별 빈도의 막대도표")
#색 설정
barplot(a,
        xlab = "성별", ylab = "수",
        main = "성별 빈도의 막대도표",
        col = c("blue", "red"))

barplot(a,
        xlab = "성별", ylab = "수",
        main = "성별 빈도의 막대도표",
        col = rainbow(2))

#방향 전환: horiz
barplot(a,
        xlab = "수", ylab = "성별",
        main = "성별 빈도의 막대도표",
        horiz = T)
#그룹 이름 변경:names
barplot(a,
        xlab = "성별", ylab = "수",
        main = "성별 빈도의 막대도표",
        names=c('남자', '여자'))
#x축 이름 방향 변환 : las 0,1, 2, 3
barplot(a,
        xlab = "성별", ylab = "수",
        main = "성별 빈도의 막대도표",
        names=c('남자', '여자'),
        las=2,
        col = rainbow(2))
#범례 표시 
legend("topright",
       legend = c("남자", "여자"), 
       fill = rainbow(2))







