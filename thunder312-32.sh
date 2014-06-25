#!/bin/bash
clear
echo "|=====================================================================|"
echo ""
echo "       _            __  __  _____ "
echo "      | |          |  \/  |/ ____|"
echo "      | | ___   ___| \  / | |  __ "
echo "  _   | |/ _ \ / _ \ |\/| | | |_ |"
echo " | |__| | (_) |  __/ |  | | |__| |"
echo "  \____/ \___/ \___|_|  |_|\_____|"
echo ""
echo "+=====================================================================+"
echo "|              INSTALACION THUNDER 3.1.2 - Squid 3.x                  |"
echo "|                              32 bits                                |"
echo "+=====================================================================+"
echo ""
V='|-------------------------> Version 32 bits <-------------------------|'
ER='ERROR, su version de linux no es de 32 bits' 
ER2='Use el script adecuado para su version'
P=`uname -m`
if [ $P = i686 ] ; then
echo $V
else
echo $ER
echo ""
echo $ER2
echo ""
exit 0
fi
echo ""

IP_DE_MAQUINA="192.168.10.2"	
PUERTO_DE_SQUID="3128"		
HOST_NAME="routero-os.com"		
TAM_DE_CACHE="100000" 		
IP_DE_RED_INTERNA="0.0.0.0/0"	

echo "/"
sleep 3

apt-get update
apt-get upgrade

mkdir /var/spool/squid3/
chmod 777 /var/spool/squid3/

echo Y | apt-get install squid3 beep

echo "/"
sleep 3
touch /etc/squid3/denegados.lst
echo "cracks.st" >> /etc/squid3/denegados.lst

rm -rf /etc/squid3/squid.conf 
touch /etc/squid3/squid.conf

echo "#=========================== Squid 3.x Conf =============================#

#=================== Para uso con ThunderCache ===================#

# Opciones de SQUID 3.x
#----------------------------------------------------------------------
http_port $PUERTO_DE_SQUID intercept
visible_hostname proxy.$HOST_NAME
icp_port 0
#----------------------------------------------------------------------
#error_directory /usr/share/squid3/errors/Spanish/
#----------------------------------------------------------------------
acl denegados url_regex -i \"/etc/squid3/denegados.lst\"
#----------------------------------------------------------------------
# Servidor DNS y Politica de Cambios
#----------------------------------------------------------------------
dns_nameservers 8.8.8.8 8.8.4.4
dns_retransmit_interval 5 seconds
dns_timeout 2 minutes
#----------------------------------------------------------------------
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl CONNECT method CONNECT

acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl SSL_ports port 443
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl Safe_ports port 631         # cups
acl Safe_ports port 873         # rsync
acl Safe_ports port 901         # SWAT
acl Safe_ports port 1863        # MSN
#acl SSL_ports port 443          # https
acl SSL_ports port 563          # snews
acl SSL_ports port 873          # rsync

