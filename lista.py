# Lista para guardar los nombres de los alumnos
lista_alumnos = []

# Función para pedir solo letras
def leer_nombre(mensaje):
    while True:
        nombre = input(mensaje)
        if nombre.isalpha():
            return nombre
        else:
            print("Error: Solo se permiten letras. Intente nuevamente.")

# Menú principal
while True:
    print("\nMENÚ")
    print("1. Agregar alumno")
    print("2. Mostrar todos los alumnos")
    print("3. Cerrar")
    print("4. Eliminar alumno por nombre")

    opcion = input("Ingrese una opción (1-4): ")

    if opcion == "1":
        nombre = leer_nombre("Ingrese el nombre del alumno: ")
        lista_alumnos.append(nombre)
        print("Alumno agregado correctamente.")

    elif opcion == "2":
        if len(lista_alumnos) == 0:
            print("No hay alumnos registrados.")
        else:
            print("\nListado de alumnos:")
            for alumno in lista_alumnos:
                print(f"Alumno: {alumno}")

    elif opcion == "3":
        print("Cerrando programa...")
        break

    elif opcion == "4":
        if len(lista_alumnos) == 0:
            print("No hay alumnos para eliminar.")
        else:
            nombre_a_eliminar = leer_nombre("Ingrese el nombre del alumno a eliminar: ")
            if nombre_a_eliminar in lista_alumnos:
                # Buscar la posición y eliminarlo
                posicion = lista_alumnos.index(nombre_a_eliminar)
                lista_alumnos.pop(posicion)
                print(f"Alumno '{nombre_a_eliminar}' eliminado correctamente.")
            else:
                print("Ese alumno no está en la lista.")

    else:
        print("Opción no válida. Intente de nuevo.")

