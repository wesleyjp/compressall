#!/bin/bash
#Desenvolvido por wesley Junio nov/2023
#Diminui o tamanho de todos os =arquivos de videos em uma pasta

#read -p "Press enter to continue"

dialog --title "Compactall" --msgbox "Programa desenvolvido por Wesley Junio - nov/2023 \\n \\n
Esse programa diminui o tamanho de todos os arquivos de videos em uma pasta. \\n 
Ao clicar em \"SIM\" todos os arquivos de videos serão compactados. \\n
Os arquivos não serão excluidos, apenas será criado uma pasta \"compact\", onde os videos serão salvos.  \\n \\n
/!\ ATENÇÂO /!\  \\nEsse programa precisa de aguns componentes para seu funcionamento, caso não estejam instalados
será necessario fazer a instalação deles manualmente \\n
Lista de componentes necessarios: \\n
-FFmpeg\\n-beep\\n" 20 80

dialog --yesno "Deseja continuar?" 0 0

if [ $? == 1 ];then clear;exit; fi

#Verifica componentes
#dialog --title "ERROR" --msgbox "" 20 80

FILES="*"
THIS=${0:2}
ERRORS=0

for i in $FILES 
do
	TOTALFILES=$((TOTALFILES+1))			
done

mkdir ./compact

for f in $FILES
do
	COUNT=$((COUNT+1))
	PORCENT=$(echo "scale=2;(${COUNT} / ${TOTALFILES})*100" | bc)

	clear

	echo ${PORCENT: 0:-3} | dialog --title "STATUS" --gauge "Processando arquivos... ${COUNT}/${TOTALFILES} ${f}" \ 20 80 0

	ffmpeg -y -i "${f}" -vcodec libx265 -crf 28 -filter:v fps=30 "./compact/${f}">/dev/null 2>&1 # > /dev/null 2>&1 oculta saida redirecionando

	if [ $? -ne 0 ]; then 
		ERRORS=$((ERRORS+1)) 
		ERRORSFILES=$(echo "${ERRORSFILES}${f}, ")
	fi


done
echo "$(date) - Operação concluida / Erros: ${ERRORS} / Total de Arquivos: ${TOTALFILES} / LISTA DE ARQUIVOS NÃO PROCESSADOS: ${ERRORSFILES}">>./compact/erroslog.log
dialog --title "STATUS" --msgbox "Operação concluida / Erros: ${ERRORS}\\nLISTA DE ARQUIVOS NÃO PROCESSADOS: ${ERRORSFILES}" 20 80
clear

