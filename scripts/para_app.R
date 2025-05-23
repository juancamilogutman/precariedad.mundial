library(tidyverse)
base <- readRDS("base_homogenea.RDS")

vector_categoricas <- c("SEXO","SECTOR","EDUC","TAMA","CALIF") }
proporciones_empleo <- data.frame()
for (variable in vector_categoricas) {
  
  peso_categoria <- base %>% 
    filter(!is.na(.data[[variable]])) %>% 
    group_by(PAIS,categoria = .data[[variable]]) %>% 
    summarise(casos_pond = sum(WEIGHT,na.rm = T)) %>% 
    mutate(variable_interes = variable) %>% 
    group_by(PAIS) %>% 
    mutate(particip.ocup= casos_pond/sum(casos_pond))
  
  proporciones_empleo <- bind_rows(proporciones_empleo,peso_categoria) 
}
options(scipen = 999)