http_access allow manager localhost
http_access deny manager all
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localhost
http_access deny denegados
#----------------------------------------------------------------------
coredump_dir /var/spool/squid3
#----------------------------------------------------------------------
# Memoria reservada para cache
# Se recomienda que dedique aprox. 5MB de RAM por cada 1GB asignado a cache_dir
#----------------------------------------------------------------------
cache_mem 512 MB
#----------------------------------------------------------------------
# Maximo tamaño de archivo en cache de memoria
#----------------------------------------------------------------------
maximum_object_size_in_memory 128 KB
#----------------------------------------------------------------------
# Maximo y minimo tamaño de archivos cache en el Disco duro
#----------------------------------------------------------------------
maximum_object_size 30 MB
minimum_object_size 0 KB
#----------------------------------------------------------------------
# Sustituir archivos de cache cuando llegue a 96%
#----------------------------------------------------------------------
cache_swap_low 92
cache_swap_high 96
#----------------------------------------------------------------------
# Total de espacio en HD a ser usado por el cache, numero de carpetas,
# numero de subcarpetas en cache
# 100000 = 100 GB
#----------------------------------------------------------------------
cache_dir aufs /var/spool/squid3/cache1 $TAM_DE_CACHE  16 256
#----------------------------------------------------------------------
# Estandar de actualización de cache
# 1 mes = 10080 mins, 1 dia = 1440 mins
#----------------------------------------------------------------------
refresh_pattern -i \.jpg$ 14400 80% 43200 reload-into-ims
refresh_pattern -i \.gif$ 14400 80% 43200 reload-into-ims
refresh_pattern -i \.png$ 14400 80% 43200 reload-into-ims
refresh_pattern -i \.jpeg$ 14400 80% 43200 reload-into-ims
refresh_pattern -i \.bmp$ 14400 80% 43200 reload-into-ims
refresh_pattern -i \.tif$ 14400 80% 43200 reload-into-ims
refresh_pattern -i \.tiff$ 14400 80% 43200 reload-into-ims
refresh_pattern -i \.swf$ 14400 80% 43200 reload-into-ims
refresh_pattern -i \.html$ 10 20% 4320 reload-into-ims
refresh_pattern -i \.htm$ 10 20% 4320 reload-into-ims
refresh_pattern -i \.shtml$ 10 20% 4320 reload-into-ims
refresh_pattern -i \.shtm$ 10 20% 4320 reload-into-ims
refresh_pattern -i \.nub$ 2880 80% 21600 reload-into-ims
refresh_pattern -i \.exe$ 14400 80% 43200
refresh_pattern -i \.zip$ 14400 80% 43200
refresh_pattern -i \.mov$ 14400 80% 43200
refresh_pattern -i \.mpe?g?$ 14400 80% 43200
refresh_pattern -i \.avi$ 14400 80% 43200
refresh_pattern -i \.qtm?$ 14400 80% 43200
refresh_pattern -i \.viv$ 14400 80% 43200
refresh_pattern -i \.wav$ 14400 80% 43200
refresh_pattern -i \.aiff?$ 14400 80% 43200
refresh_pattern -i \.au$ 14400 80% 43200
refresh_pattern -i \.ram?$ 14400 80% 43200
refresh_pattern -i \.snd$ 14400 80% 43200
refresh_pattern -i \.mid$ 14400 80% 43200
refresh_pattern -i \.mp2$ 14400 80% 43200
refresh_pattern -i \.mp3$ 14400 80% 43200
refresh_pattern -i \.sit$ 14400 80% 43200
refresh_pattern -i \.zip$ 14400 80% 43200
refresh_pattern -i \.hqx$ 14400 80% 43200
refresh_pattern -i \.arj$ 14400 80% 43200
refresh_pattern -i \.lzh$ 14400 80% 43200
refresh_pattern -i \.lha$ 14400 80% 43200
refresh_pattern -i \.cab$ 14400 80% 43200
refresh_pattern -i \.rar$ 14400 80% 43200
refresh_pattern -i \.tar$ 14400 80% 43200
refresh_pattern -i \.gz$ 14400 80% 43200
refresh_pattern -i \.z$ 14400 80% 43200
refresh_pattern -i \.a[0-9][0-9]$ 14400 80% 43200
refresh_pattern -i \.r[0-9][0-9]$ 14400 80% 43200
refresh_pattern -i \.txt$ 14400 80% 43200
refresh_pattern -i \.pdf$ 14400 80% 43200
refresh_pattern -i \.doc$ 14400 80% 43200
refresh_pattern -i \.rtf$ 14400 80% 43200
refresh_pattern -i \.tex$ 14400 80% 43200
refresh_pattern -i \.latex$ 14400 80% 43200
refresh_pattern -i \.class$ 14400 80% 43200
refresh_pattern -i \.js$ 14400 80% 43200
refresh_pattern -i \.ico$ 14400 80% 43200
refresh_pattern -i \.css$ 10 20% 4320
#----------------------------------------------------------------------
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
#refresh_pattern (Release|Package(.gz)*)$       0       20%     2880
refresh_pattern .               0       20%     4320
#----------------------------------------------------------------------
# Log de acessos por el cache o para SARG
#----------------------------------------------------------------------
logfile_rotate 7
access_log /var/log/squid3/access.log
access_log /var/log/squid3/error.log
cache_store_log none
#----------------------------------------------------------------------
# Otras configuraciones
#----------------------------------------------------------------------
half_closed_clients off
server_persistent_connections off
client_persistent_connections off
log_fqdn off
quick_abort_min 0 KB
quick_abort_max 0 KB
quick_abort_pct 95
max_filedescriptors 65536
cache_effective_user proxy
cache_effective_group proxy
#----------------------------------------------------------------------
# Manteniendo objetos recientes y pequeños en memoria
#----------------------------------------------------------------------
memory_replacement_policy heap GDSF
cache_replacement_policy heap LFUDA
#----------------------------------------------------------------------
# Sitios que se les niega el cache  
#----------------------------------------------------------------------
acl nocache dstdomain .4shared.com .youtube.com .windowsupdate.com .gl$
no_cache deny nocache
#----------------------------------------------------------------------
# Negar cache para archivos con extencion .asx e .asf |streaming|
#----------------------------------------------------------------------
acl asx url_regex -i \.asx$
cache deny asx
acl asf url_regex -i \.asf$
cache deny asf" >> /etc/squid3/squid.conf

