colorsURL <- "http://jaredlander.com/data/DiamondColors.csv"
diamondColors <- read_csv(colorsURL)
diamondColors

library(ggplot2)
diamonds
unique(diamonds$color)

# 왼쪽 조인.
# A tibble: 53,940 x 12
diamonds %>% 
  left_join(diamondColors, 
            by=c('color'="Color")) %>% 
  select(carat, color, price, Description, Details) %>% 
  count(color, Description) 
### Unique한 값만 보려면?
# distinct(color, Description)  


# 오른쪽 조인.
# A tibble: 53,943 x 12

diamonds %>% 
  right_join(diamondColors, 
            by=c('color'="Color")) %>% 
  nrow() 

diamonds %>% 
  right_join(diamondColors, 
             by=c('color'="Color")) %>% 
  select(carat, color, price, Description, Details) %>% 
  count(color, Description) 

# semi_조인.
## 일종의 행 필터 기능..
diamonds %>% 
  semi_join(diamondColors, 
             by=c('color'="Color"))
# A tibble: 53,940 x 12



