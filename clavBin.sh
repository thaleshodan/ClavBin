#!/bin/bash

# Definir cores para impressão colorida
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Resetar cor
YELLOW='\033[1;33m'

# Função para exibir logo do software (ASCII art)
exibir_logo() {
    echo -e "${GREEN}######   #######  ######## ######## #######  ######      ##     ##  ##"
    echo -e "${GREEN}##  ##   ##  ##  #  ##  # #  ##  #  ##  ##   ##  ##    ####    ##  ##"
    echo -e "${GREEN}##  ##   ##         ##       ##     ##       ##  ##   ##  ##   ##  ##"
    echo -e "${GREEN}#####    ####       ##       ##     ####     #####    ######   ##  ##"
    echo -e "${GREEN}##  ##   ##         ##       ##     ##       ####     ##  ##   ##  ##"
    echo -e "${GREEN}##  ##   ##  ##     ##       ##     ##  ##   ## ##    ##  ##    ####"
    echo -e "${GREEN}######   #######    ####     ####   #######  ###  ##   ##  ##     ##"
    echo -e "${NC}"
    echo -e "${YELLOW}Made by userdenied3301${NC}"
}

# Função para instalar o proxychains
instalar_proxychains() {
    echo -e "${YELLOW}[*] Verificando a distribuição do sistema...${NC}"
    
    if [ -f /etc/debian_version ]; then
        # Debian / Ubuntu
        echo -e "${YELLOW}[*] Instalando Proxychains para Debian/Ubuntu...${NC}"
        sudo apt-get update && sudo apt-get install -y proxychains
        # Comando usado: sudo apt-get update && sudo apt-get install -y proxychains
    elif [ -f /etc/redhat-release ]; then
        # CentOS / RHEL
        echo -e "${YELLOW}[*] Instalando Proxychains para CentOS/RHEL...${NC}"
        sudo yum install -y proxychains
        # Comando usado: sudo yum install -y proxychains
    elif [ -f /etc/fedora-release ]; then
        # Fedora
        echo -e "${YELLOW}[*] Instalando Proxychains para Fedora...${NC}"
        sudo dnf install -y proxychains
        # Comando usado: sudo dnf install -y proxychains
    elif [ -f /etc/arch-release ]; then
        # Arch Linux
        echo -e "${YELLOW}[*] Instalando Proxychains para Arch Linux...${NC}"
        sudo pacman -Syu --noconfirm proxychains-ng
        # Comando usado: sudo pacman -Syu --noconfirm proxychains-ng
    else
        echo -e "${RED}[!] Sistema não suportado para instalação automática do Proxychains.${NC}"
        return 1
    fi

    # Verificar se o Proxychains foi instalado com sucesso
    if command -v proxychains >/dev/null 2>&1; then
        echo -e "${GREEN}[OK] Proxychains instalado com sucesso!${NC}"
    else
        echo -e "${RED}[!] Falha ao instalar Proxychains.${NC}"
        return 1
    fi
}

# Função para configurar Proxychains
configurar_proxychains() {
    echo -e "${YELLOW}[*] Configurando o Proxychains...${NC}"
    # Editando o arquivo de configuração para permitir o uso de proxies SOCKS5
    sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf
    sudo sed -i 's/^#strict_chain/strict_chain/' /etc/proxychains.conf
    sudo sed -i 's/^#proxy_dns/proxy_dns/' /etc/proxychains.conf
    echo "socks5 127.0.0.1 1080" | sudo tee -a /etc/proxychains.conf
    # Comandos usados:
    # sudo sed -i 's/^#dynamic_chain/dynamic_chain/' /etc/proxychains.conf
    # sudo sed -i 's/^#strict_chain/strict_chain/' /etc/proxychains.conf
    # sudo sed -i 's/^#proxy_dns/proxy_dns/' /etc/proxychains.conf
    # echo "socks5 127.0.0.1 1080" | sudo tee -a /etc/proxychains.conf
    echo -e "${GREEN}[OK] Proxychains configurado para usar proxy SOCKS5 na porta 1080.${NC}"
}

# Função para verificar o status do sistema
verificar_status() {
    echo -e "${YELLOW}[*] Verificando o status do sistema...${NC}"
    # Exibir informações do sistema com comandos padrão
    echo -e "${GREEN}[OK] Informações sobre o sistema:${NC}"
    uname -a
    # Comando usado: uname -a
    
    echo -e "${GREEN}[OK] Uso de memória:${NC}"
    free -h
    # Comando usado: free -h
    
    echo -e "${GREEN}[OK] Espaço em disco:${NC}"
    df -h
    # Comando usado: df -h
}

# Função para escanear a rede com nmap
escaneamento_rede() {
    echo -e "${YELLOW}[*] Escaneando a rede local com nmap...${NC}"
    read -p "Digite o IP ou a faixa de IPs (ex: 192.168.1.0/24): " ip_range
    sudo nmap -sP "$ip_range"
    # Comando usado: sudo nmap -sP "$ip_range"
}

# Função para escanear arquivos com ClamAV
escaneamento_clamav() {
    echo -e "${YELLOW}[*] Escaneando arquivos com ClamAV...${NC}"
    read -p "Digite o diretório ou arquivo para escanear: " caminho
    sudo clamscan -r "$caminho"
    # Comando usado: sudo clamscan -r "$caminho"
}

# Função para atualizar o sistema
atualizar_sistema() {
    echo -e "${YELLOW}[*] Atualizando o sistema...${NC}"
    if [ -f /etc/debian_version ]; then
        sudo apt-get update && sudo apt-get upgrade -y
        # Comando usado: sudo apt-get update && sudo apt-get upgrade -y
    elif [ -f /etc/redhat-release ]; then
        sudo yum update -y
        # Comando usado: sudo yum update -y
    elif [ -f /etc/fedora-release ]; then
        sudo dnf update -y
        # Comando usado: sudo dnf update -y
    elif [ -f /etc/arch-release ]; then
        sudo pacman -Syu --noconfirm
        # Comando usado: sudo pacman -Syu --noconfirm
    else
        echo -e "${RED}[!] Sistema não suportado para atualização automática.${NC}"
        return 1
    fi
    echo -e "${GREEN}[OK] Sistema atualizado com sucesso!${NC}"
}

# Menu interativo para o usuário
menu_principal() {
    exibir_logo
    echo "-------------------------------------------------"
    echo "1 - Instalar Proxychains"
    echo "2 - Configurar Proxychains"
    echo "3 - Verificar status do sistema"
    echo "4 - Escanear a rede com nmap"
    echo "5 - Escanear arquivos com ClamAV"
    echo "6 - Atualizar o sistema"
    echo "7 - Sair"
    echo "-------------------------------------------------"
    
    read -p "Escolha uma opção: " opcao
    case $opcao in
        1)
            instalar_proxychains
            ;;
        2)
            configurar_proxychains
            ;;
        3)
            verificar_status
            ;;
        4)
            escaneamento_rede
            ;;
        5)
            escaneamento_clamav
            ;;
        6)
            atualizar_sistema
            ;;
        7)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Opção inválida!${NC}"
            ;;
    esac
}

# Chamar o menu principal
menu_principal