/etc/init.d/squid3 stop
sleep 1

squid3 -z
sleep 1

/etc/init.d/squid3 restart

echo "/"
sleep 6
beep -f 999.9
beep -f 999.9

echo "/"

IP_DE_MAQUINA="192.168.10.2"		
PASSWORD_MYSQL="thunder31" 			
DIASL="45" 

echo "/"
sleep 3

apt-get update
apt-get upgrade

echo Y | apt-get install apache2 sqlite gcc libsqlite3-dev libapache2-mod-php5 php-db libstdc++6 g++ unzip libmysqlclient15-dev libblkid-dev libcurl3-dev lynx ffmpeg lsb-release sudo unzip make php5-dev php-pear apache2-prefork-dev libpcre3-dev

echo Y | apt-get -f upgrade

cd /root

echo "/"
sleep 3

wget http://joemg.host56.com/tc3x/thunder32.tar.gz
cp thunder32.tar.gz /tmp
tar -xzvf /tmp/thunder32.tar.gz -C /
rm -rf thunder32.tar.gz
chmod a+x /usr/local/sbin/thunder

mkdir /var/log/thunder
mkdir /var/tmp/thunder
mkdir /var/run/thunder
mkdir /thunder
chmod a+rwx /var/log/thunder
chmod a+rwx /var/tmp/thunder
chmod a+rwx /var/run/thunder
chmod a+x /etc/init.d/thunder
touch /etc/thunder/whitelist
touch /etc/thunder/blacklist
chown -R www-data /thunder/
chmod -R 777 /thunder/
umask 000 /thunder/

echo "extension=pdo.so" >> /etc/php5/apache2/php.ini
echo "vm.swappiness=10" >> /etc/sysctl.conf

update-rc.d thunder defaults

#wget http://www.joemg.host56.com/tc31/libmysqlclient.so.15
#mv libmysqlclient.so.15 /usr/lib/
#wget http://www.joemg.host56.com/tc31/libmysqlclient.so.15.0.0
#mv libmysqlclient.so.15.0.0 /usr/lib/

ln -s /var/www/thunder/index.php /var/www/thunder.php

echo "/"
sleep 3

echo "#----------------------------------------------------------------------
#Redireccionamiento Thunder - REGEx
#----------------------------------------------------------------------
acl thunder_lst url_regex -i \"/etc/thunder/thunder.lst\"
cache deny thunder_lst
cache_peer $IP_DE_MAQUINA parent 8080 0 proxy-only no-digest
dead_peer_timeout 2 seconds
cache_peer_access $IP_DE_MAQUINA allow thunder_lst
cache_peer_access $IP_DE_MAQUINA deny all
#----------------------------------------------------------------------" >> /etc/squid3/squid.conf

echo "/"
sleep 3
 
touch /etc/thunder/thunder.conf

echo "# WWW.ROUTERO-OS 
# PARAMETROS PARA THUNDER
CACHEDIR /thunder/
PLUGINSDIR /etc/thunder/plugins/
# En porcentage (%)
CACHE_LIMIT 90

# Zero Penalty Hit do thunder
# padrao:
# ZPH_TOS_LOCAL 0
# recomendado:
# ZPH_TOS_LOCAL 8

# Configuracion de MySQL
MYSQL_HOST localhost
MYSQL_USER root
MYSQL_PASS $PASSWORD_MYSQL
MYSQL_DB thunder

