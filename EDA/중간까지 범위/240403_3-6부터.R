library(tidyverse)
library(nycflights13)

## 3.6.1 파이프로 여러 작업 결합하기
"""
1. 목적지별로 항공편 그룹화
2. 거리, 평균지연시간, 항공편 수를 계산하여 요약
3. 잡음이 많은 점과 호놀룰루 공항 제거하는 필터링
"""

delay <- flights %>%
    #그룹화
    group_by(dest) %>%
    #요약
    summarise(
        count = n(),
        dist = mean(distance, na.rm =T),
        delay = mean(arr_delay, na.rm =T)
    )%>%
    #필터링
    filter(count >20, dest != "HNL")#필터는 트루인 경우만 가지고 옴 
#플로팅
p <- ggplot(delay, aes(x= dist, y=delay))
p+
    geom_point(aes(size=count), alpha =1/3)+
    geom_smooth(se=F)

delay <- flights %>% 
    group_by(dest) %>% 
    summarize(
        count = n(),
        dist = mean(distance, na.rm = T)
    ) %>% 
    filter(count >20,dest != "HNL")


## 3.6.2 결측값 
flights %>% 
    group_by(year, month, day) %>% 
    summarize(mean = mean(dep_delay))
#결측값이 많이 생긴다. 
flights %>% 
    group_by(year, month, day) %>% 
    summarize(mean = mean(dep_delay, na.rm =T))
#취소된 항공 제거 

not_cancelled <- flights %>% 
    filter(!is.na(dep_delay), 
           !is.na(arr_delay)) #na가 아닌 것만 남김.

## 3.6.3카운트 

#평균 지연시간이 가장 긴 항공기(꼬리식별번호)
delay <- not_cancelled %>% 
    group_by(tailnum) %>% 
    summarize(
        delay = mean(arr_delay)
    )

p <- ggplot(delay, aes(x=delay))
p+geom_freqpoly(binwidth = 10)

#비행 횟수 대 평균 지연시간의 산점도 그리기 
delay <- not_cancelled %>% 
    group_by(tailnum) %>% 
    summarize(
        delay = mean(arr_delay, na.rm = T),
        n = n()
    )

p <- ggplot(delay, aes(x=n, y=delay))
p+geom_point(alpha=1/10)

#관측값이 작은 그룹을 필터링
delay %>% 
    filter(n>25) %>% 
    ggplot(aes(x=n,y=delay)) +
        geom_point(alpha =1/10)

install.packages("Lahman")
library(Lahman)

?Lahman
#타율 = 기술 수준: 안타수/유효타석수 
batting <- as_tibble(Lahman::Batting) # :: -> 경로
#데이터를 선수 아이디별 타율을 요약해 할당시킴킴
"""
ab = 안타를 칠 기회
ba = 타율 
"""

batters <- batting %>% 
    group_by(playerID) %>% 
    summarize(
        ba = sum(H, na.rm = T)/sum(AB, na.rm = T),
        ab = sum(AB, na.rm = T)
    )
#기술 수준과 볼을 칠 기회 사이 상관계 보기 위한 플로팅 
batters %>% 
    filter(ab>100) %>% 
    ggplot(aes(x=ab, y=ba))+
    geom_point()+
    geom_smooth(se=F)
"""
ab가 커질수록 변동이 줄어듦
볼을 칠 기회가 많아질 수록 타율이 높아짐: 양의 상관계가 보임
"""
#평균 타율이 높은 선수는 능력치가 좋은가?
batters %>% 
    arrange(desc(ba)) #단순히 운이 좋음 

