source("~/GitHub/Ethiopia/R/loadETHpanel.r")

# Colors ------------------------------------------------------------------
colorsH = c(colorRampPalette(brewer.pal(9, "PuRd"))(12), "grey")
colorsW = c(colorRampPalette(brewer.pal(9, "YlOrBr"))(12), "grey")
colorsP = c(colorRampPalette(brewer.pal(9, "Greens"))(12), "grey")
colorsA = c(colorRampPalette(brewer.pal(9, "PuBu"))(12), "grey")



# price shock regressions -------------------------------------------------



prShkRegrPlot = function (data,
                          vars = c('educAdultF','wealthIndex', 'marriedHoh')){
  
  data = data %>% 
    mutate(educAdultFcat = 
             ifelse(educAdultF == 0, 'no education',
                    ifelse(educAdultF == 1, 'pre-primary',
                           ifelse(educAdultF == 2, 'lower primary',
                                  ifelse(educAdultF == 3, 'primary',
                                         ifelse(educAdultF == 4, 'lower secondary',
                                                ifelse(educAdultF == 5, 'secondary',
                                                       ifelse(educAdultF == 6, 'tertiary', NA
                                   ))))))),
           marriedHohcat = 
             (ifelse(marriedHoh == 0, 'not married',
                     ifelse(marriedHoh == 1, 'married', NA))))
  
  prAvgEdu = data %>% 
    group_by(educAdultFcat) %>% 
    summarise(avg = mean(priceShk), num = n(), sd = sd(priceShk)) %>% 
    mutate(categ = educAdultFcat, type = 'education level') %>% 
    filter(!is.na(educAdultFcat)) %>% 
    select(-educAdultFcat)

  
  prAvgMarr = data %>% 
    group_by(marriedHohcat) %>% 
    summarise(avg = mean(priceShk), num = n(), sd = sd(priceShk)) %>% 
    filter(!is.na(marriedHohcat)) %>% 
    mutate(categ = marriedHohcat, type = 'marital status') %>% 
    select(-marriedHohcat)
  
  prAvgWealth = data %>% 
    group_by(wlthSmooth) %>% 
    summarise(avg = mean(priceShk), num = n(), sd = sd(priceShk)) %>% 
    filter(!is.na(wlthSmooth)) %>% 
    mutate(categ = wlthSmooth, type = 'wealth') %>% 
    select(-wlthSmooth)
  
  prAvg = rbind(prAvgEdu, data.frame(categ = "", avg = NA, sd = NA, num = NA, type = NA), prAvgWealth, 
                data.frame(categ = " ", avg = NA, sd = NA, num = NA, type = NA), prAvgMarr)
  
  prAvg$categ = factor(prAvg$categ,
                               c('no education',
                                 'pre-primary',
                                 'lower primary',
                                 'primary', 
                                 'lower secondary',
                                 'secondary', 
                                 'tertiary',
                                 '',
                                 1:10, " ",
                                 'married',
                                 'not married'))
  
  avgPriceShk = mean(data$priceShk)


  
  ggplot(data = prAvg) +
#     geom_linerange(aes(x = categ, ymin = avg - sd, ymax = avg + sd),
#                    size = 2, colour = colorsP[10], alpha  = 0.2)+
#     geom_path(aes(x = categ, y = avg, group = type), size = 8, shape = 15,
#                    colour = colorsP[10]) +
    geom_hline(yint = avgPriceShk,
               color = '#878787', size = 0.75, linetype = 2) +
    geom_point(aes(x = categ, y = avg, group = type, size = num), #shape = 15,
              colour = colorsP[10]) +
        annotate('rect', xmin = 0, xmax = 21.5, ymin = avgPriceShk, ymax = 1, 
                 fill = colorsP[5], alpha = 0.2) +
    annotate('rect', xmin = 0, xmax = 21.5, ymin = 0, ymax = 1, 
             fill = colorsP[5], alpha = 0.2) +

    scale_size(limits = c(10, 5600), range = c(4,20)) +
    coord_cartesian(ylim = c(0,0.6)) +
    theme_classicLH()
}

# size by nObs?  Str. correl?  color by str?