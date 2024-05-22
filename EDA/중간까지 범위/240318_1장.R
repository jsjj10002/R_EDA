install.packages("tidyverse")
library(tidyverse)
mpg #내장된 데이터셋
ggplot2 :: mpg
?mpg

#엔진의 크기(displ)와 연비(hwy) 사이 관계- 산점도

ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy))

#연습문제
ggplot(mpg) #아무것도 안나옴
str(mpg) #234*11 
?mpg #drv= 구동방식
#연비와 실린더 수 사이 관계 
ggplot(mpg)+
    geom_point(mapping=aes(x=hwy,y=cyl))
#차의 종류와 구동방식 산점도 - 둘 다 연속성으로 
ggplot(mpg)+
    geom_point(mapping=aes(x=class,y=drv))


#|심미성매핑

ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy, color=class)) #2인승차가 연비가 낮음

ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy, size=class)) #바람직X 순서형 아님

ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy, alpha =class)) #바람직X
ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy, shape=class)) #여섯개의 모양만 사용-나머지는 수동

#심미성 속성 수동 설정 ->mapping밖에서 설정
ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy),color="blue")

#연습문제
ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy, color="blue"))#원하는 대로 저장 안됨
str(mpg) #범주: 
?mpg

ggplot(mpg)+
    geom_point(mapping = aes(x=hwy, y=cty, shape=class,
                             size=trans,
                             color=model))

ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy),color="blue",size=3)

?geom_point
#stroke: 테두리 굵기 
ggplot(mtcars, aes(wt, mpg)) +
    geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)

#심미성을 변수 이름이 아닌 다른 것에 매핑 
ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy, color=displ<5))

#|facet 면분할
ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy))+
    facet_wrap(~class, nrow=3) # 이산형 변수

####
ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy))+
    facet_grid(drv~cyl) # 두 변수 조합

ggplot(data = mpg)+
    geom_point(mapping=aes(x=displ, y=hwy))+
    facet_grid(drv~cyl)

