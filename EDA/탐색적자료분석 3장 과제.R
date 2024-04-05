library(tidyverse)
#install.packages("nycflights13")
library(nycflights13)

?flights
flights
view(flights)
### a 2시간 이상 도착 지연
flights %>%
    filter(arr_delay >= 120)
    
### b 휴스턴 (IAH 혹은 HOU) 으로 운항항
flights %>% 
    filter((dest == "IAH")|(dest == "HOU"))

flights %>% 
    filter(dest %in% c("IAH","HOU"))


airlines
flights %>% 
    filter(carrier %in% c("DL", "UA", "AA"))
