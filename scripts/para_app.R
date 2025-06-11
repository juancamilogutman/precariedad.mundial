#Importacion ####
library(tidyverse)
base <- readRDS("base_homogenea.RDS")
options(scipen = 999)

#Chequeos ####
#table(base$CATOCUP,base$TAMA)
#table(base$CATOCUP,base$CALIF)

#Definiciones ####
vector_categoricas <- c("SEXO","SECTOR","EDUC","TAMA","CALIF") 

niveles <- c("Mujer","Varon","Priv","Pub","SD","Resto",
             "Primaria","Secundaria","Terciaria",
             "Pequeño","Mediano","Grande",
             "Baja","Media","Alta")

#Distrib del empleo ####
proporciones_empleo <- data.frame()
for (variable in vector_categoricas) {
  
  peso_categoria <- base %>% 
    filter(!is.na(.data[[variable]]),
           .data[[variable]] != "Ns/Nc") %>% 
    group_by(PAIS,categoria = .data[[variable]]) %>% 
    summarise(casos_pond = sum(WEIGHT,na.rm = T)) %>% 
    mutate(variable_interes = variable) %>% 
    group_by(PAIS) %>% 
    mutate(particip.ocup= casos_pond/sum(casos_pond))
  
  proporciones_empleo <- bind_rows(proporciones_empleo,peso_categoria) 
}


proporciones_empleo <- proporciones_empleo %>% 
  mutate(categoria = factor(categoria,
                               levels = niveles,
                               )) %>% 
  arrange(PAIS,categoria)
write_csv(proporciones_empleo,"app/data/pesos_categoria.csv")

combinations <- combn(vector_categoricas, 2, simplify = FALSE)
proporciones_empleo_2 <- data.frame()   
##Doble categoria ####

for (combo in combinations) {
  # Combo contains the pair of variables to group by
  variable1 <- combo[1]
  variable2 <- combo[2]
  
  peso_categoria <- base %>%
    filter(!is.na(.data[[variable1]]) , !is.na(.data[[variable2]]),
           .data[[variable1]] != "Ns/Nc",.data[[variable2]] != "Ns/Nc") %>% 
    group_by(PAIS, categoria1 = .data[[variable1]], categoria2 = .data[[variable2]]) %>% 
    summarise(casos_pond = sum(WEIGHT, na.rm = TRUE)) %>% 
    mutate(variable_interes = paste(variable1, variable2, sep = "-")) %>% 
    group_by(PAIS) %>% 
    mutate(particip.ocup = casos_pond / sum(casos_pond))
  
  # Bind the results to the main data frame
  proporciones_empleo_2 <- bind_rows(proporciones_empleo_2, peso_categoria)
}
proporciones_empleo_2<- proporciones_empleo_2 %>% 
  mutate(categoria1 = factor(categoria1,levels = niveles),
         categoria2 = factor(categoria2,levels = niveles)
  ) %>% 
  arrange(PAIS,categoria1,categoria2) %>% 
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

#Salarios ####
salarios_arg <- base %>% 
  filter(CATOCUP == "Asalariado",ING_PPA>0,PAIS == "Argentina") %>% 
  group_by(PAIS,ANO,PERIODO) %>% 
  summarise(sal_prom =weighted.mean(ING_PPA,WEIGHT_W,na.rm = T),
            sal_median = median(ING_PPA)) 
salarios_resto <- base %>% 
  filter(CATOCUP == "Asalariado",ING_PPA>0,PAIS != "Argentina") %>% 
  group_by(PAIS,ANO,PERIODO) %>% 
  summarise(sal_prom =weighted.mean(ING_PPA,WEIGHT,na.rm = T),
            sal_median = median(ING_PPA)) 

salarios <- bind_rows(salarios_arg,salarios_resto) %>% 
  group_by(PAIS,ANO) %>% 
  summarise(sal_prom = mean(sal_prom,na.rm = T),
            sal_median = mean(sal_median,na.rm = T),
            variable_interes = "Total",
            categoria = "Total")