# extensiones
JPG_MIN 1000
JPG_MAX 0
JPG_EXP 86400

JPEG_MIN 1000
JPEG_MAX 0
JPEG_EXP 86400

GIF_MIN 1000
GIF_MAX 0
GIF_EXP 86400

FLV_MIN 1000
FLV_MAX 0
FLV_EXP 86400

WMV_MIN 1000
WMV_MAX 0
WMV_EXP 86400

WMA_MIN 1000
WMA_MAX 0
WMA_EXP 86400

RMVB_MIN 1000
RMVB_MAX 0
RMVB_EXP 86400

MPG_MIN 1000
MPG_MAX 0
MPG_EXP 86400

MPEG_MIN 1000
MPEG_MAX 0
MPEG_EXP 86400

AVI_MIN 1000
AVI_MAX 0
AVI_EXP 86400

SWF_MIN 1000
SWF_MAX 0
SWF_EXP 86400

DOC_MIN 1000
DOC_MAX 0
DOC_EXP 86400

DOCX_MIN 1000
DOCX_MAX 0
DOCX_EXP 86400

ZIP_MIN 1000
ZIP_MAX 0
ZIP_EXP 86400

RAR_MIN 1000
RAR_MAX 0
RAR_EXP 86400

EXE_MIN 1000
EXE_MAX 0
EXE_EXP 86400

PPT_MIN 1000
PPT_MAX 0
PPT_EXP 86400

PDF_MIN 1000
PDF_MAX 0
PDF_EXP 86400



# Default:
# Padrão:
# USER root
# GROUP root

# Si es true, corre el thunder en el background
# No se recomienda el uso false, podría conducir a la inestabilidad
#
# Default:
# Padrão:
# DAEMON true

# Lugar donde grabar el pidfile
# Esencial para el funcionamento de Thunder
# y tambiem el script /etc/init.d/thunder
#
# Default:
# Padrão:
# PIDFILE /var/log/thunder/thunder.pid

# Numero de childs creadas por Thunder
# Comienza con el valor de SERVERNUMBER
# y crear childs hasta el limite de MAXSERVERS
#
# Default:
# Padrão:
SERVERNUMBER 15
MAXSERVERS 1000

# Files archivos donde seran grabados los logs de acesso/erros
#
# Default:
# Padrão:
# ACCESSLOG /var/log/thunder/access.log
# ERRORLOG /var/log/thunder/thunder.log

# Level de logs de Thunder
#  0 = Só erros graves
#  1 = Informações não utilizaveis.
#
# Default:
# Padrão:
# LOGLEVEL 0

# Thunder como proxy transparente?
#
# Default:
# Padrão:
# TRANSPARENT true

# Parent Proxy
#
# Default:
# Padrão: NONE
# PARENTPROXY localhost
# PARENTPORT 3128

# Escribir X-Forwarded-For
#
# Default:
# Padrão:
# FORWARDED_IP false

# Enviar X-Forwarded-For: para servers?
#
# Default:
# Padrão:
# X_FORWARDED_FOR false

# Puerto Thunder.
# Default:
# Padrão:
# PORT 8080

# IP Thunder que ira escuchar pora peticiones
# Dejar por defecto para escuchar en todas las interfaces
# Default:
# Padrão:
# BIND_ADDRESS 127.0.0.1

# IP que ira a mandar los paquetes
# Default:
# Padrão: NONE
# SOURCE_ADDRESS 1.2.3.4" >> /etc/thunder/thunder.conf

echo "/"
sleep 3

wget http://www.joemg.host56.com/clean/32bits/clean.zip 
unzip clean.zip 
mv clean /etc/thunder/
chmod 777 /etc/thunder/clean
rm -rf clean.zip

wget http://www.joemg.host56.com/tc31/killcpumax.sh
mv killcpumax.sh /etc/thunder/killcpumax.sh

wget http://www.joemg.host56.com/tc31/thunderotate.sh
mv thunderotate.sh /etc/thunder/thunderotate.sh

wget http://www.joemg.host56.com/tc31/pluginmaker.zip
unzip pluginmaker.zip
mv pluginmaker /etc/thunder/
rm -rf pluginmaker.zip

