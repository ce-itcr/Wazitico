<p align="center">
  <img width="400" height="130" src="https://res.cloudinary.com/dek4evg4t/image/upload/v1565376199/CE3104/imagotype.png">
</p>


Wazitico corresponde al _Proyecto I_ para el curso de _Lenguajes, Compiladores e Intérpretes. (CE3104)_, Módulo Lenguajes.
El mismo consiste en la implementación de una aplicación que permita reafirmar el conocimiento del **paradigma de programación funcional** 
utilizando [DrRacket](https://racket-lang.org/).


El presente tiene como objetivo el desarrollo de un grafo mixto que simule la famosa aplicación [Waze](https://www.waze.com/).
Waze es una aplicación social de tránsito automotor en tiempo real y navegación asistida por GPS desarrollada por Waze Mobile.
El 11 de junio 2013, Google completó la adquisición de Waze en $966 millones de dólares. Los usuarios de Waze son denominados
Wazers, y, a diferencia de los softwares de navegación asistida por GPS tradicionales, este es mantenido por los usuarios y
aprende de las rutas  recorridas por sus usuarios para proveer información de enrutamiento y actualizaciones de tráfico en tiempo real. 

## Vista Previa.

Flujo del Proyecto, Interacción con el usuario:
1. Adición de Nodos (Lugares).
2. Unión de Nodos con Peso.
3. Búsqueda de Rutas Posibles, por defecto selecciona la más corta, pero se puede seleccionar cualquiera de las mostradas en la lista del panel derecho.

<p align="center"><img width="80%" src="https://res.cloudinary.com/dek4evg4t/image/upload/v1566587210/CE3104/01.addNodes.png">
<img width="80%" src="https://res.cloudinary.com/dek4evg4t/image/upload/v1566587210/CE3104/02.joinNodes.png">
<img width="80%" src="https://res.cloudinary.com/dek4evg4t/image/upload/v1566587210/CE3104/03.findPaths.png"></p>


## Pre Requisitos.

```
racket : sudo apt-get install racket
racket/draw 
simple-svg
```

## Instalación.

Prerequisitos: Debe tener instalado [Git](https://git-scm.com/book/es/v2/Inicio---Sobre-el-Control-de-Versiones-Instalaci%C3%B3n-de-Git) en su consola.

1. En GitHub, vaya a la página principal del [repositorio del Proyecto](https://github.com/ce-itcr/Wazitico).
2. Debajo del nombre del repositorio, haga clic en Clonar o descargar.
3. En la sección Clonar con HTTPs, haga clic para copiar la URL de clonación del repositorio.
4. Abre Git Bash.
5. Cambie el directorio de trabajo actual a la ubicación donde desea que se realice el directorio clonado.
6. Escriba 'git clone', y luego pegue la URL que copió en el Paso 2.

    ```$ git clone https://github.com/ce-itcr/Wazitico.git```
    
7. Presione Entrar. Su clon local de Wazitivo se creará.
8. Abra [DrRacket](https://racket-lang.org/), seleccione: Archivo -> Abrir y vaya a la ubicación donde clonó el proyecto.
9. Haga clic en main.rkt para abrir el proyecto.


## Autores.

* **Angelo Ortiz** - *Desarrollador* - [angelortizv](https://github.com/angelortizv)
* **Iván Solís** - *Desarrollador* - [isolis2000](https://github.com/isolis2000)
* **Jonathan Esquivel** - *Desarrollador* - [jesquivel48](https://github.com/jesquivel48)

## Licencia.

Este proyecto está bajo la Licencia (MIT License) - mira el archivo 
[LICENSE](https://github.com/ce-itcr/Wazitico/blob/master/LICENSE) para detalles.

<p align="center">
  <img width=10% src="https://res.cloudinary.com/dek4evg4t/image/upload/v1565376121/CE3104/isotype.png">
</p>
