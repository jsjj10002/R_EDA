library(tidyverse)
library(tidyr)

tidyr::table1
#country(국가), year(연도), population(인구) 및 cases(사례)

table1
table2
table3

#티블 두개로 펼쳐짐.
table4a  # 사례수
table4b  # 인구수


# 10,000명 당 비율 계산
table1 %>% 
  mutate(rate = cases / population * 10000)

# 연간 사례수 계산
table1 %>% 
  count(year, wt = cases)

# 시간에 따른 변화 시각화 
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000))

#### 더 길게 만들기 : longer
table4a

#pivot_longer() 호출
table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

#table4 을 더 긴 타이티 형태로 피봇팅하기
table4a %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "cases"
  ) %>%
  mutate(year = parse_integer(year))

#셀 값에 저장된 변수만 다름 
table4b %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "population"
  ) %>%
  mutate(year = parse_integer(year))


# table4a 와 table4b을 하나의 티블로 결합?
# dplyr::left_join() 
tidy4a <- table4b %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "cases"
  ) %>%
  mutate(year = parse_integer(year))
tidy4b <- table4b %>%
  pivot_longer(
    cols = c(`1999`, `2000`),
    names_to = "year",
    values_to = "population"
  ) %>%
  mutate(year = parse_integer(year))
left_join(tidy4a, tidy4b)
#외부조인: 왼쪽데이터셋이 모든 관측값 보존


##더 넓게 만들기 : Wider
#pivot_longer() 의 반대

table2

table2 %>%
  pivot_wider(
    names_from = type,
    values_from = count)

table2 %>%
  pivot_wider(names_from = type, values_from = count) %>%
  mutate(rate = cases / population,
         rate2 = cases / population * 10000) # 앞의 예제와 동일, 10,000명 당 비율 계산


# 케이스 rate 을 시각화
#아프가니스탄, 브라질, 중국의 1999년과 2000년 발병률을 보여주며, 
# x축은 연도, 
# y축은 발병 건수
table2 %>%
  pivot_wider(names_from = type, values_from = count) %>%
  mutate(rate = cases / population) %>%
  ggplot(aes(x = year, y = rate)) +
  geom_line(aes(group = country), colour = "grey50") +
  geom_point(aes(colour = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000))

#피봇 함수를 한 번에 여러 열에 동작 시킬수 있다는 장점
table2 %>%
  pivot_wider(
    names_from = type, 
    values_from = count) %>%
  mutate(rate = cases / population) %>%
  #다른 pivot_wider() 단계를 추가
  pivot_wider(
    names_from = year,
    values_from = c(cases, population, rate)
  )

table2 %>%
  pivot_wider(names_from = type, values_from = count) %>%
  mutate(rate = cases / population) %>%
  pivot_wider(
    names_from = year,
    values_from = c(cases, population, rate)
  ) %>%
  relocate(country, contains("1999"))

###separate()로 분리하기
#separate()는 구분문자가 나타나는 곳마다 쪼개서 # 하나의 열을 여러 열로 분리
table3

table3 %>%
  separate(rate, into = c("cases", "population"))

#특정 문자를 사용하여 열을 구분하기
#디폴트는 열의 유형을 그대로 유지
# 유형이 문자형열
table3 %>%
  separate(rate, 
           into = c("cases", "population"), 
           sep = "/")


#convert = TRUE, separate()이 더 나은 유형으로 변형
table3 %>%
  separate(
    rate, into = c("cases", "population"),
    convert = TRUE
  )

table3 %>%
  separate(year, into =c("century", "year"), sep = 2)

##Unite()로 결합하기
#separate()의 반대, 여러 열을 하나의 열로 결합
#합친 열의 값 사이에 언더바(_)
tidyr::table5

table5 %>%
  unite(new, century, year)

#필요하지 않으면 sep에 ""추가 
table5 %>%
  unite(new, century, year, sep ="")

## 기본 설정: 언더바 _
table5 %>%
  unite(new, century, year, sep ="_")

##결측값
stocks <- tibble(
  year = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

#연도를 열로 넣어 결측값을 명시적
stocks %>%
  pivot_wider(names_from = year, values_from = return)

## spread = pivot_wider() 동일
stocks %>%
  spread(year, return)


stocks %>%
  pivot_wider(names_from = year, values_from = return) %>%
  pivot_longer(
    cols = c('2015', '2016'),
    names_to = "year", 
    values_to = "return",
    values_drop_na = TRUE)


## gather = pivot_longer() 동일
## spread = pivot_wider() 동일
## gather(열집합, 열이름, 셀값)
stocks %>%
  spread(year, return) %>%
  gather('2015':'2016', 
         key = year, 
         value = return,  
         na.rm = TRUE)
# gather()+ na.rm = TRUE를 설정
# 암묵적 결측값으로 변경


#complete()
#결측값을 명시적 NA를 채운다
stocks %>%
  complete(year, qtr)

#fill()은 결측치를 가장 최근의 비결측값으로 채운다
treatment <- tribble(
  ~ person,           ~treatment, ~response,
  "Derrick Whitmore", 1,          7,        
  NA,                 2,          10,
  NA,                 3,          9,
  "Katherine Burke",  1,          4
)


treatment %>%
  fill(person)


## 9.6 사례연구
tidyr::who

##변수가 아닌 열을 모으는 것으로 시작
who1 <- who %>%
  pivot_longer(
    cols =  new_sp_m014:newrel_f65, 
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  )
who1

who1 <- who %>%
  gather(
    new_sp_m014:newrel_f65, 
    key = "key",
    value = "cases",
    na.rm = TRUE
  )
who1

#새로운 key 열의 값을 세어서 값의 구조에 대한 힌트
who1 %>%
  count(key)

## str_replace : 일치하는 문자를 변경.. 
# str_replace("ba_nana", "_","") 
who2 <- who1 %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2


#key열의 값을 사례유형, 결핵유형, 성별나이로 분리
who3 <- who2 %>%
  separate(key, c("new", "type", "sexage"), sep ="_")
who3

who3 %>%
  count(new)

## 불필요한 변수 삭제하기
who4 <- who3 %>%
  select(-new, -iso2, -iso3)


#마지막으로 sexage(성별나이) 열을 성별, 나이로 분리
who5 <- who4 %>%
  separate(sexage, c("sex", "age"), sep = 1) # 한글자이니까 sep = 1  
who5

## who 데이터셋은 타이디
## 한꺼번에 정리됨.
who %>%
  pivot_longer(
    cols =  new_sp_m014:newrel_f65, 
    names_to = "key",
    values_to = "cases",
    values_drop_na = TRUE
  ) %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel")) %>%
  separate(key, c("new", "type", "sexage"), sep ="_") %>%
  select(-new, -iso2, -iso3) %>%
  separate(sexage, c("sex", "age"), sep = 1)