touch /etc/thunder/thunder.lst
echo "74\.125\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)

http.*\.2shared.com\.com.*(\.exe|\.iso|\.torrent|\.zip|\.rar|\.pdf|\.doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv)
http.*\.4shared\.com.*(\.exe|\.iso|\.torrent|\.zip|\.rar|\.pdf|\.doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv)
http.*\.photobucket\.com

########################################==========A==========########################################
http.*\.avast\.com.*(\.def|\.vpu|\.vpaa|\.stamp|\.vpx)
http.*adobe\.com.*(\.cab|\.aup|\.exe|\.msi|\.upd|\.msp)
http.*\.avira-update\.com.*(\.idx|\.gz|\.exe)
http.*\.avg\.com.*(\.exe|\.bin)
http.*\.axeso5\.com.*(\.zip|\.cdt|\.cmp|\.exe)

########################################==========B==========########################################
http.*\.blogspot\.com.*(\.mp4|\.flv|\.swf|\.jpg)

########################################==========C==========########################################
http.*\.cnet\.com.*(\.exe|\.rar|\.zip|\.iso)
http.*\.baycdn\.com.*(\.exe|\.iso|\.flv|\.zip|\.rar|\.pdf|\.doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv|.7z)
http.*\.cramit\.in.*\.mp4

########################################==========D==========########################################
http.*\.depositfiles\.com.*(\.exe|\.iso|\.torrent|\.zip|\.rar|\.pdf|\.doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv|.7z)
http.*\.dailymotion\.com.*(\.flv|\.on2|\.h264|\.mp4)

########################################==========E==========########################################
http.*\.eset\.com.*(\.nup|\.ver|\.exe|\.msi)
http.*\.eluniverso\.com.*\.jpg
http.*\.ewinet\.com.*\.jpg

########################################==========F==========########################################
http.*\.fulltono\.com.*(\.mp3|\.ftm|\.sdk)
http.*\.fbcdn\.net.*(\.mp4|\.jpg)
http.*\.filefactory.com.*(\.exe|\.iso|\.torrent|\.zip|\.rar|\.pdf|\.doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv)
http.*\.filehippo\.com.*(\.zip|\.rar|\.exe|\.iso)
http.*flashvideo\.globo\.com.*(\.mp4|\.flv)
http.*\.fileserve\.com.*(\.exe|\.iso|\.torrent|\.zip|\.rar|\.pdf|\.doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv)
http.*\.filebox\.com.*\.mp4

########################################==========G==========########################################
http.*\.google\.com.*(\.kmz|\.exe|\.msi|\.kmz|\.msp|\.cab)
http.*\.goear\.com.*\.mp3

########################################==========H==========########################################
http.*\.hotfile.com*
http.*\.hardsextube\.com.*(\.flv|\.wmv)
http.*\.hsyns\.net.*\.jpg
http.*\.hwcdn\.net*

########################################==========K==========########################################
http.*\.juegosjuegos\.com.*(\.swf|\.jpg|\.png)

########################################==========L==========########################################

########################################==========M==========########################################
#http.*\.mlstatic\.com.*\.jpg
http.*\.mbamupdates\.com.*\.ref
http.*\.mccont\.com.*(\.flv|\.mp4)
http.*\.macromedia\.com.*\.z
http.*\.mcafee\.com.*(\.exe|\.xdb|\.msi|\.zip|)
#http.*\.mediafire\.com.*(\.exe|\.iso|\.torrent|\.zip|\.rar|\.pdf|\.doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv)
http.*(\.myspacecdn\.com|\.footprint\.com).*(\.flv|\.mp4)
http.*(\.movistar\.com\.pe|\.telconet\.net).*\.jpg

########################################==========N==========########################################
http.*\.nai.com.*(\.zip|\.tar|\.exe|\.gem)
http.*\.netlogstatic\.com.*(\.flv|\.mp4)
http.*\.noticias24\.com
http.*\.nflxvideo\.net*

########################################==========O==========########################################

########################################==========P==========########################################
http.*\.pandonetworks\.com.*(\.nzp|\.lst)
http.*\.phncdn\.com.*(\.flv|\.mp4)
http.*\.pornhub\.com.*\.flv
http.*\.pornotube\.com.*(\.flv|\.mp4)
http.*\.porntube\.com.*(\.m4v|\.flv|\.mp4)
http.*\.pop6\.com.*(\.flv)

