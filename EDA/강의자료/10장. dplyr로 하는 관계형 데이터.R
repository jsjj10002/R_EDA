#10장. dplyr로 하는 관계형 데이터

library(tidyverse)
library(nycflights13) # 실습에서 사용할 테이블


#10.2 nycflights13
nycflights13::flights %>%
  print(n = 6, width = Inf)

airlines # 약어 코드로 전체 항공사명 조회됨

nycflights13::airports %>% # 각 공항 정보가 faa 공항 코드로 식별됨
  print(n = 10, width = Inf)


nycflights13::planes %>% # 각 여객기 정보가 tailnum으로 식별됨
  print(n = 10, width = Inf)


nycflights13::weather %>% # 각 NYC 공항의 매 시각 날씨 정보
  print(n = 6, width = Inf)


#10.3 KEY

planes %>%
  count(tailnum) %>%
  filter(n > 1)

weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)

#추가 테이블에 명시적인 기본키가 없는 경우도 있음

flights %>%
  count(year, month, day, flight) %>%
  filter(n > 1)

flights %>%
  count(year, month, day, tailnum) %>%
  filter(n > 1)

#10.4 뮤테이팅 조인

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

#left_join()으로 airlines와 flights2 데이터프레임 결합 가능
flights2 %>%
  select(-origin, -dest) %>%
  
  
#10.4.1 조인 이해하기

x <- tribble(~key, ~val_x,
               1, "x1",
               2, "x2",
               3, "x3")
y <- tribble(~key, ~val_y,
             1, "y1",
             2, "y2",
             4, "y3")

x

#10.4.4 중복키
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4")
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2")
left_join(x, y, by = "key")
  left_join(airlines, by = "carrier")

  
y <- tribble(
    ~key, ~val_y,
    1, "y1",
    2, "y2",
    2, "y3",
    1, "y4")
  left_join(x, y, by = "key")
  
#10.4.5 키 열 정의하기
  
flights2 %>%
    left_join(weather) %>%
    print(n = 6, width = Inf)

#문자형 벡터 by = “x” 사용하기
flights2 %>%
  left_join(planes, by = "tailnum") %>%
  print(n = 6, width = Inf)
  
#10.5 필터링 조인
top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

#목적지 중 한 곳으로 운행한 항공편을 찾는 방법: 필터 만들기

flights %>%
  filter(dest %in% top_dest$dest) %>%
  print(n = 6, width = Inf)

#semi_join을 사용하는 방법
flights %>%
  semi_join(top_dest) %>%
  print(n = 6, width = Inf)

#항공편과 여객기를 연결하는 경우, 여객기에 매칭되지 않는 항공편이 많음을 알고 싶을 수 있음
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)


#10.6 조인 문제
airports %>% count(alt, lon) %>% filter(n > 1)


#10.7 집합 연산
df1 <- tribble(
  ~x, ~y,
  1, 1,
  2, 1)
df2 <- tribble(
  ~x, ~y,
  1, 1,
  1, 2)

intersect(df1, df2) #행이 3개로 나옴!

union(df1, df2)

setdiff(df1, df2)