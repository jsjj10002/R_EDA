library(tidyverse)
library(readr)
library(readxl)
 
 
### 깃허브에서 데이터 받기 
### <https://github.com/hadley/r4ds/tree/master/data> heights.csv 
### 데이터를 받을 수 있는 깃허브
setwd("E:/3. My lecture note/EDA/데이터/")
heights <-read_csv("heights.csv")


#첫 번째 줄을 열 이름
read_csv("a,b,c  
         1,2,3
         4,5,6")

# 앞 부분에 메타 데이터
read_csv("메타 데이터 첫 번째 행
메타 데이터 두 번째 행
         x,y,z
         1,2,3", skip = 2)

read_csv("# 건너뛰고 싶은 주석
         x,y,z
         1,2,3", comment = "#")

#첫 번째 줄을 열 이름없을 경우..
# col_names = FALSE 옵션
read_csv("1,2,3\n4,5,6", col_names = FALSE)


# col_names =열 이름 문자형 백터 사용
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

## 설명 : fileEncoding = "euc-kr"
## https://zepettoworld.tistory.com/24
#### 8.2.2 연습문제
read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b,c\n1;3")


## 8.3 백터 파싱하기

#논리형
str(parse_logical(c("TRUE", "FALSE", "NA")))

#정수형
str(parse_integer(c("1", "2", "3")))

#날짜형
str(parse_date(c("2010-01-01", "1979-10-14")))

## parse_integer(문자형)
## 결측이 있다면 표기: na = "."
parse_integer(c("1", "231", ".", "456"), na = ".")


x <- parse_integer(c("123,", "345", "abc", "123.45" ))
x


### 숫자 파싱
# 소수점으로 사용하는 문자
# parse_double +  locale(decimal_mark = ",")
parse_double("1.23")

## decimal_mark = ","
parse_double("1,23", locale = locale(decimal_mark = ","))


## 숫자만 파싱: 문자 무시
# parse_number
parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")


# 미주방식
parse_number("$123,456,789")


#유럽의 많은 국가 방식
parse_number(
  "123.456.789",
  locale = locale(grouping_mark = ".")
)

#스위스 방식
parse_number(
  "123'456'789",
  locale = locale(grouping_mark = "'")
)

### 8.3.2 문자열
charToRaw("Hadley")
x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

x1
x2

#locale = locale(encoding = "latin1")
parse_character(x1, locale = locale(encoding = "latin1"))

#locale = locale(encoding = "shift-JIS")
parse_character(x2, locale = locale(encoding = "shift-JIS"))


guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))


### 8.3.3 팩터형
fruit <- c("apple", "banana")

parse_factor(c("apple", "banana", "bananana"), levels = fruit)

### 8.3.4 데이트형, 데이트-타임형, 타임형
parse_datetime("2010-10-01T2010")

# 시간이 생략된 경우엔 자정으로 설정됨.
parse_datetime("20101010")

parse_date("2010-10-01")

library(hms)
parse_time("01:10 am")

parse_time("20:10:01")

parse_date("01/02/15", "%m/%d/%y")
datetime <- parse_date("01/02/15", "%m/%d/%y")
### 13장. 13.3.1 구성요소 불러오기에서 다시...
year(datetime)
month(datetime)
day(datetime)

parse_date("01/02/15", "%d/%m/%y")

parse_date("01/02/15", "%y/%m/%d")

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

## 8.4 파일 파싱하기
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))
str(parse_guess("2010-10-10"))

### 8.4.2 문제점
# challenge.csv : ~~ R/win-library/4.0/readr/저장된 데이터임..
challenge <- read_csv(readr_example("challenge.csv"))

problems(challenge)

tail(challenge)


challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_integer(),  #정수값
    y = col_character()
  )
)
challenge
problems(challenge)


library(readr)
challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),   #더블형 파서
    y = col_character()
  )
)
challenge

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()    # 데이트형
  )
)
tail(challenge)


### 8.4.3 기타 전략

challenge2 <- read_csv(
  readr_example("challenge.csv"),
  guess_max = 1001  # 기본값=1000
)
challenge2

challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(.default = col_character())
  )
challenge

df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)

# 열 유형에 주의 
type_convert(df)

## 8.5 파일에 쓰기

setwd("E:/3. My lecture note/EDA/데이터/")
write_csv(challenge, "challenge.csv")

write_csv(challenge, "challenge_2.csv")  ## 쓰기
read_csv("challenge_2.csv")              ## 불러오기

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")


#install.packages("feather")
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challeng.feather")

