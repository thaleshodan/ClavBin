# ClavBin

**ClavBin** é uma ferramenta de segurança e automação de terminal desenvolvida em **Bash**. Ela combina funcionalidades de firewall e assistente de funções, permitindo que os usuários realizem tarefas de segurança, monitoramento de rede e automação diretamente pelo terminal, de maneira eficiente e sem a necessidade de interfaces gráficas. Além disso, oferece um controle granular sobre as conexões de rede e facilita a configuração de proxies para anonimato.

## Funcionalidades

- **Firewall em Terminal**: Controla o tráfego de rede no sistema, permitindo ou bloqueando pacotes com base em regras de filtragem configuráveis. O firewall é gerido diretamente via terminal, oferecendo flexibilidade e alto desempenho.
  
- **Assistente de Funções**: Oferece uma série de funções de automação para facilitar a administração do sistema, como verificações de segurança, monitoramento de tráfego de rede e ajustes rápidos em configurações de rede.

- **Escaneamento Antivírus (Integrado com ClamAV)**: Realiza varreduras no sistema em busca de malwares e vírus, utilizando o motor **ClamAV** para garantir que o ambiente esteja livre de ameaças.

- **Integração com Proxychains**: Permite que o tráfego de rede seja roteado através de uma cadeia de proxies configuráveis, garantindo anonimato e maior segurança durante a navegação.

## Instalação

### Pré-requisitos

- **ClamAV**: A ferramenta utiliza **ClamAV** para escaneamento de vírus e malwares. Certifique-se de tê-lo instalado antes de executar ClavBin.
  
- **Dependências de Sistema**:
  - `iptables` (para configuração do firewall)
  - `Proxychains` (se desejar usar a funcionalidade de proxy)

### Passos para Instalação

1. **Clone o repositório**:

   Clone o repositório do GitHub para o seu sistema:
   ```bash
   git clone https://github.com/seu-usuario/clavbin.git
   cd ClavBin
