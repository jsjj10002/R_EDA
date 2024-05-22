library(tidyverse)
library(forcats)


## 12.2 팩터형 생성하기

x1 <- c("Dec", "Apr", "Jan", "Mar")

# 오타가 있는 경우 
x2 <- c("Dec", "Apr", "Jam", "Mar")
x2

sort(x1)

## 먼저 유효레벨 리스트 생성
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

x1
# 리스트에 값이 있는 경우 출력.
y1 <- factor(x1, levels = month_levels)
y1

## 팩터형(수치값)으로 정렬. 
# decreasing = FALSE
sort(y1)  # 디폴트: 오름차순

x2
# 리스트에 값이 없는 경우 NA 출력.
y2 <- factor(x2, levels = month_levels)
y2

# 경고를 발생시키고 싶으면?
y2 <- parse_factor(x2, levels = month_levels) 

## 알파벳 순서
factor(x1)
factor(x2)


# levels = unique(x1) 
f1 <- factor(x1, levels = unique(x1))
f1 

# fct_inorder(): 입력 순서대로 
f2 <- x1 %>% 
  factor() %>% 
  fct_inorder()
f2 

# levels()
levels(f2)


## 12.3 종합사회조사
gss_cat 


# 티블데이터셋에서 팩터형 레벨 보려면? 
# count()
gss_cat %>%
  count(race)

gss_cat %>% 
  ggplot(aes(race)) +
  geom_bar()


## ?scale_x_discrete()
# 디폴트는 drop = TRUE
## drop = FALSE 인수 설정.
gss_cat %>% 
  ggplot(aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)


## 12.4 팩터 순서 수정하기
# 종교에 따른 하루 TV 시청시간의 평균
# relig: fct
# age, tvhours : int

relig_summary <- gss_cat %>%
  group_by(relig) %>%  # 종교별
  summarise(
    age = mean(age, na.rm = TRUE),  
    tvhours = mean(tvhours, na.rm = TRUE), # 하루 TV 시청시간의 평균
    n = n()
  )
relig_summary

relig_summary %>% 
  ggplot(
    aes(tvhours, relig)) +
  geom_point()


## 팩터 레벨을 재정렬
## aes(  , fct_reorder() ) 
# fct_reorder() : 오름차순 디폴트
relig_summary %>% 
  ggplot(
    aes(tvhours,fct_reorder(relig, tvhours))) +
  geom_point()

# fct_reorder(  , .desc=T) : 내림차순 
relig_summary %>% 
  ggplot(
    aes(tvhours,fct_reorder(relig, tvhours, .desc=T))) +
  geom_point()

## 별도의 mutate()로 변환
relig_summary %>%
  mutate(
    relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()


rincome_summary <- gss_cat %>%
  group_by(rincome) %>%            #소득 레벨별
  summarise(
    age = mean(age, na.rm = TRUE),  # 평균 나이
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
rincome_summary


#fct_reorder
rincome_summary %>% 
  ggplot( 
    aes(age, fct_reorder(rincome, age))) + 
  geom_point()



rincome_summary %>%
  ggplot(
    aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()


## 나이별 결혼여부 비율 
by_age <- gss_cat %>%
  filter(!is.na(age)) %>% 
  count(age, marital) %>% 
  group_by(age) %>%
  mutate(prop = n / sum(n))

by_age

# 결혼상태별로 구분된 나이 분포 
by_age %>% 
  ggplot(
    aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)


# 가장 큰 X값(=가장 큰 나이 값)에 Y값으로 팩터형을 재정렬함.
# aes( colour = fct_reorder2(marital, age, prop))
by_age %>% 
  ggplot(
    aes(age, prop, 
        colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")

# fct_infreq() + fct_rev(): 빈도 오름차순으로
# 결혼상태의 빈도 기준으로 오름차순 정렬.
# fct_infreq() 디폴트: 내림차순
by_marital <- gss_cat %>%
  mutate(
    marital = marital %>%
      fct_infreq() %>% 
      fct_rev() # 오름차순 
  )
by_marital

by_marital %>%
  ggplot(aes(marital)) +
  geom_bar()

# 내림차순 정렬
by_marital2 <- gss_cat %>%
  mutate(
    marital = marital %>%
      fct_infreq() 
  )

by_marital2 %>%
  ggplot(aes(marital)) +
  geom_bar()


## 12.5 팩터 레벨 수정하기


gss_cat %>% count(partyid)

## 레벨 이름 다시 만들고
## 1~10으로 갈수록, 무응답이 맨앞.. 그 외 공화당에서 민주당으로 
gss_cat %>%
  mutate(
    partyid = fct_recode(partyid,
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat"
    )) %>%
  count(partyid)


# 일부 그룹(레벨) 결합.
# "No answer" + "Don't know" + "Other party" == "Other" 로 결합.
gss_cat %>%
  mutate(
    partyid = fct_recode(partyid,
                         "Republican, strong"    = "Strong republican",
                         "Republican, weak"      = "Not str republican",
                         "Independent, near rep" = "Ind,near rep",
                         "Independent, near dem" = "Ind,near dem",
                         "Democrat, weak"        = "Not str democrat",
                         "Democrat, strong"      = "Strong democrat",
                         "Other"                 = "No answer",
                         "Other"                 = "Don't know",
                         "Other"                 = "Other party"
    )) %>%
  count(partyid)


# 다수의 레벨 결합.
gss_cat %>%
  mutate(
    partyid = fct_collapse(partyid,
                           other = c("No answer", "Don't know", "Other party"),
                           rep = c("Strong republican", "Not str republican"),
                           ind = c("Ind,near rep", "Independent", "Ind,near dem"),
                           dem = c("Not str democrat", "Strong democrat")
    )) %>%
  count(partyid)



gss_cat %>% 
  count(relig)

gss_cat %>%
  mutate(
    relig = fct_lump(relig)) %>%
  count(relig)


## fct_lump(n =  ) : 유지하고 싶은 그룹 개수(other 제외)를 지정
gss_cat %>%
  mutate(
    relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)

