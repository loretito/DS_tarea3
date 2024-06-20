import pandas as pd
import matplotlib.pyplot as plt

# Datos de ejemplo
data = {
    'Tiempo por consulta': [57.781, 88.081, 111.572, 107.76, 102.056, 93.404, 114.319, 24.702, 17.466, 24.321, 25.501],
    'Duración MapReduce': ['2m 40s', '4m 30s', '5m 18s', '6m 25s', '4m 50s', '4m 48s', '6m 19s', '0m 26s', '0m 3s', '0m 37s', '0m 26s'],
    'MapReduce CPU Time spend': [6849469875, 6849583391, 6849592998, 6849632008, 6849575570, 6849585564, 6849625076, 80534900, 8369, 805306667, 805349000],
    'HDFS READ': [6849469875, 6849583391, 6849592998, 6849632008, 6849575570, 6849585564, 6849625076, 80534900, 8369, 805306667, 805349000],
}

# Crear el DataFrame
df = pd.DataFrame(data, index=['1', '2', '3', '4', '5', '6', '7', '7.1', '7.2', '8', '9'])

# Mostrar el DataFrame completo sin truncar
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', 1000)  # Cambiado a un valor grande para evitar truncamiento

print(df)



