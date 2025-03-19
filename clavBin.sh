#!/bin/bash

# Cores
CYAN='\033[1;36m'  # Azul ciano
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'       # Resetar cor

# Função para log de atividades
log_activity() {
    local activity=$1
    local log_file="/var/log/clavbin_activity.log"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $activity" >> $log_file
}

# Função para verificar se  pacotes estão instalados no S.O e instalá-los se necessário
instalar_pacote() {
    local pacote=$1
    if ! command -v $pacote &> /dev/null; then
        echo -e "${YELLOW}[~] $pacote não encontrado. Instalando...${NC}"
        if [[ $PACKAGE_MANAGER == "apt" ]]; then
            sudo apt update && sudo apt install -y $pacote || { echo -e "${RED}[!] Erro ao instalar $pacote!${NC}"; exit 1; }
        elif [[ $PACKAGE_MANAGER == "yum" ]]; then
            sudo yum install -y $pacote || { echo -e "${RED}[!] Erro ao instalar $pacote!${NC}"; exit 1; }
        elif [[ $PACKAGE_MANAGER == "pacman" ]]; then
            sudo pacman -S --noconfirm $pacote || { echo -e "${RED}[!] Erro ao instalar $pacote!${NC}"; exit 1; }
        fi
        echo -e "${WHITE}[OK] $pacote instalado com sucesso!${NC}"
    else
        echo -e "${GREEN}[+] $pacote já está instalado.${NC}"
    fi
}

# Função para detectar  distribuição do Linux
detect_distribuicao() {
    if [ -f /etc/debian_version ]; then
        DISTRO="Debian/Ubuntu"
        PACKAGE_MANAGER="apt"
    elif [ -f /etc/redhat-release ]; then
        DISTRO="RedHat/CentOS"
        PACKAGE_MANAGER="yum"
    elif [ -f /etc/arch-release ]; then
        DISTRO="Arch"
        PACKAGE_MANAGER="pacman"
    else
        DISTRO="Desconhecido"
        PACKAGE_MANAGER=""
    fi
}

# Função para exibir o logo
exibir_logo() {
    clear
    echo -e "${CYAN}"
    echo " ██████╗██╗      █████╗ ███╗   ███╗██████╗ ██╗███╗   ██╗"
    echo "██╔════╝██║     ██╔══██╗████╗ ████║██╔══██╗██║████╗  ██║"
    echo "██║     ██║     ███████║██╔████╔██║██████╔╝██║██╔██╗ ██║"
    echo "██║     ██║     ██╔══██║██║╚██╔╝██║██╔══██╗██║██║╚██╗██║"
    echo "╚██████╗███████╗██║  ██║██║ ╚═╝ ██║██████╔╝██║██║ ╚████║"
    echo " ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝"
    echo -e "${NC}"
    echo -e "${YELLOW}          🔥 Created by userdenied3301 🔥${NC}"
}

# Função para exibir o menu principal
menu_principal() {
    while true; do
        clear
        exibir_logo
        echo -e "${CYAN}════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}  [1]${WHITE} Instalar Proxychains"
        echo -e "${GREEN}  [2]${WHITE} Configurar Proxychains"
        echo -e "${GREEN}  [3]${WHITE} Instalar GUI de Firewall"
        echo -e "${GREEN}  [4]${WHITE} Verificar status do sistema"
        echo -e "${GREEN}  [5]${WHITE} Escanear a rede com nmap"
        echo -e "${GREEN}  [6]${WHITE} Escanear arquivos com ClamAV"
        echo -e "${GREEN}  [7]${WHITE} Atualizar o sistema"
        echo -e "${RED}  [8] Sair${NC}"
        echo -e "${CYAN}════════════════════════════════════════════════${NC}"
        
        read -p $'\e[1;33m[~] Escolha uma opção: \e[0m' opcao
        case $opcao in
            1) 
                carregando
                instalar_proxychains 
                ;;
            2) 
                carregando
                configurar_proxychains 
                ;;
            3) 
                carregando
                instalar_gui_firewall 
                ;;
            4) 
                carregando
                verificar_status 
                ;;
            5) 
                carregando
                escaneamento_rede 
                ;;
            6) 
                carregando
                escaneamento_clamav 
                ;;
            7) 
                carregando
                atualizar_sistema 
                ;;
            8) 
                echo -e "${RED}[!] Saindo...${NC}"
                exit 0
                ;;
            *) 
                echo -e "${RED}[!] Opção inválida!${NC}"
                sleep 1
                ;;
        esac
    done
}