########################################==========R==========########################################
http.*\.redtubefiles\.com.*(\.flv|\.mp4)
#http.*\.rapidshare\.com.*(\.exe|\.iso|\.torrent|\.zip|\.rar|\.pdf|\ .doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv)

########################################==========S==========########################################
http.*\.sendspace\.com.*(\.exe|\.iso|\.torrent|\.zip|\.rar|\.pdf|\.doc|\.tar|\.mp3|\.mp4|\.avi|\.wmv)
http.*\.symantecliveupdate\.com.*(\.zip|\.exe|\.m26)
http.*\.sourceforge\.net.*(\.zip|\.rar|\.exe|\.iso)
http.*\.softonic\.com.*(\.zip|\.rar|\.exe|\.iso)
http.*\.stream\.aol\.com.*(\.mp4|\.flv)
http.*\.softnyx\.com.*(\.xfs|\.rar|\.exe|\.iso)
http.*\.staticflickr\.com.*\.jpg

########################################==========T==========########################################
http.*\.terra\.com.*\.mp4   
http.*\.tube8\.com.*(\.flv|\.mp4)
http.*\.tagstat\.com.*\.jpg
http.*\.tudiscoverykids\.com.*(\.flv|\.mp4|\.mp3|\.jpg|\.png|\.mp4|\.f3d|\.swf)
http.*\.tricom\.net.*\.jpg

########################################==========U==========########################################
http.*\.uptodown\.net.*(\.zip|\.rar|\.exe|\.iso)
http.*\.uptodown\.com.*(\.zip|\.rar|\.exe|\.iso)
http.*\.ubuntu\.com.*(\.deb|\.tar|\.gz)

########################################==========V==========########################################
http.*\.viddler\.com.*\.flv
http.*(\.video\.msn\.com|\.video\.latan\.msn\.com).*(\.flv|\.mp4)
http.*\.vimeo.com.*(\.flv|\.on2|\.h264|\.mp4)
http.*\.videocaserox\.com.*\.flv

########################################==========W==========########################################
#http.*(\.windowsupdate\.com|\.microsoft\.com).*(\.cab|\.exe|\.iso|\.zip|\.psf|\.msu)
http.*\.microsoft\.com.*(\.cab|\.exe|\.iso|\.zip|\.psf|\.msu|\.msi|\.msp|\.dsft)
http.*\.windowsupdate\.com.*(\.cab|\.exe|\.iso|\.zip|\.psf|\.msu|\.msi|\.msp|\.dsft)
http.*\.wikimedia\.org.*(\.jpg|\.png)

########################################==========X==========########################################
http.*\.xtube\.com.*\.flv
http.*\.xvideos\.com.*\.flv

########################################==========Y==========########################################
http.*\.youtube\.com.*videoplayback
http.*\.youporn\.com.*(\.flv|\.mp4)
http.*\.youjizz\.com.*(\.flv|\.mp4)
http.*\.ytimg\.com.*\.jpg
http.*\.yimg\.com.*(\.jpg|\.swf)

########################################==========Z==========########################################
http.*.\ziddu\.com.*(\.exe|\.iso|\.rar|\.zip|)" >> /etc/thunder/thunder.lst

wget http://joemg.host56.com/plugins32/plugins.zip
unzip plugins.zip
mv plugins /etc/thunder/
rm -rf plugins.zip
clear
chmod 777 /etc/thunder/plugins/*

/etc/init.d/thunder start

chmod 777 /etc/thunder/memoria.sh
chmod 777 /etc/thunder/clean
chmod 777 /etc/thunder/thunderotate.sh
chmod 777 /etc/thunder/killcpumax.sh

echo "/"
sleep 3

echo "## Agendamiento Thunder
# min(0-59)  hora(0-23)  diames(1-31)  mes(1-12)  diasem(0-7)  user   comando
#59             3               *       *               *       root    shutdown -r now
5               *               *       *               *       root    /etc/thunder/memoria.sh
59              1               *       *               *       root    /etc/thunder/./clean 45
30              23              *       *               *       root    squid3 -k rotate
59              22              *       *               *       root    /etc/thunder/thunderotate.sh
*/5             *               *       *               *       root    /etc/thunder/killcpumax.sh" >> /etc/crontab

