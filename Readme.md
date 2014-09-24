# Vagrant

Para usar la máquina virtual es necesario instalar Virtualbox y a continuación Vagrant.
Se puede usar Parallels en lugar de Virtualbox pero requiere instalar un plugin adicional.
La máquina está preparada para funcionar con ambos virtualizadores.

## Primer inicio

1. Abrir terminal y situarse en el directorio donde se encuentra este archivo.
1. Ejecutar `vagrant up --provision`.
1. Esperar unos minutos hasta que la terminal vuelva a pedir un comando.

## Conectarse a la máquina

1. Abrir terminal y situarse en el directorio donde se encuentra este archivo.
1. Ejecutar `vagrant ssh`.

## Apagar la máquina

1. Abrir terminal y situarse en el directorio donde se encuentra este archivo.
1. Ejecutar `vagrant halt`.

## Borrar la máquina

1. Abrir terminal y situarse en el directorio donde se encuentra este archivo.
1. Ejecutar `vagrant destroy`.

## Inicio rutinario

1. Abrir terminal y situarse en el directorio donde se encuentra este archivo.
1. Ejecutar `vagrant up && vagrant ssh`.
1. La terminal mostrará el shell de la máquina virtual al cabo de unos minutos.

# Flex

Para probar el proyecto se debe generar y compilar el analizador desde la máquina virtual.

## Acceder al proyecto

Los archivos del proyecto están montados en `/LAB`.
Esta carpeta es realmente la carpeta `LAB` que hay en el directorio donde se encuentra este archivo.

## Probar el proyecto

Por cada componente que añadamos al compilador añadiremos la entrada correspondiente al `Makefile`.
Hoy por hoy solamente hay una entrada: `lexico`.

`cd /LAB && make lexico` generará y compilará el analizador léxico y lo probará con el archivo demo.c.

# Git

Trateremos de usar Git-flow en la medida de lo posible.
Como cliente de Git se puede usar SourceTree (gratis, disponible en Windows y Mac) o la consola de comandos.

Usaremos una rama nueva por cada sesión de seminario cuyo nombre será: `seminario/#n` donde #n es el número del seminario (empezando por 1).

Para cada parte que tengamos que entregar crearemos una nueva rama, por ejemplo, la rama `analizador-lexico` para el entregable de mediados de noviembre del analizador léxico.

Uniremos ramas únicamente mediante pull-requests.
Solamente se unirá una pull-request si todos los miembros del grupo la aprueban (se asume que el autor de la pull-request la aprueba).
Por favor, sed responsables. No aprobéis una pull-request si no habéis comprobado que funciona como es de esperar.
Del mismo modo evitemos abrir pull-requests con código que no funcione.

El repositorio lo gestionará Lluís, de modo que **nadie** haya commits a `master` o ninguna de las ramas.

Las nuevas ramas de entregables partirán de master mientras que las ramas de los seminarios deberán partir de la rama del entregable correspondiente.

Cada rama se unirá a su rama padre mediante pull-requests.
Cuando un entregable está terminado se creará una pull-request para unificar su rama con master.

Cualquier cosa que no quede clara se puede expresar en los comentarios de los commits o de las pull-request.

El repositorio dispone tanto de Wiki como de Issues, hagamos uso de ambas herramientas para coordinar cosas que sepamos y tareas pendientes.