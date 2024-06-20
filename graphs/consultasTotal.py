# Creacion de las tablas 

import pandas as pd
import matplotlib.pyplot as plt

# Datos de ejemplo
data = {
    '1': [57.781],
    '2' : [88.081],
    '3': [111.572],
    '4': [107.76],
    '5': [102.056],
    '6': [93.404],
    '7': [114.319],
    '7.1': [24.702],
    '7.2': [17.466],
    '8': [24.321],
    '9': [25.501],
}

# Crear el DataFrame
df = pd.DataFrame(data)

df_transposed = df.T
df_transposed.columns = ['Value']
df_transposed.index.name = 'Query'
df_transposed.reset_index(inplace=True)

# Mostrar el DataFrame transpuesto
print(df_transposed)

# Crear el gráfico de barras horizontal con el color especificado
plt.figure(figsize=(10, 6))
plt.barh(df_transposed['Query'], df_transposed['Value'], color='#91DDCF')
plt.title('Valores Consultas Hive')
plt.xlabel('Value')
plt.ylabel('Query')

# Mostrar el gráfico
plt.show()
