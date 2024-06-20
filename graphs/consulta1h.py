# Creacion de las tablas 

import pandas as pd
import matplotlib.pyplot as plt

name = "bsd_"

# Datos de ejemplo
data = {
    name + '0_01': [4.972],
    name + '0_1' : [0.79],
    name + '1': [0.069],
    name + '10': [0.068],
    name + '50': [0.07],
    name + '100': [0.067],
}

# Crear el DataFrame
df = pd.DataFrame(data)

# Transponer el DataFrame para tener los nombres como índice
df_transposed = df.T
df_transposed.columns = ['Value']
df_transposed.index.name = 'Branch'
df_transposed.reset_index(inplace=True)

# Mostrar el DataFrame transpuesto
print(df_transposed)

# Crear el gráfico de barras horizontal con el color especificado
plt.figure(figsize=(10, 6))
plt.barh(df_transposed['Branch'], df_transposed['Value'], color='#91DDCF')
plt.title('Valores de Branch Sampled Data')
plt.xlabel('Value')
plt.ylabel('Branch')

# Mostrar el gráfico
plt.show()
