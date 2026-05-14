proporcion_comunidad <- function(train_df, val_df, all = TRUE)
{
  #---------------------------------------------------------------------------
  # Paso 1: 
  # Calcular las proporciones de cada clase 'target' dentro de cada grupo 'community_id' en el dataset 'train_df'
  #---------------------------------------------------------------------------
  
  proporciones_train <- train_df |> group_by(community_id, target) |>  
    tally() |> 
    mutate(proporcion = n / sum(n))|> 
    select(community_id, target, proporcion) |>
    pivot_wider(names_from = target, values_from = proporcion, names_prefix = "prob_louv_") |>
    mutate(across(everything(), ~ replace(., is.na(.), 0)))
  
  #---------------------------------------------------------------------------
  # Paso 2: 
  # Unir las proporciones al dataset 'train'
  #---------------------------------------------------------------------------
  
  train_con_proporciones <- train_df |> left_join(proporciones_train, by = "community_id") 
  
  prob_louv_cols <- grep("prob_louv_", colnames(train_con_proporciones), value = TRUE)
  
  train_con_proporciones <- train_con_proporciones |> select(node_id, target,all_of(sort(prob_louv_cols)),everything(),-community_id)
  
  #---------------------------------------------------------------------------
  # Paso 3: 
  # Proporciones globales de 'train_df' para existan valores de 'community_id' en 'val_df' que no existen en 'train_df'
  #---------------------------------------------------------------------------
  
  proporciones_globales <- train_df |> count(target) |> 
    mutate(proporcion = n / sum(n)) |> 
    select(target, proporcion) |> 
    rename(proporcion_global = proporcion)
  
  #---------------------------------------------------------------------------
  # Paso 4: 
  # Unir las proporciones al dataset 'val_df'
  #---------------------------------------------------------------------------
  
  indicador <- val_df |> inner_join(proporciones_train, by = "community_id")  
  
  val_con_proporciones <- val_df |> left_join(proporciones_train, by = "community_id")  
  
  if (nrow(indicador)== nrow(val_con_proporciones))
  {
    val_con_proporciones <- indicador
    val_con_proporciones <- val_con_proporciones |> select(node_id, target,all_of(sort(prob_louv_cols)),everything(),-community_id)
  }
  else
  {
  # Registros que coinciden con alguna comunidad de Louvain en Train
  
  val_con_proporciones_match <- val_con_proporciones |> filter(!if_any(everything(), is.na))  |> 
    select(node_id, target,all_of(sort(prob_louv_cols)),everything(),-community_id)
  
  # Registros que NO coinciden con alguna comunidad de Louvain en Train
  
  val_con_proporciones_notmatch <- val_con_proporciones |> filter(if_any(everything(), is.na))  |> 
    select(-matches("prob_louv_"))
  
  val_con_proporciones_notmatch <- expand.grid(node_id = val_con_proporciones_notmatch$node_id, target = proporciones_globales$target)
  
  val_con_proporciones_notmatch <- val_con_proporciones_notmatch |> left_join(proporciones_globales, by = "target") |> 
    pivot_wider(names_from = target, values_from = proporcion_global, names_prefix = "prob_louv_")|>
    inner_join(val_con_proporciones |>  select(-matches("prob_louv_")) , by = "node_id")|> 
    select(node_id, target,all_of(sort(prob_louv_cols)),everything(),-community_id)
  
  val_con_proporciones <- rbind(val_con_proporciones_match,val_con_proporciones_notmatch)
  }
  #---------------------------------------------------------------------------
  # Paso 5: 
  # Devolver en formato lista
  #---------------------------------------------------------------------------
  
  if (all) 
  {
    return(list("Train" = train_con_proporciones |> rename_all(tolower) |> select(-node_id), 
                "Validation" = val_con_proporciones |> rename_all(tolower)|> select(-node_id)
    )
    )
  }
  
  else
  {
    
    return(list("Train" = train_con_proporciones |> rename_all(tolower)|> select(target, matches("prob_louv_")), 
                "Validation" = val_con_proporciones |> rename_all(tolower)|> select(target,matches("prob_louv_"))
    )
    )  
  } 
}