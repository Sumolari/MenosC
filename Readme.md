[![Build Status](https://travis-ci.org/Sumolari/MenosC.svg?branch=master)](https://travis-ci.org/Sumolari/MenosC)


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

`cd /LAB && make all` generará y compilará el analizador léxico y lo probará con todos los archivos de prueba.