# **PlanifyNow**

---------------------------------

![GitHub commit activity](https://img.shields.io/github/commit-activity/t/jpg1011/TFG-GestorTareasMoodle) ![GitHub repo size](https://img.shields.io/github/repo-size/jpg1011/TFG-GestorTareasMoodle) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) ![GitHub Release](https://img.shields.io/github/v/release/jpg1011/TFG-GestorTareasMoodle) ![Issues](https://img.shields.io/github/issues/jpg1011/TFG-GestorTareasMoodle)

-------------------------
PlanifyNow es una aplicación multiplataforma que permite a usuarios de Moodle, llevar a cabo la planificación de sus actividades mediante un diagrama de Gantt. Además, ofrece soporte a la creación de tareas personales asociadas a un curso. El contenido de estas funcionalidades puede ser filtrado por el sistema de filtrado general que incorpora la aplicación.

-------------------------

## **Indice**
- [Instalación](#instalación)
- [Tecnologías](#tecnologías)
- [Funcionalidades](#funcionalidades)
- [Roadmap](#roadmap)
- [Licencia](#licencia)
- [Contacto](#contacto)


## **⚙️Instalación**
⚠️ **_NOTA_**: es muy importante tener instalado _Git_.

1. Realiza una clonación del repositorio con:
```console
    git clone https://github.com/jpg1011/TFG-GestorTareasMoodle.git
```
2. Accede al directorio donde se encuentre el código fuente con:
```console
    cd TFG-GestorTareasMoodle/app/app
```

## **▶️Ejecución**
⚠️ **_NOTA_**: es necesario tener instalado un emulador Android.

Una vez realizados los pasos de [instalación](#️instalación), para poder ejecutar la aplicación en modo debug, se tienen que seguir los siguientes pasos:
1. Inicializa el emulador Android con:
```console
    flutter emulators --launch <id_del_emulador>
```
ℹ️ **_NOTA_**: para obtener el listado de emulador ejecuta:
```console
    flutter emulators
```
2. Una vez abierto el emulador, ejecuta:
```console
    flutter run
```

### **Ejecución en otros sistemas**
Otro sistema donde se puede ejecutar la aplicación es Windows.

En ese caso, se debe de ejecutar el siguiente comando:
```console
    flutter run -d windows
```

## **🛠️Tecnologías**
- **Dart & Flutter**: Interfaz y lógica
- **Moodle Web Services**: Obtención de datos de Moodle
- **Supabase**: Almacenamiento de tareas en la nube

## **🚀Funcionalidades**
- 📊Diagrama de Gantt para visualizar actividades de Moodle
- 📄Sección con listado de actividades de Moodle
- 📝Creación y gestión de tareas personales
- ⚙️Sistema de filtrado general

## **⏳Roadmap**
- 🌍Internacionalización
- 🔔Sistema de notificaciones
- 📊Nuevos diagramas
- ⚙️Nuevos filtros
- 🌐Integración con otros LMS

## **🧾Licencia**
Este proyecto esta sujeto bajo los términos de una licencia MIT. El archivo [LICENSE](LICENSE) contiene toda la información relacionada.

## **📫Contacto**
Si existe alguna duda, te puedes poner en contacto conmigo a través de la siguiente dirección de correo electrónico: 
- jpg1011@alu.ubu.es