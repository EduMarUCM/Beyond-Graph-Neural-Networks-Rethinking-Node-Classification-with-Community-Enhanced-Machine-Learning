

###################################################
custom_vfold_cv_graph_features <- function(data, v = 10, repeats = 1, strata = NULL, breaks = 4, pool = 0.1, ...) {
  
#check_dots_empty()
  
set.seed(210389)
  
# Comprobamos el parámetro de estratificación
  
if (!missing(strata)) 
{
    strata <- tidyselect::vars_select(names(data), !!enquo(strata))
    if (length(strata) == 0) 
    strata <- NULL
}
  
#strata_check(strata, data)
#check_repeats(repeats)

# Si se hace solo una repetición, utilizamos vfold_splits
  
if (repeats == 1) 
{
  
  split_objs <- vfold_cv(data = data, v = v, strata = strata, breaks = breaks, pool = pool)
} 
else 
{
    # Comprobamos si el número de particiones es igual al número de filas
  
    if (v == nrow(data)) 
    {
      rlang::abort(glue::glue("Repeated resampling when `v` is {v} would create identical resamples"))
    }
  
    # Si hay más de una repetición, hacemos un bucle para generar las particiones
  
    for (i in 1:repeats) 
    {
      tmp <- vfold_cv(data = data, v = v, strata = strata, pool = pool)
      tmp$id2 <- tmp$id
      tmp$id <- paste0("Repeat", i)
      split_objs <- if (i == 1) {tmp} else {rbind(split_objs, tmp)}
    }
}

# Aplicamos la función louv_statistics_by_train_community a cada partición
  
split_objs$splits <- map(split_objs$splits, function(split) {
  
# Dividimos los datos en entrenamiento y validación
  
train_data <- analysis(split)

val_data <- assessment(split)
  
# Aplicamos la función louv_statistics_by_train_community
  
updated_data <- proporcion_comunidad(train_data, val_data, all = FALSE)
  
# Los índices de las observaciones en el conjunto de entrenamiento
# Los índices del conjunto de entrenamiento
  
id_in <-  as.integer(row.names(updated_data$Train) )
  
# Los índices de las observaciones en el conjunto de validación (siempre a NA)
  
id_out <- NA  # Los valores de validación siempre serán NA
  
# Creamos el dataframe `id` con las columnas "id" y "id2"

id_df <- data.frame(
                    id = rep(paste0("Repeat", split$id), length(id_in)),  # Identificador de repetición
                    id2 = rep(paste0("Fold", split$index), length(id_in))  # Identificador de fold
                    )
  
# Creamos un objeto `rsplit` con los nuevos elementos

rsplit_obj <- structure(
                          list(
                                #analysis = updated_data$Train, 
                                #assessment = updated_data$Validation, 
                                data = rbind(updated_data$Train,updated_data$Validation),
                                
                                in_id = id_in,  # Identificadores de entrenamiento
                                out_id = id_out,  # Identificadores de validación (siempre NA)
                                id = id_df # Almacenamos el dataframe con "id" e "id2"
                              ), class = "rsplit"
                      )
  
# Devolvemos el objeto `rsplit` modificado

rsplit_obj
})

# Limpiamos las particiones para que el objeto final sea compatible con el tipo "vfold_cv"

if (!is.null(strata)) 
names(strata) <- NULL

# Preparamos los atributos y devolvemos el objeto final con el mismo formato que vfold_cv

cv_att <- list(v = v, repeats = repeats, strata = strata, breaks = breaks, pool = pool)

# Devolvemos el objeto rset con la nueva estructura

new_rset(splits = split_objs$splits, 
         ids = split_objs[, grepl("^id", names(split_objs))], 
         attrib = cv_att, 
         subclass = c("vfold_cv", "rset"))
}


#---------------------------------------------------------------------------



###################################################
custom_vfold_cv_all_features <- function(data, v = 10, repeats = 1, strata = NULL, breaks = 4, pool = 0.1, ...) {
  
  #check_dots_empty()
  
  set.seed(210389)
  
  # Comprobamos el parámetro de estratificación
  
  if (!missing(strata)) 
  {
    strata <- tidyselect::vars_select(names(data), !!enquo(strata))
    if (length(strata) == 0) 
      strata <- NULL
  }
  
  #strata_check(strata, data)
  #check_repeats(repeats)
  
  # Si se hace solo una repetición, utilizamos vfold_splits
  
  if (repeats == 1) 
  {
    
    split_objs <- vfold_cv(data = data, v = v, strata = strata, breaks = breaks, pool = pool)
  } 
  else 
  {
    # Comprobamos si el número de particiones es igual al número de filas
    
    if (v == nrow(data)) 
    {
      rlang::abort(glue::glue("Repeated resampling when `v` is {v} would create identical resamples"))
    }
    
    # Si hay más de una repetición, hacemos un bucle para generar las particiones
    
    for (i in 1:repeats) 
    {
      tmp <- vfold_cv(data = data, v = v, strata = strata, pool = pool)
      tmp$id2 <- tmp$id
      tmp$id <- paste0("Repeat", i)
      split_objs <- if (i == 1) {tmp} else {rbind(split_objs, tmp)}
    }
  }
  
  # Aplicamos la función louv_statistics_by_train_community a cada partición
  
  split_objs$splits <- map(split_objs$splits, function(split) {
    
    # Dividimos los datos en entrenamiento y validación
    
    train_data <- analysis(split)
    
    val_data <- assessment(split)
    
    # Aplicamos la función louv_statistics_by_train_community
    
    updated_data <- proporcion_comunidad(train_data, val_data, all = TRUE)
    
    # Los índices de las observaciones en el conjunto de entrenamiento
    # Los índices del conjunto de entrenamiento
    
    id_in <-  as.integer(row.names(updated_data$Train) )
    
    # Los índices de las observaciones en el conjunto de validación (siempre a NA)
    
    id_out <- NA  # Los valores de validación siempre serán NA
    
    # Creamos el dataframe `id` con las columnas "id" y "id2"
    
    id_df <- data.frame(
      id = rep(paste0("Repeat", split$id), length(id_in)),  # Identificador de repetición
      id2 = rep(paste0("Fold", split$index), length(id_in))  # Identificador de fold
    )
    
    # Creamos un objeto `rsplit` con los nuevos elementos
    
    rsplit_obj <- structure(
      list(
        #analysis = updated_data$Train, 
        #assessment = updated_data$Validation, 
        data = rbind(updated_data$Train,updated_data$Validation),
        
        in_id = id_in,  # Identificadores de entrenamiento
        out_id = id_out,  # Identificadores de validación (siempre NA)
        id = id_df # Almacenamos el dataframe con "id" e "id2"
      ), class = "rsplit"
    )
    
    # Devolvemos el objeto `rsplit` modificado
    
    rsplit_obj
  })
  
  # Limpiamos las particiones para que el objeto final sea compatible con el tipo "vfold_cv"
  
  if (!is.null(strata)) 
    names(strata) <- NULL
  
  # Preparamos los atributos y devolvemos el objeto final con el mismo formato que vfold_cv
  
  cv_att <- list(v = v, repeats = repeats, strata = strata, breaks = breaks, pool = pool)
  
  # Devolvemos el objeto rset con la nueva estructura
  
  new_rset(splits = split_objs$splits, 
           ids = split_objs[, grepl("^id", names(split_objs))], 
           attrib = cv_att, 
           subclass = c("vfold_cv", "rset"))
}