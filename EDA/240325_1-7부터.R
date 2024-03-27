
install.packages("tidyverse")
library(tidyverse)

#|1.7통계적 변환
?diamonds
ggplot(diamonds, aes(x=cut))->p1
p1+geom_bar()
"""
geom_bar에서 y축은 도수 자동으로 설정됨
"""
p1+stat_count()

?geom_bar 

"""
빈도가 아닌 비율로 나타냄
"""
ggplot(diamonds)+
    geom_bar(aes(x=cut,y=stat(prop),group=1))

"""
스탯을 count(기본값)에서 identity로 변경
"""
demo <- tribble(
    ~cut, ~freq,
    "Fair", 1610,
    "Good", 4906,
    "very Good", 12082,
    "premium", 13791,
    "Ideal", 21551
)
demo
ggplot(demo)+
    geom_bar(
        aes(x=cut, y=freq),
        stat = "identity"
    )

#데이터 요약 
ggplot(diamonds)->p
p+stat_summary(aes(x=cut, y=depth),
               fun.ymin = min,
               fun.ymax = max,
               fun.y = median)

#|1.8 위치조정

p1+geom_bar(aes(color=cut)) #테두리만 

#막대의 색 채우기 
p1+geom_bar(aes(fill=cut))
#범주별로 다른 색
p1+geom_bar(aes(fill=clarity))

p2<-ggplot(diamonds,aes(x=cut,fill=clarity))

"""
누적 막대 생성 
position= "identiey", "dodge", "fill"
"""

# 그랲 문맥에 맞게 배치- 투명도 조절을 통해 확인 가능            
ggplot(diamonds,aes(x=cut,fill=clarity))+
    geom_bar(alpha=1/5,position = "identity") #투명도 조절

ggplot(diamonds,aes(x=cut,color=clarity))+
    geom_bar(fill=NA,position = "identity") #색상 없음 

# 누적 막대가 동일한 높이가 되도록 함.- 그룹들 비율을 비교하기 쉬워짐. 
p1+geom_bar(aes(fill=clarity), position = "fill")

#객체가 서로 옆에 배치- 개별 값 비교 쉬움 
p1+geom_bar(aes(fill=clarity), position = "dodge")

#오버플로팅
ggplot(mpg, aes(x=displ, y=hwy))+
    geom_point()

#산점도에서 오버플로팅 방지를 위해 노이즈 추가 
ggplot(mpg, aes(x=displ, y=hwy))+
    geom_point(position = "jitter")

#|1.9좌표계

#x,y위치 바꾸기 
p3<-ggplot(mpg, aes(x=class, y=hwy))
p3+geom_boxplot() #박스플롯- x축=범주, y축=연속

p3+geom_boxplot()+
    coord_flip() #x축y축 바꾸기

#극좌표 사용
p1+geom_bar(aes(fill=cut),
            show.legend = F,
            width=1)+
    theme(aspect.ratio = 1)+
    labs(x=NULL,y=NULL) 
bar<-p1+geom_bar(aes(fill=cut),
                 show.legend = F,
                 width=1)+
    theme(aspect.ratio = 1)+
    labs(x=NULL,y=NULL)

bar+coord_flip() #x-y축 변환

bar+coord_polar() #극좌표,geom_bar와 함께 그려야 함 
