import pandas as pd

def clean_csv(file_path):
    # Leer el archivo .csv
    df = pd.read_csv(file_path)
    
    # Contar el número de filas antes de la limpieza
    initial_row_count = len(df)
    
    # Eliminar las filas que no contengan contenido en las 4 columnas
    df_cleaned = df.dropna(subset=['branch_addr', 'branch_type', 'taken', 'target'], how='all')
    
    # Contar el número de filas después de la limpieza
    final_row_count = len(df_cleaned)
    
    # Calcular el número de filas eliminadas
    rows_deleted = initial_row_count - final_row_count
    
    # Guardar el archivo limpio
    df_cleaned.to_csv('cleaned_' + file_path, index=False)
    
    # Retornar el conteo de filas eliminadas
    return rows_deleted

# Ejemplo de uso
file_path = '6.8.csv'
deleted_rows = clean_csv(file_path)
print(f'Se eliminaron vacias filas.')