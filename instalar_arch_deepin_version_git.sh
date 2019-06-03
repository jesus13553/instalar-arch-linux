 get_distro () 
{ 
    eval "$_new";
    _HTTP=$(wget -q -O - https://www.archlinux.org/download/ | sed  's/"/\n/g' | sed '/http.*redi.*2019/!d' );
    _ISO=$( wget -q -O - $_HTTP | sed 's/"/\n/g' | awk '/iso$/' );
    [[ -f ${_ISO}.control ]] && echo Nada que hacer && return 0;
    wget -c -O $_ISO $_HTTP$_ISO && : > ${_ISO}.control
}
 get_distro 
system_to_chroot () 
{ 
    eval "$_new";
    function chroot_mount_bind () 
    { 
        eval "$_new";
        local var=${@:$#:$#};
        var=${var//\/};
        echo ${@:1:$#-1} | sed 's/ /\n/g' | awk '{ var="sudo mount --rbind "$_" '`pwd`/${var}'"$_ ; print var | "sh"  ;}'
    };
    function mount_overlay_v1 () 
    { 
        eval "$_new";
        [[ -d /tmp/upperdir ]] || mkdir /tmp/upperdir;
        [[ -d /tmp/workdir ]] || mkdir /tmp/workdir;
        local var=' sudo mount -t overlay -o lowerdir=xxx,upperdir=/tmp/upperdir,workdir=/tmp/workdir';
        for a in ${@:1:$#-1};
        do
            var=${var/xxx/${a}:xxx};
        done;
        eval "${var//:xxx/} overlay ${@:$#:$#}"
    }
}
system_to_chroot
[[ -d MISO/ ]] || mkdir MISO/ MSQUAS/ MCHROOT/ PKGS/
_arch_to_chroot () 
{ 
    eval "$_new";
    mount archlinux*.iso MISO/;
    mount MISO/arch/x86_64/airootfs.sfs MSQUAS/;
    mount_overlay_v1 MSQUAS/ MCHROOT/;
    chroot_mount_bind /dev/ /sys/ /proc/ MCHROOT/
}
_mk_instalar_sistema () 
{ 
    eval "$_new";
    cat <<'INJECT' > $1
_to_mount () 
{ 
    eval "$_new";
    _d=$1;
     export  _dev=${1%[1-9]}
    _d=${_d//*\/};
     mkdir /${_d^^}
     _dir=${_d^^};
     mount $1 /${_d^^}
     export $_dir
}
_to_mount $1
chroot_mount_bind () 
{ 
    eval "$_new";
    local var=${@:$#:$#};
    var=${var//\/};
    echo ${@:1:$#-1} | sed 's/ /\n/g' | awk '{ var="sudo mount --rbind "$_" '`pwd`/${var}'"$_ ; print var | "sh"  ;}'
}
__instalar_distro ()
{ 
    set -- ${1//\//};
    _dir=${1:-MP};
     . _entorno__29_abr_2019_.sh 
    mkdir -p ${_dir}/{root,tmp};
    mkdir -m 0755 -p ${_dir}/var/{cache/pacman/pkg,lib/pacman,log} ${_dir}/{dev,run,etc};
    mkdir -m 1777 -p ${_dir}/tmp;
    mkdir -m 0555 -p ${_dir}/{sys,proc};
    yes | cp -i  -a /etc/pacman.d/gnupg "${_dir}/etc/pacman.d/";
    yes | cp -i  -a /etc/pacman.d/mirrorlist "${_dir}/etc/pacman.d/";
    yes | cp _entorno__29_abr_2019_.sh  ${_dir};
    sed '/^#/d;s/Requ.*/Never/g;/^$/d' -i /etc/pacman.conf
__pacman () 
{ 
    eval "$_new";
     pacman -r ${_dir}/ -Sy ${@:-base} --cachedir=${_dir}/var/cache/pacman/pkg --noconfirm
}
    chroot_mount_bind /dev/ /sys/ /proc/ ${_dir}/
    echo nameserver 8.8.8.8 > ${_dir}/etc/resolv.conf
    mount -o bind /var/cache/pacman/pkg ${_dir}/var/cache/pacman/pkg 
    pacman-key --init
}
__instalar_distro $_dir
_auto ()
{
__pacman base linux grub networkmanager
__pacman  ntfs-3g  gvfs gvfs-afc gvfs-mtp
__pacman xorg-server xorg-xinit xterm mesa mesa-demos xf86-video-vesa 
[[ $1 == cinnamon ]] && __pacman cinnamon gdm 
[[ $1 == deepin ]]  && __pacman lightdm lightdm-deepin-greeter deepin
[[ $1 == mate  ]] && __pacman mate mate-extra gdm
__pacman firefox okular vlc rsync wget gpicview git qbittorrent
}
_manual ()
{
read -p "pacman listo, ( q para salir ) :: " E
[[ $E != q ]] &&  __pacman $E || return 0
_manual 
}
[[ X$2 == Xmanual ]] && _manual || _auto ${2:-deepin}
__adduser () 
{ 
    eval "$_new";
    cat <<'END' > ${_dir}/root/.bashrc
adduser () 
{ 
    eval "$_new";
    useradd -m -g users -G audio,lp,optical,storage,video,wheel,games,power,scanner -s /bin/bash $1;
    passwd $1
}
END
}
__adduser
__red () 
{ 
    eval "$_new";
    cat <<'END'  >> ${_dir}/root/.bashrc
_whifi_conect () 
{ $1
    eval "$_new";
    nmcli dev wifi connect $1 password $2
}
END
}
__red
_ajustes () 
{ 
    eval "$_new";
    cat <<'END' >  ${_dir}/ajustes.sh
echo Manjaro > /etc/hostname
sed '/^#/d;s/Requ.*/Never/g;/^$/d' -i /etc/pacman.conf
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
locale-gen
echo LANG=es_ES.UTF-8 > /etc/locale.conf
hwclock -w
echo KEYMAP=la-latin1 > /etc/vconsole.conf
echo "Password ROOT ???? " ;
passwd 
echo Instalando para "$_dev"
sleep 2
[[ $E == q ]] && return 0
grub-install --target i386-pc ${_dev}
grub-mkconfig -o /boot/grub/grub.cfg
__lightdm_deepin_conf () 
{ 
    eval "$_new";
    cat <<'END_' >  /etc/lightdm/lightdm.conf
[LightDM]
run-directory=/run/lightdm
[Seat:*]
greeter-session=lightdm-deepin-greeter
session-wrapper=/etc/lightdm/Xsession
[XDMCPServer]
[VNCServer]
END_
systemctl enable lightdm.service 
}
[[ -f /etc/lightdm/lightdm.conf ]] && __lightdm_deepin_conf  || systemctl enable gdm.service 
systemctl enable NetworkManager.service
. /root/.bashrc
 sed 's/^#//g' -i /etc/pacman.d/mirrorlist
echo nameserver 8.8.8.8 > /etc/resolv.conf
read -p "Nuevo Usuario ??? " E ;
[[ $E != q ]] && adduser $E;
END
}
_ajustes
cp _entorno__6_may_2019_.sh $_dir
chroot $_dir /bin/bash /ajustes.sh $_dev
INJECT
}
[[ -d MCHROOT/boot ]] || _arch_to_chroot
mount -o bind PKGS/ MCHROOT/var/cache/pacman/pkg 
echo nameserver 8.8.8.8 >   MCHROOT/etc/resolv.conf
_mk_instalar_sistema   MCHROOT/instalar.sh
yes | cp _entorno__6_may_2019_.sh MCHROOT/
clear
(($#)) && chroot  MCHROOT/ /bin/bash /instalar.sh $1 $2 || chroot  MCHROOT/  