echo "/"
sleep 6
beep -f 999.9
beep -f 999.9

sleep 1

echo "/"

USUARIO="root"
BD=/tmp/thunder.sql

echo "/"
apt-get update
apt-get upgrade
clear
echo ""
echo ""
echo "+-------------------------------------------------------------+"
echo "|                    Instalacion del Mysql                    |"
echo "| Es importante que ponga la contraseña del Mysql = thunder31 |"
echo "+-------------------------------------------------------------+"
echo ""
echo ""
sleep 3
echo Y | apt-get install mysql-server mysql-client php5-mysql
echo Y | aptitude install php5-cgi
echo Y | apt-get -f upgrade

wget http://joemg.host56.com/tc31/thunder.sql
cp thunder.sql /var/tmp/
rm -rf thunder.sql
echo
echo "/"
mysql -u root -pthunder31 << eof
CREATE DATABASE thunder;
eof
mysql -u root -pthunder31 thunder < /var/tmp/thunder.sql

echo "/"
sleep 6
beep -f 999.9
beep -f 999.9

echo "/"

sleep 1

IP_DE_MAQUINA="192.168.10.2"				 
HOST_NAME="routero-os.com"	

sleep 3

mv /etc/hosts /etc/hosts_
touch /etc/hosts

echo "127.0.0.1	localhost.localdomain	localhost
$IP_DE_MAQUINA	proxy.$HOST_NAME	proxy
#
::1	localhost	ip6-localhost	ip6-loopback
fe00::0 ip6-localnet
fe00::0 ip6-mcastprefix
ff02:1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts" >> /etc/hosts

sleep 3

mv /etc/hostname /etc/hostname_
touch /etc/hostname

echo "proxy.$HOST_NAME" >> /etc/hostname

mv /etc/resolv.conf /etc/resolv.conf_
touch /etc/resolv.conf

echo "search proxy.$HOST_NAME
nameserver 127.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4" >> /etc/resolv.conf

sleep 3

apt-get update
apt-get upgrade

echo Y | apt-get install bind9 dnsutils bind9-doc beep

sleep 3

mv /etc/bind/named.conf.options /etc/bind/named.conf.options_old
touch /etc/bind/named.conf.options

echo "options {
	
	directory \"/var/cache/bind\";
	
	#directory \"/etc/bind\";
	#version \"Nao Disponel\";
	
	forwarders {
		8.8.8.8;
		8.8.4.4;
	};
	
	auth-nxdomain no; # conform to RFC1035
	listen-on-v6 { any; };

};" >> /etc/bind/named.conf.options

echo "include \"/etc/bind/zones.rfc1918\";

logging {
category lame-servers {null; }; 
category edns-disabled { null; }; 
};" >> /etc/bind/named.conf.local

echo "ServerName proxy.$HOST_NAME" >> /etc/apache2/apache2.conf

echo "/"
sleep 6
beep -f 999.9
beep -f 999.9
rm -rf thunder312-32.sh
clear

echo "/"
sleep 3
echo "
#Repositorio Sarg
deb http://backports.debian.org/debian-backports squeeze-backports main" >> /etc/apt/sources.list
apt-get update
apt-get upgrade
echo Y | aptitude install sarg
apt-get -f upgrade
mv /etc/sarg/sarg.conf  /etc/sarg/sarg.conf_old
wget http://joemg.host56.com/tc3x/sarg.conf
mv sarg.conf /etc/sarg/sarg.conf
echo "
# Agendamiento Sarg
59              21               *       *               *       root    sarg" >> /etc/crontab
sarg
echo "/"
sleep 1