# Função para mostrar animação de carregamento
carregando() {
    echo -ne "${GREEN}[+] Processando...${NC}"
    for i in {1..5}; do
        echo -ne "."
        sleep 0.3
    done
    echo -e " ${WHITE}[OK]${NC}"
    sleep 0.5
}

# Função para verificar status do sistema com htop em modelo GUI no próprio terminal
verificar_status() {
    echo -e "${CYAN}[+] Verificando status do sistema...${NC}"
    if ! command -v htop &> /dev/null; then
        echo -e "${YELLOW}[~] htop não encontrado. Instalando...${NC}"
        instalar_pacote "htop"
    fi
    echo -e "${GREEN}[+] Iniciando htop...${NC}"
    htop || { echo -e "${RED}[!] Erro ao iniciar htop!${NC}"; exit 1; }
}

# Função para verificar e exibir o status do firewall via GUI (gufw)
verificar_firewall_gui() {
    echo -e "${CYAN}[+] Verificando status do firewall...${NC}"
    if ! command -v gufw &> /dev/null; then
        echo -e "${YELLOW}[~] gufw não encontrado. Instalando...${NC}"
        instalar_pacote "gufw"
    fi
    echo -e "${GREEN}[+] Iniciando GUI do firewall...${NC}"
    sudo gufw &  # Executando o gufw em segundo plano
}

# Função para escanear a rede com nmap
escaneamento_rede() {
    echo -e "${CYAN}[+] Escaneando rede com nmap...${NC}"
    read -p $'\e[1;33m[~] Digite o IP da rede a ser escaneada: \e[0m' ip_rede
    nmap $ip_rede & # Executando em segundo plano
    echo -e "${WHITE}[OK] Escaneamento da rede em andamento...${NC}"
}

# Função para escanear arquivos com ClamAV
escaneamento_clamav() {
    echo -e "${CYAN}[+] Escaneando arquivos com ClamAV...${NC}"
    sudo freshclam
    read -p $'\e[1;33m[~] Digite o diretório ou arquivo a ser escaneado: \e[0m' caminho
    clamscan -r $caminho > resultado_escaneamento.txt
    echo -e "${WHITE}[OK] Escaneamento concluído! Relatório salvo em 'resultado_escaneamento.txt'.${NC}"
}

# Função para atualizar o sistema
atualizar_sistema() {
    echo -e "${CYAN}[+] Atualizando o sistema...${NC}"
    if [[ $PACKAGE_MANAGER == "apt" ]]; then
        sudo apt update && sudo apt upgrade -y || { echo -e "${RED}[!] Erro ao atualizar o sistema!${NC}"; exit 1; }
    elif [[ $PACKAGE_MANAGER == "yum" ]]; then
        sudo yum update -y || { echo -e "${RED}[!] Erro ao atualizar o sistema!${NC}"; exit 1; }
    elif [[ $PACKAGE_MANAGER == "pacman" ]]; then
        sudo pacman -Syu --noconfirm || { echo -e "${RED}[!] Erro ao atualizar o sistema!${NC}"; exit 1; }
    fi
    echo -e "${WHITE}[OK] Sistema atualizado com sucesso!${NC}"
}

# Função para instalar e configurar Proxychains
instalar_proxychains() {
    echo -e "${CYAN}[+] Instalando Proxychains...${NC}"
    instalar_pacote "proxychains"
    echo -e "${GREEN}[+] Proxychains instalado!${NC}"
}

configurar_proxychains() {
    echo -e "${CYAN}[+] Configurando Proxychains...${NC}"
    sudo nano /etc/proxychains.conf
    echo -e "${WHITE}[OK] Configuração do Proxychains concluída!${NC}"
}

# Função para instalar GUI de firewall
instalar_gui_firewall() {
    echo -e "${CYAN}[+] Instalando GUI de Firewall...${NC}"
    instalar_pacote "ufw"
    sudo ufw enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    echo -e "${WHITE}[OK] GUI de Firewall instalada e configurada!${NC}"
}

# Chama a função principal em looping com o encerramento só sendo permitido pelo usuario
detect_distribuicao
menu_principal
