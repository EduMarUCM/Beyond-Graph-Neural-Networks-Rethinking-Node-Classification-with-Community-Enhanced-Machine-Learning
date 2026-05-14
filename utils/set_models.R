set_model_function <- function(model_name)
{
  if (model_name =="Decision Tree") 
  { 
    # Decision Tree
    
    model <- decision_tree(tree_depth = tune(),
                           min_n = tune(),
                           cost_complexity = tune()
    )|> 
      set_mode("classification")|> 
      set_engine("rpart")  
   
  }
  else if (model_name =="Logistic Regression") 
  {
    # Regresión Logística
    
    model <-  multinom_reg(penalty   = tune())|>
                           #mixture   = tune()) |>
      set_engine("nnet")|>
      #set_engine("glmnet")|>
      set_mode("classification") 
   
  }
  else if (model_name =="Neural Network") 
  {
    # Neural Network
    
    #model <-  mlp(epochs = tune(), 
    #   hidden_units = tune(), 
    # penalty = tune(), 
    # learn_rate = tune()
    #) |>
    # set_engine("brulee")|>
    # set_mode("classification")
    
    model <- mlp(hidden_units = tune("hidden_units"),
        epochs       = tune("epochs")
    ) |>
      set_engine("nnet") |>
      set_mode("classification")
    
  }
  else if (model_name =="Random Forest") 
  {
    # Ranfom Forest
    
    model <-  rand_forest(#mtry  = tune(), 
                          trees  = tune(), 
                          min_n  = tune()
    ) |>
      set_engine("ranger")|>
      set_mode("classification")  
   
  }
  else if (model_name =="SVM Linear") 
  {
    # SVM Lineal
    
    model <-   svm_linear(cost = tune(),             # Parámetro de regularización (C)
                          margin = tune()            # Parámetro para el margin (distancia más corta entre el hiperplano y los vectores de soporte)           
    ) |>
      set_engine("kernlab")|>
      set_mode("classification")
   
  }
  else if (model_name =="SVM Radial") 
  {
    # SVM Kerneal Radial (Gaussiano)
    
    model <-      svm_rbf(cost = tune(), # Parámetro de regularización (C)
                          margin = tune(),# Parámetro para el margin (distancia más corta entre el hiperplano y los vectores de soporte)
                          rbf_sigma= tune()# Parámetro del kernel radial (sigma)
    ) |>
      set_engine("kernlab")|>
      set_mode("classification")  
    
  }
  else if (model_name =="XGBoost") 
  {
    # XGBoost
    
    model <-  boost_tree( trees = 200,               # Número máximo de árboles
                          #mtry  = tune(),    data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAbElEQVR4Xs2RQQrAMAgEfZgf7W9LAguybljJpR3wEse5JOL3ZObDb4x1loDhHbBOFU6i2Ddnw2KNiXcdAXygJlwE8OFVBHDgKrLgSInN4WMe9iXiqIVsTMjH7z/GhNTEibOxQswcYIWYOR/zAjBJfiXh3jZ6AAAAAElFTkSuQmCC          # Número de variables aleatorias (enfoque similar a RF)
                          min_n = tune(),               # Número mínimo de observaciones por nodo terminal
                          tree_depth = tune(),          # Profundidad de los árboles
                          learn_rate = tune(),          # Tasa de aprendizaje
                          loss_reduction = tune()       # Reducción de la pérdida
    )|>
      set_engine("xgboost")|>
      set_mode("classification") 
  
  }
  else
  {
    print("No existe modelo con el nombre indicado")
  }
  return(model)
}