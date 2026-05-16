#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Configurador de Múltiplas Contas Git${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Função para validar email
validate_email() {
    if [[ $1 =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Coletando informações globais
echo -e "${YELLOW}=== Configurações Globais ===${NC}"
read -p "Nome completo: " FULL_NAME
read -p "Branch padrão (main/master): " DEFAULT_BRANCH
DEFAULT_BRANCH=${DEFAULT_BRANCH:-main}

echo ""
echo -e "${YELLOW}=== Conta Pessoal ===${NC}"
read -p "Email pessoal: " PERSONAL_EMAIL
while ! validate_email "$PERSONAL_EMAIL"; do
    echo -e "${RED}Email inválido. Tente novamente.${NC}"
    read -p "Email pessoal: " PERSONAL_EMAIL
done

read -p "Diretório de projetos pessoais (ex: ~/Development/github): " PERSONAL_DIR
PERSONAL_DIR="${PERSONAL_DIR/#\~/$HOME}"

read -p "Nome para a chave SSH pessoal (padrão: id_rsa_pessoal): " PERSONAL_KEY_NAME
PERSONAL_KEY_NAME=${PERSONAL_KEY_NAME:-id_rsa_pessoal}

read -p "Host Git pessoal (github.com/gitlab.com): " PERSONAL_HOST

echo ""
echo -e "${YELLOW}=== Conta de Trabalho ===${NC}"
read -p "Email do trabalho: " WORK_EMAIL
while ! validate_email "$WORK_EMAIL"; do
    echo -e "${RED}Email inválido. Tente novamente.${NC}"
    read -p "Email do trabalho: " WORK_EMAIL
done

read -p "Diretório de projetos do trabalho (ex: ~/Development/empresa): " WORK_DIR
WORK_DIR="${WORK_DIR/#\~/$HOME}"

read -p "Nome para a chave SSH do trabalho (padrão: id_rsa_trabalho): " WORK_KEY_NAME
WORK_KEY_NAME=${WORK_KEY_NAME:-id_rsa_trabalho}

read -p "Host Git do trabalho (github.com/gitlab.com): " WORK_HOST

# Criar diretórios se não existirem
echo ""
echo -e "${BLUE}Criando diretórios...${NC}"
mkdir -p "$PERSONAL_DIR"
mkdir -p "$WORK_DIR"
echo -e "${GREEN}✓ Diretórios criados${NC}"

# Gerar chaves SSH
echo ""
echo -e "${BLUE}Gerando chaves SSH...${NC}"
ssh-keygen -t rsa -b 4096 -C "$PERSONAL_EMAIL" -f "$HOME/.ssh/$PERSONAL_KEY_NAME" -N ""
ssh-keygen -t rsa -b 4096 -C "$WORK_EMAIL" -f "$HOME/.ssh/$WORK_KEY_NAME" -N ""
echo -e "${GREEN}✓ Chaves SSH geradas${NC}"

# Adicionar chaves ao ssh-agent
echo ""
echo -e "${BLUE}Adicionando chaves ao ssh-agent...${NC}"
eval "$(ssh-agent -s)" > /dev/null
ssh-add "$HOME/.ssh/$PERSONAL_KEY_NAME"
ssh-add "$HOME/.ssh/$WORK_KEY_NAME"
echo -e "${GREEN}✓ Chaves adicionadas ao ssh-agent${NC}"

# Configurar arquivo SSH config
echo ""
echo -e "${BLUE}Configurando SSH config...${NC}"
cat > "$HOME/.ssh/config" << EOF
# Conta pessoal
Host $PERSONAL_HOST
   HostName $PERSONAL_HOST
   User git
   IdentityFile ~/.ssh/$PERSONAL_KEY_NAME

# Conta do trabalho
Host $WORK_HOST-trabalho
   HostName $WORK_HOST
   User git
   IdentityFile ~/.ssh/$WORK_KEY_NAME
EOF
echo -e "${GREEN}✓ SSH config configurado${NC}"

# Criar arquivos de configuração Git
echo ""
echo -e "${BLUE}Criando configurações Git...${NC}"

# Config pessoal
cat > "$HOME/.gitconfig-pessoal" << EOF
[user]
  email = $PERSONAL_EMAIL
EOF

# Config trabalho
cat > "$HOME/.gitconfig-trabalho" << EOF
[user]
  email = $WORK_EMAIL
EOF

# Backup do .gitconfig existente
if [ -f "$HOME/.gitconfig" ]; then
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
    echo -e "${YELLOW}⚠ Backup do .gitconfig existente criado: ~/.gitconfig.backup${NC}"
fi

# Criar .gitconfig principal
cat > "$HOME/.gitconfig" << EOF
[user]
  name = $FULL_NAME

[init]
  defaultBranch = $DEFAULT_BRANCH

[includeIf "gitdir:$PERSONAL_DIR/"]
  path = .gitconfig-pessoal

[includeIf "gitdir:$WORK_DIR/"]
  path = .gitconfig-trabalho
EOF

echo -e "${GREEN}✓ Configurações Git criadas${NC}"

# Exibir chaves públicas
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Configuração concluída com sucesso!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${YELLOW}📋 Suas chaves públicas SSH:${NC}\n"

echo -e "${BLUE}=== Chave Pessoal ($PERSONAL_HOST) ===${NC}"
cat "$HOME/.ssh/$PERSONAL_KEY_NAME.pub"
echo ""

echo -e "${BLUE}=== Chave de Trabalho ($WORK_HOST) ===${NC}"
cat "$HOME/.ssh/$WORK_KEY_NAME.pub"
echo ""

echo -e "${YELLOW}📝 Próximos passos:${NC}"
echo "1. Adicione a chave pessoal em: https://$PERSONAL_HOST/settings/keys"
echo "2. Adicione a chave de trabalho em: https://$WORK_HOST/settings/keys"
echo ""
echo -e "${YELLOW}📁 Estrutura de pastas:${NC}"
echo "  Pessoal: $PERSONAL_DIR"
echo "  Trabalho: $WORK_DIR"
echo ""
echo -e "${YELLOW}🔧 Para clonar repositórios de trabalho:${NC}"
echo "  git clone git@$WORK_HOST-trabalho:usuario/repo.git"
echo ""
echo -e "${YELLOW}🔧 Para clonar repositórios pessoais:${NC}"
echo "  git clone git@$PERSONAL_HOST:usuario/repo.git"
