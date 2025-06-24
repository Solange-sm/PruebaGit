# Lista para guardar los nombres de los alumnos
lista_alumnos = []

# Menú principal
while True:
    print("\nMENÚ")
    print("1. Agregar alumno")
    print("2. Mostrar todos los alumnos")
    print("3. Cerrar")

    opcion = input("Ingrese una opción (1-3): ")

    if opcion == "1":
        nombre = input("Ingrese el nombre del alumno: ")
        lista_alumnos.append(nombre)
        print("Alumno agregado correctamente.")
    elif opcion == "2":
        print("\nListado de alumnos:")
        for alumno in lista_alumnos:
            print(f"Alumno: {alumno}")
    elif opcion == "3":
        print("Cerrando programa...")
        break
    else:
        print("Opción no válida. Intente de nuevo.")