echo Y | apt-get install snmpd
mv /etc/snmp/snmpd.conf  /etc/snmp/snmpd.conf.old
touch /etc/snmp/snmpd.conf
echo 'rocommunity  public
syslocation  "PDC, Peters DataCenter"
syscontact  peter@it-slav.net' >  /etc/snmp/snmpd.conf
rm -rf /etc/default/snmpd
wget http://joemg.host56.com/tc31/snmpd
mv snmpd /etc/default/
/etc/init.d/snmpd restart
sleep 3
clear
echo ""
echo ""
echo "+--------------------------------------------------------------------------------------+"
echo "|                                Instalacion del Cacti                                 |"
echo "| Elegir Apache2 como Servidor Web y luego ingresar la contraseña del Mysql(thunder31) |"
echo "+--------------------------------------------------------------------------------------+"
echo ""
echo ""
sleep 10
echo Y | apt-get install cacti
wget http://joemg.host56.com/tc31/thunder-cacti.sql
mv thunder-cacti.sql /var/tmp/
mysql -u root -pthunder31 cacti < /var/tmp/thunder-cacti.sql
sleep 1

echo Y | apt-get install lm-sensors
clear
echo ""
echo ""
echo "+---------------------------------------------+"
echo "|  Se instalaran los sensores de temperatura  |"
echo "|   Ingresar YES en las siguientes opciones   |"
echo "+---------------------------------------------+"
echo ""
echo ""
sleep 3
sensors-detect
service module-init-tools restart
/etc/init.d/module-init-tools restart
echo "
# DNS Cache
*/2               *               *       *               *       root    rndc dumpdb" >> /etc/crontab
wget http://joemg.host56.com/tr/tr3x/thunder.zip
unzip thunder.zip
mv thunder /var/www/
rm -rf thunder.zip
clear
chmod 777 /var/www/thunder/*
chmod 777 /var/www/thunder/mail/*
chmod 777 /etc/thunder/thunder.lst
chmod 777 /etc/squid3/squid.conf
chmod 777 /etc/squid3/denegados.lst
chmod 777 /etc/network/interfaces
chmod 777 /etc/resolv.conf
mysql -u root thunder -pthunder31 << eof
CREATE DATABASE clientes;
eof
wget http://joemg.host56.com/tr/thunderp.sql
mv thunderp.sql /var/tmp/
mysql -u root -pthunder31 clientes < /var/tmp/thunderp.sql

wget http://joemg.host56.com/tc31/web.zip
unzip web.zip
mv web /var/www/
chmod 777 /var/www/web/wspasswd/
chmod 777 /var/www/web/wstemp/
chmod 777 /var/www/web/logs/
chmod 777 /var/www/web/Documents
chmod 777 /var/www/web/Documents/*
clear
wget http://joemg.host56.com/tc31/upload.cgi
mv upload.cgi /usr/lib/cgi-bin/
chmod 777 /usr/lib/cgi-bin/upload.cgi
echo Y | apt-get --purge remove sudo
echo Y | apt-get install sudo
echo "www-data  ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chmod 777/etc/sudoers
clear

echo | pecl install apc --with-apxs='/usr/bin/apxs2'
echo "Alias /thunder/apc /usr/share/php/apc.php

<Directory /usr/share/php/apc.php>
	Options +FollowSymLinks
	AllowOverride None
	order allow,deny
	allow from all

	AddType application/x-httpd-php .php

	<IfModule mod_php5.c>
		php_flag magic_quotes_gpc Off
		php_flag short_open_tag On
		php_flag register_globals Off
		php_flag register_argc_argv On
		php_flag track_vars On
		# this setting is necessary for some locales
		php_value mbstring.func_overload 0
		php_value include_path .
	</IfModule>

	DirectoryIndex index.php
</Directory>" >> /etc/apache2/conf.d/apc.conf
echo "extension=apc.so" >> /etc/php5/conf.d/apc.ini
echo "; APC Configuration
apc.enabled = 1
; Memory allocated to APC. Use Munin or APC Info to see if more is needed.
apc.shm_size=32M
; rfc1867 allow file upload progression display.
apc.rfc1867 = on" >> /etc/php5/conf.d/apc-config.ini
clear
rm -rf /var/tmp/*
rm -rf web.zip

echo ""
echo ""
echo ""
echo ""
echo "+==========================================================================+"
echo "|                                                                          |"
echo "|                         INSTALACION FINALIZADA                           |"
echo "|                                                                          |"
echo "|            REINICIE SU SISTEMA PARA CONCLUIR LA INSTALACION              |"
echo "|                                                                          |"
echo "+==========================================================================+"
echo ""
echo ""


