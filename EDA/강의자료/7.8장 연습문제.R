#1. 강의교재 7장 강의안  연습문제 7.4.1의 #4번

#4. 다음의 데이터프레임에서 비구문론적 이름을 참조하는 방법을 연습해보라. 
library(tidyverse)

annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length('1'))
)
annoying

#a. 1이라는 이름의 열변수를 추출하기.

annoying[["1"]]
annoying$`1`

#b. 1 vs 2 의 산점도를 플롯팅 하기.

annoying %>% 
  ggplot(aes(x = `1`, y = `2`)) +
  geom_point()

#c. 열 2 를 열 1 로 나누어, 3 이라는 새로운 열을 생성하기.
annoying %>% 
  mutate(`3` = `2` / `1`)

annoying$'3' <- annoying$`2` / annoying$`1`
annoying$'3'
annoying[["3"]] <- annoying[["2"]] / annoying[["1"]]
annoying[["3"]]

#d. 열의 이름을 one, two, three 로 변경하기
 
tibble::enframe
enframe(list(one = 1, two = 2:3, three = 4:6))

annoying %>% 
  rename(one = `1`, two = `2`, three = `3`)
 

#2. 강의교재 8장 강의안  연습문제 8.2.2의 #5번 

#5. 다음 각 인라인 csv파일에 어떤 문제가 있는지 확인하라. 코드를 실행하면 어떻게 되는가??  
 
read_csv("a,b\n1,2,3\n4,5,6")
# 열변수 이름은 2개
# 관측값은 3개의 열
## 첫,두번째 열 2번째+3번째 관측값 하나로 인식됨. 

read_csv("a,b,c\n1,2\n1,2,3,4")
# 열변수 이름은 3개
# 관측값은 2개의 열, 4개 열...
## 첫번째 열 2번째 관측값까지 읽고 결측
## 두번째 열 3번째+4번째 관측값 하나로 인식됨. 

read_csv("a,b\n\1", na = ".")
# 열변수 이름은 2개
# 관측값은 \1인 열 1개, 
# "\"표현은 정규표현식에서 문자열을 구분할때 사용되는 표현임. 
# 에러~~~ 

read_csv("a,b\n1,2\na,b")
# 열변수 이름은 2개
# 관측값은 2개의 열 
## 첫번째 열 숫자형
## 두번째 열 문자열==> 모두 문자형 벡터로 처리됨. 
# A tibble: 2 x 2
#a     b    
#<chr> <chr>
#1 1     2    
#2 a     b  

read_csv("a;b,c\n1;3")
# 열변수 이름은 "쉼표"가 아닌 ;(세미콜론)를 기준으로 하면 2개임.
# 관측값은 2개의 열 
# read_csv() 대신 read_csv2()로 가능
read_csv2("a;b,c\n1;3")  
# A tibble: 1 x 2
#     a `b,c`
#   <dbl> <dbl>
#1    1     3


### 결론))) 타이디데이터로 만들기 위해서는? 
#변수의 수와 관측치의 수가 일치해야 함.

#3. 강의교재 8장 강의안  연습문제 8.3.5의 #7번 
#7. 올바른 형식 문자열을 생성하여 다음 날짜와 시간을 파싱하라.

d1 <- "January 1, 2010"
parse_date(d1, "%B %d, %Y")

d2 <- "2015-Mar-07"
parse_date(d2, "%Y-%b-%d")

d3 <- "06-Jun-2017"
parse_date(d3, "%d-%b-%Y")

d4 <- c("August 19 (2015)", "July 1 (2015)")
parse_date(d4, "%B %d (%Y)")

d5 <- "12/30/14" # Dec 30, 2014
parse_date(d5, "%m/%d/%y")

t1 <- "1705"
parse_time(t1, "%H%M")

t2 <- "11:15:10.12 PM"
parse_time(t2, "%I:%M:%OS %p") 

d1; d2; d3; d4_1; d5; t1; t2
 

