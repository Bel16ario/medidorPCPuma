#!/bin/bash
#Luca Belaunzarán, Septiembre de 2023
#Este script extrae la información de la conexión inalámbrica indicada utilizando iw y la deposita en una tabla en un documento .csv
#eg: ./analizador.sh wlp1s0

#Verificando que los argumentos se hayan pasado
if [ -z $1 ]
then
	echo Error. Dispositivos no especificados. Sintaxis: ./analizador.sh DISPOSITIVO ARCHIVOS ETIQUETA
	exit 1
fi
if [ -z $2 ]
then
	echo Error. Archivos no especificados. Sintaxis: ./analizador.sh DISPOSITIVO ARCHIVOS ETIQUETA
	exit 2
fi
if [ -z $3 ]
then
	echo Error. Etiqueta no especificada. Sintaxis: ./analizador.sh DISPOSITIVO ARCHIVOS ETIQUETA
	exit 3
fi
usuario="Luca Eugenio Belaunzarán Consejo"
fecha=$(date)
fechaB=$(echo $fecha|cut -d' ' -f 2-4)
echo Buscando archivos...
#Verificando la existencia de archivos
existe=$(ls | grep -w $2)
existe=$(echo $existe | cut -d' ' -f 6)
csv=".csv"
csv=$2$csv
if [ -z $existe ]
then	
	echo No existen archivos...
	echo Creando archivos...
	n=0
	touch $csv
	touch $2
	echo $n >> $2
	echo "PUNTO DE ACCESO, REVISÓ, HORA, SUBIDA, BAJADA, FRECUENCIA, ATENUAMIENTO, SSID, MAC">>$csv
else	
	echo Archivos encontrados...
	n=$(cat $2)

fi
echo Buscando conexión...
largo=$(iw dev $1 link)
b=$(echo $?)
#Verificando que iw se haya ejecutado sin problemas
if [ $b -ne 0 ]
then
	echo Error. Verifique que iw esté instalado y que el nombre de su dispositivo sea correcto. ej: ./analizador.sh wlp1s0 mediciones A105
	exit 4
fi
#Extrayendo datos
mac=$(echo $largo|cut -d' ' -f 3)
ssid=$(echo $largo|cut -d' ' -f 7-)
ssid=$(echo $ssid|cut -d':' -f -1)
ssid=$(echo $ssid|rev|cut -d' ' -f 2-|rev)
frec=$(echo $largo|cut -d' ' -f 9)
paqR=$(echo $largo|cut -d' ' -f 13)
paqR=$(echo $paqR|cut -c 2-)
paqT=$(echo $largo|cut -d' ' -f 18)
paqT=$(echo $paqT|cut -c 2-)
se=$(echo $largo|cut -d' ' -f 21)
tazaR=$(echo $largo|cut -d' ' -f 25)
tazaT=$(echo $largo|cut -d' ' -f 25-)
tazaT=$(echo $tazaT|cut -d':' -f 1)
tazaT=$(echo $tazaT|cut -d' ' -f -1)
hora=$(echo $fecha|cut -d' ' -f 5)
#Depositando datos
ba='\'
echo Escribiendo csv...
echo "$3 , $usuario,  $hora , $tazaT , $tazaR , $frec , $se , $ssid , $mac">>$csv
n=$(($n + 1))
rm $2
touch $2
echo $n >> $2
echo Exito
exit 0
