Presento un pequeño script en BASH que convierta la instalacion de Archlinux en una tarea extremadamente sencilla.

Requisitos:
 
1) Linux corriendo en cualquier disco o en USB LIVE.
2) Particion para Linux ( ejemp EXT4 ) creada en un disco o en un USB.
   Una forma comoda es usar Gparted. Mejor crear una particion EXT4 y
   una pequeña para UUFI tipo vfat. Sirve solo una particion EXT4 ( /dev/s??? )
2) Internet, para bajar distro o paquetes. 

El script cumple un amplio abanico de modos de instalacion de Archlinux:
   Desde una forma totalmente automatica a otra completamente manual ( clasica ).

Modo de uso:
Desde terminal.
1 ) crear un directorio ( ejemplo: mkdir ARCHI  )
2 ) copiar el script al directorio ( ejemplo: cp script ARCHI && cd ARCHI ).
3 ) ejecutarlo con PUNTO SCRIPT OPCIONES ( estas en terminal dentro de ARCHI )

Primera vez: El script baja una distro de Archi, la instala y guarda los paquetes
bajados en un dir llamado PKGS que se crea en el directorio.

Segunda vez: No tiene que bajar nada nuevo, solo instala por lo que es muy rapido
( ejemplo puedes crear un USB con una distro instalada, no es LIVE es instalada, funcional
con un escritorio deepin, etc, en menos e media hora ).

Script y opciones despues de crear una particion EXT4 llamada /dev/s??
Estamos en terminal como root ( ejemplo mate-terminal ).
---->>> Sustituir SCRIPT por instalar_arch_deepin_version_git.sh  <<-------

OPCIONES: PUNTO SCRIPT DEVICE PARAMETROS

1 ) . (punto ) SCRIPT NADA ( solo . script )
   Entra en un chroot y podeis intalar Arch de forma clasica ( con pacstrap y todo eso )

2 ) . (punto ) SCRIPT /dev/s??
     Defecto, baja distro, instala escritorio deepin, pide password y crea un usuario, totalmente
     funcional, no hay que hacer mas.

3 ) . ( punto ) SCRIPT /dev/s?? cinnamon
      Lo mismo pero con cinnamon

4 ) . ( punto ) SCRIPT mate. 
      Lo mismo pero con mate

5 ) . ( punto ) SCRIPT manual 
      Version mejorada de 1 ); sales a una linea de comandos ( pacman listo, (q para salir) :: ),
      bajas lo que quiera y los ajustes son automaticos.

Ejemplo practico:

Gparted USB ( creo un /dev/s?? tipo EXT4 ).
mkdir ARCHI
cp instalarinstalar_arch_deepin_version_git.sh  ARCHI
cd ARCHI
su
. instalar_arch_deepin_version_git.sh  /dev/s?? ### ( acordaros de punto script etc )
Al de un rato os pide
Password root
Nuevo Usuario ??

Listo ya teneis un USB con Archlinux funcionando con deepin.

Ejemplo;
Creado pero queremos modificarlo, o crearlo a nuestro gusto.

. instalar_arch_deepin_version_git.sh manual

Ejemplo;
Creado pero queremos modificarlo con control total, o crearlo desde cero.

. instalar_arch_deepin_version_git.sh ( sin parametros )

Ejemplo;
No quiero deepin, prefiero mate

. instalar_arch_deepin_version_git.sh  /dev/s?? mate

El script crea muchos chroot y overlays por lo que aparecen muchos discos en escritorio.
al final para deshacerlos lo mejor es un reboot.

En definitiva.
para crear un USB con deepin solo teneis que hacer:

. instalar_arch_deepin_version_git.sh  /dev/s??

Saludos.