salarios_categorias <- data.frame()
for (variable in vector_categoricas) {
  
  
  salarios_arg_cat <- base %>% 
    filter(CATOCUP == "Asalariado",ING_PPA>0,PAIS == "Argentina") %>% 
    filter(!is.na(.data[[variable]])) %>% 
    group_by(PAIS,ANO,PERIODO,categoria = .data[[variable]]) %>% 
    summarise(sal_prom =weighted.mean(ING_PPA,WEIGHT_W,na.rm = T),
              sal_median = median(ING_PPA)) 
  
  salarios_resto_cat <- base %>% 
    filter(CATOCUP == "Asalariado",ING_PPA>0,PAIS != "Argentina") %>% 
    filter(!is.na(.data[[variable]])) %>% 
    group_by(PAIS,ANO,PERIODO,categoria = .data[[variable]]) %>% 
    summarise(sal_prom =weighted.mean(ING_PPA,WEIGHT,na.rm = T),
              sal_median = median(ING_PPA)) 
  
  salarios_cat <- bind_rows(salarios_arg_cat,salarios_resto_cat) %>% 
    group_by(PAIS,ANO,categoria) %>% 
    summarise(sal_prom = mean(sal_prom,na.rm = T),
              sal_median = mean(sal_median,na.rm = T)) %>% 
    mutate(variable_interes = variable) 
  
  
  salarios_categorias <- bind_rows(salarios_cat,salarios_categorias) 
}
salarios_categs <- bind_rows(salarios_categorias,salarios)
write_csv(salarios_categs,"app/data/salarios_categoria.csv")
  

salarios_categorias2 <- data.frame()   
## Doble categoria ####
for (combo in combinations) {
  # Combo contains the pair of variables to group by
  variable1 <- combo[1]
  variable2 <- combo[2]
  
  salarios_arg_cat2 <- base %>%
    filter(!is.na(.data[[variable1]]) , !is.na(.data[[variable2]]),
           .data[[variable1]] != "Ns/Nc",.data[[variable2]] != "Ns/Nc") %>% 
    filter(CATOCUP == "Asalariado",ING_PPA>0,PAIS == "Argentina") %>% 
    group_by(PAIS,ANO,PERIODO,categoria1 = .data[[variable1]], categoria2 = .data[[variable2]]) %>% 
    summarise(sal_prom =weighted.mean(ING_PPA,WEIGHT_W,na.rm = T),
              sal_median = median(ING_PPA)) 
  
  salarios_resto_cat2 <- base %>% 
    filter(!is.na(.data[[variable1]]) , !is.na(.data[[variable2]]),
           .data[[variable1]] != "Ns/Nc",.data[[variable2]] != "Ns/Nc") %>% 
    filter(CATOCUP == "Asalariado",ING_PPA>0,PAIS != "Argentina") %>% 
    group_by(PAIS,ANO,PERIODO,categoria1 = .data[[variable1]], categoria2 = .data[[variable2]]) %>% 
    summarise(sal_prom =weighted.mean(ING_PPA,WEIGHT,na.rm = T),
              sal_median = median(ING_PPA)) 
  
  salarios_cat2 <- bind_rows(salarios_arg_cat2,salarios_resto_cat2) %>% 
    group_by(PAIS,ANO,categoria1,categoria2) %>% 
    summarise(sal_prom = mean(sal_prom,na.rm = T),
              sal_median = mean(sal_median,na.rm = T)) %>% 
    mutate(variable_interes = paste(variable1, variable2, sep = "-")) 
  
  
  salarios_categorias2 <- bind_rows(salarios_cat2,salarios_categorias2) 
  
  # Bind the results to the main data frame
}

salarios_categorias2<- salarios_categorias2 %>% 
  mutate(categoria1 = factor(categoria1,levels = niveles),
         categoria2 = factor(categoria2,levels = niveles)
  ) %>% 
  arrange(PAIS,categoria1,categoria2) %>% 
  mutate(categoria = paste(categoria1, categoria2, sep = "-")) 

write_csv(salarios_categorias2,"app/data/salarios_categoria2.csv")



