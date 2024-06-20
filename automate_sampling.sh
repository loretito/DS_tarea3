#!/bin/bash

# Tamaños de muestra (en porcentaje)
samples=(1 10 50 100)

# Función para ejecutar el script Hive y medir el tiempo de ejecución
run_hive_script() {
  local sample_size=$1
  start_time=$(date +%s)
  
  hive -e "
    INSERT OVERWRITE TABLE branch_sampled_data_${sample_size//./_}
    SELECT * FROM branches TABLESAMPLE(${sample_size} PERCENT);
    
    -- Realizar análisis en la muestra
    SELECT branch_type, COUNT(*) AS frequency_${sample_size//./_} FROM branch_sampled_data_${sample_size//./_} GROUP BY branch_type;
    SELECT branch_type, taken, COUNT(*) AS count_${sample_size//./_} FROM branch_sampled_data_${sample_size//./_} GROUP BY branch_type, taken;
    SELECT branch_type, SUM(CASE WHEN taken = 1 THEN 1 ELSE 0 END) / COUNT(*) AS proportion_taken_${sample_size//./_} FROM branch_sampled_data_${sample_size//./_} GROUP BY branch_type;
  "
  
  end_time=$(date +%s)
  execution_time=$((end_time - start_time))
  echo "Sample size ${sample_size}% took ${execution_time} seconds to execute."
}

# Iterar sobre los tamaños de muestra y ejecutar el script Hive
for sample in "${samples[@]}"; do
  run_hive_script ${sample}
  if [ ${execution_time} -ge 3600 ]; then
    echo "Query took approximately 1 hour to execute. Stopping sampling."
    break
  fi
done
