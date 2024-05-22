#### 3.6.7 연습문제
library(nycflights13)
library(tidyverse)

#2. count()를 사용하지 않고 not_cancelled %>% count(dest)와 not_cancelled %>% count(tailnum, wt = distance)와 같은 출력을 주는 다른 접근법을 생각해보라.

# 취소된 항공편 제거
# dep_delay/arr_delay = 출발 및 도착 지연시간 결측치 제거
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

## count()를 사용한 경우 
not_cancelled  %>% 
  count(dest)
# A tibble: 104 x 2

## count()를 사용하지 않는 경우 
not_cancelled  %>% 
  group_by(dest) %>% 
  summarise(
    count_dest = n()
  )
##동일 결과

## wt = 인수? sum(x) : 그룹별 x변수 합계
## 꼬리번호별로 운항거리합계
## count()를 사용한 경우 
not_cancelled %>% 
  count(tailnum, wt = distance) 
# A tibble: 1,450 x 2

## count()를 사용하지 않는 경우
not_cancelled %>% 
  group_by(tailnum) %>%  
  summarise(
    wt = sum(distance, na.rm = T)
  )
##동일 결과



# 4. 일간 취소된 항공편의 수를 살펴보라. 패턴이 있는가? 취소된 항공편 비율이 평균 지연시간과 관련이 있는가?
dayday <- flights %>% 
  # 취소된 항공편
  mutate(
    cancelled =(is.na(dep_delay)| is.na(arr_delay)),
    .after = day ) %>%  
  group_by(year, month, day) %>%  # 일간
  summarise(
    n=n(),  # 항공편의 수
    cancel=sum(cancelled), # 일간 취소된 항공편의 수
    prop_cancelled = mean(cancelled), # 취소된 항공편 비율
    mean_delay = mean(dep_delay + arr_delay, na.rm = T) # 일간 평균 지연시간
  ) 

# 패턴이 있는가?
dayday %>% 
  ggplot()+
  geom_point(
    mapping = aes(x=n, y=cancel)
    )

# 취소된 항공편 비율이 평균 지연시간과 관련이 있는가?
dayday %>% 
  ggplot()+
  geom_point(  
    mapping = aes(x=mean_delay, y=prop_cancelled)
  )
 
 

#6. count()의 sort 인수의 역할은 무엇인가? 언제 사용하겠는가?
# 목적지별, 항공사별로 카운트 한다면?  
flights %>% 
  group_by(carrier, dest) %>% 
  count()

# 위와 동일 
flights %>% 
  group_by(carrier, dest) %>% 
  summarise(
    n=n()
    ) 

# sort 인수의 역할?
## sort = TRUE? arrange(desc()) 동일 효과
flights %>% 
  group_by(carrier, dest) %>% 
  count(sort=T)  ## 내림차순 

# 위와 동일 
flights %>% 
  group_by(carrier, dest) %>% 
  summarise(
    n=n()
  ) %>% 
  arrange(desc(n))



#### 3.7.1 연습문제
                        

#2. 어떤 항공기(tailnum)가 최악의 정시 기록을 가지고 있는가?
# dep_delay : 출발 지연
flights %>% 
  filter(dep_delay > 0) %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = sum(dep_delay)) %>% 
  arrange(desc(delay))
# N228JB  

# arr_delay : 도착 지연
flights %>% 
  filter(arr_delay > 0) %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = sum(arr_delay)) %>% 
  arrange(desc(delay))
# N228JB 로 동일.


## 빨리 출발했거나, 따라잡은 경우 제외
flights %>% 
  filter(arr_delay > 0| dep_delay > 0) %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay + dep_delay)
    ) %>% 
  arrange(desc(delay))
# N844MH로 달라짐. 



#4. 각 목적지별로 총 지연시간을 분으로 계산하라. 각 항공편별로 목적지까지의 총 지연시간의 비율을 계산하라.

# 총 지연시간? 
flights %>% 
  mutate(
    delay = arr_delay + dep_delay, # 지연시간(분) 
#    gain = dep_delay - arr_delay,  # 따라잡은 시간(분)
    .after = day
  ) %>%
  group_by(dest) %>% #목적지별
  summarise(
    total_delay = sum(delay, na.rm = T),
#    total_gain = sum(gain, na.rm = T)
    ) %>% 
  arrange(desc(total_delay))  
# 각 목적지별로 총 지연시간 
# ATL 399462


# 각 항공편별로 목적지까지의 총 지연시간의 비율
flights %>% 
  filter(arr_delay > 0| dep_delay > 0) %>% 
  mutate(
    delay = arr_delay + dep_delay, # 지연시간(분) 
    prop_delay = delay / sum(delay, na.rm = T), 
    .after = day
  ) %>%
  select(flight, dest, delay, prop_delay) 


#6. 각 목적지를 살펴보라. 의심스럽게 빠른 항공편들을 찾을 수 있는가? (즉, 데이터 입력 오류가 있는 것 같은 항공편). 동일 목적지까지 가장 짧은 비행을 기준으로, 상대 비행 시간을 계산하라. 어떤 항공편이 비행 중 가장 지연되었는가?

# 짧은 비행 : air_time
# 항공편명 : flight
# 목적지 : dest
air <- flights %>%
  filter(!is.na(air_time)) %>%
  group_by(dest, flight) %>%
  summarise(
    min_air = min(air_time),  
    max_air = max(air_time),
    sd_air = sd(air_time),
    n=n()
    )  

# 의심스럽게 빠른 빠른 항공편, 짧은 비행
air %>% 
  arrange(min_air)  
# BDL     4368           20 


# 동일 목적지까지 가장 짧은 비행을 기준으로, 상대 비행 시간을 계산하라.
air %>% 
  mutate(
    relative = (max_air-min_air)/sd_air) %>%
  arrange(desc(relative))  
#어떤 항공편이 비행 중 가장 지연되었는가?
# DCA     2175      36     131   7.25   291     13.1



#7. 적어도 두 항공사 이상이 비행한 목적지를 모두 찾아라. 이 정보를 이용하여 항공사들의 순위를 매겨보자.

# 목적지별 항공사 수 
flights %>% 
  group_by(dest) %>% 
  summarise(
    n=n(),  # 목적지별 총 비행수 
    carriers = n_distinct(carrier)  # 목적지별 운항한 항공사수.
  ) %>% 
  # 적어도 두 항공사 이상이 비행한 목적지
  filter(carriers>=2) %>%  
  arrange(desc(n))
# ORD   17283        7

# 항공사별 목적지 수 
# 항공사 : carrier
flights %>% 
  group_by(carrier) %>% 
  summarise(
    n=n(),  # 항공사별 총 비행수 
    n_dest = n_distinct(dest)  # 항공사가 운항한 목적지수...
  ) %>% 
  mutate(r=min_rank(desc(n_dest))) %>% 
  arrange(r) # 목적지 기준 항공사들의 순위
# EV      54173     61     1


#8. 각 항공기에 대해 처음으로 1시간 이상 지연 이전의 비행 횟수를 카운트하라.

# 항공기 : tailnum
flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>% 
  mutate(
    delay = arr_delay + dep_delay,
    delay2 = ifelse(delay < 60, 1, 2),
    .after = day) %>% 
  group_by(tailnum, delay2) %>% 
  summarise(
    mean_delay=mean(delay),
    n=n()
  ) %>% #1시간 이상 지연 이전의 비행 횟수만
  filter(delay2==1)  

  
