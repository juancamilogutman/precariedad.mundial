library(tidyverse)
base <- readRDS("base_homogenea.RDS")
options(scipen = 999)

table(base$CATOCUP,base$TAMA)
table(base$CATOCUP,base$CALIF)
vector_categoricas <- c("SEXO","SECTOR","EDUC","TAMA","CALIF") 
#Distrib del empleo ####
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
write_csv(proporciones_empleo,"app/data/pesos_categoria.csv")

combinations <- combn(vector_categoricas, 2, simplify = FALSE)
proporciones_empleo_2 <- data.frame()   

for (combo in combinations) {
  # Combo contains the pair of variables to group by
  variable1 <- combo[1]
  variable2 <- combo[2]
  
  peso_categoria <- base %>%
    filter(!is.na(.data[[variable1]]) & !is.na(.data[[variable2]])) %>% 
    group_by(PAIS, categoria1 = .data[[variable1]], categoria2 = .data[[variable2]]) %>% 
    summarise(casos_pond = sum(WEIGHT, na.rm = TRUE)) %>% 
    mutate(variable_interes = paste(variable1, variable2, sep = "-")) %>% 
    group_by(PAIS) %>% 
    mutate(particip_ocup = casos_pond / sum(casos_pond))
  
  # Bind the results to the main data frame
  proporciones_empleo_2 <- bind_rows(proporciones_empleo_2, peso_categoria)
}
proporciones_empleo_2<- proporciones_empleo_2 %>% 
  mutate(categoria = paste(categoria1, categoria2, sep = "-")) 
write_csv(proporciones_empleo_2,"app/data/pesos_categorias2.csv")

#Tasas precariedad ####

precariedad <- base %>% 
  filter(CATOCUP == "Asalariado") %>% 
  group_by(PAIS) %>% 
  summarise(
    variable_interes = "Total",
    categoria = "Total",
    tasa_part = sum(WEIGHT[PRECAPT==1],na.rm = T)/sum(WEIGHT[PRECAPT %in% 0:1],na.rm = T),
    tasa_seg = sum(WEIGHT[PRECASEG==1],na.rm = T)/sum(WEIGHT[PRECASEG %in% 0:1],na.rm = T),
    tasa_reg = sum(WEIGHT[PRECAREG==1],na.rm = T)/sum(WEIGHT[PRECAREG %in% 0:1],na.rm = T),
    tasa_temp = sum(WEIGHT[PRECATEMP==1],na.rm = T)/sum(WEIGHT[PRECATEMP %in% 0:1],na.rm = T)) 

##Por categorias ####

precariedad_categorias <- data.frame()
for (variable in vector_categoricas) {
  
  precariedad_categoria <- base %>% 
    filter(CATOCUP == "Asalariado") %>% 
    filter(!is.na(.data[[variable]])) %>% 
    group_by(PAIS,categoria = .data[[variable]])%>% 
    summarise(
      tasa_part = sum(WEIGHT[PRECAPT==1],na.rm = T)/sum(WEIGHT[PRECAPT %in% 0:1],na.rm = T),
      tasa_seg = sum(WEIGHT[PRECASEG==1],na.rm = T)/sum(WEIGHT[PRECASEG %in% 0:1],na.rm = T),
      tasa_reg = sum(WEIGHT[PRECAREG==1],na.rm = T)/sum(WEIGHT[PRECAREG %in% 0:1],na.rm = T),
      tasa_temp = sum(WEIGHT[PRECATEMP==1],na.rm = T)/sum(WEIGHT[PRECATEMP %in% 0:1],na.rm = T)) %>%  
  mutate(variable_interes = variable) 
    
  
  precariedad_categorias <- bind_rows(precariedad_categorias,precariedad_categoria) 
}

precariedad_categorias <- bind_rows(precariedad_categorias,precariedad)
write_csv(precariedad_categorias,"app/data/precariedad_categoria.csv")
