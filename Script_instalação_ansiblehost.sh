#!/bin/bash

# --- Script para criar e configurar o usuário de controle do Ansible ---
#
# O que ele faz:
# 1. Verifica se o usuário 'ansiblehost' existe. Se não, o cria.
# 2. Configura permissões de sudo sem senha para esse usuário de forma segura.
# 3. Adiciona uma chave pública SSH para permitir o acesso sem senha.

# --- VARIÁVEIS ---
# Nome do usuário que será criado e gerenciado pelo script.
TARGET_USER="ansiblehost"

# --- EXECUÇÃO ---

# 1. VERIFICA SE O SCRIPT ESTÁ SENDO EXECUTADO COMO ROOT
if [[ $(id -u) -ne 0 ]]; then 
  echo "ERRO: Este script precisa ser executado com sudo para criar usuários e configurar permissões." [cite: 2]
  echo "Tente: sudo ./$(basename "$0")" [cite: 3]
  exit 1
fi

# 2. CRIAÇÃO DO USUÁRIO (SE NECESSÁRIO)
if ! id "$TARGET_USER" &>/dev/null; then 
  echo "Usuário '$TARGET_USER' não encontrado. Criando..."
  # Cria o usuário com diretório home (-m) e um comentário descritivo (-c)
  useradd -m -c "Usuario para automacao Ansible" "$TARGET_USER"
  echo "Usuário '$TARGET_USER' criado com sucesso."
else
  echo "Usuário '$TARGET_USER' já existe. Pulando a criação."
fi

# 3. CONFIGURAÇÃO DO SUDO SEM SENHA (SUDOERS)
SUDOERS_FILE="/etc/sudoers.d/$TARGET_USER"
echo "Configurando permissões de sudo..."

# Cria o arquivo de configuração para o usuário no diretório sudoers.d
# A sintaxe 'tee' é usada para escrever em um arquivo que requer privilégios de root.
echo "$TARGET_USER ALL=(ALL) NOPASSWD: ALL" | tee "$SUDOERS_FILE" > /dev/null

# Permissões corretas são CRÍTICAS para arquivos sudoers por segurança.
chmod 0440 "$SUDOERS_FILE"

echo "Regra de sudo criada em '$SUDOERS_FILE'."

# 4. CONFIGURAÇÃO DA CHAVE PÚBLICA SSH
echo ""
echo "--- Configuração da Chave SSH ---"
echo "Agora, cole a chave pública (o conteúdo completo de id_rsa.pub) e pressione Enter:"
read -r PUBLIC_KEY

# Verifica se a chave foi fornecida
if [ -z "$PUBLIC_KEY" ]; then [cite: 6]
  echo "ERRO: Nenhuma chave foi fornecida. Saindo."
  exit 1
fi

# Define os caminhos baseado no diretório home do usuário-alvo
TARGET_HOME=$(eval echo "~$TARGET_USER")
SSH_DIR="$TARGET_HOME/.ssh"
AUTH_KEYS_FILE="$SSH_DIR/authorized_keys"

# Cria o diretório .ssh se não existir
if [ ! -d "$SSH_DIR" ]; then [cite: 7]
  echo "Criando diretório $SSH_DIR..."
  # 'runuser' executa o comando como se fosse o TARGET_USER, garantindo que as permissões iniciais já estejam corretas.
  runuser -l "$TARGET_USER" -c "mkdir -p $SSH_DIR"
fi

# Adiciona a chave pública ao arquivo
echo "Adicionando a chave em $AUTH_KEYS_FILE..."
echo "$PUBLIC_KEY" >> "$AUTH_KEYS_FILE"

# Ajusta as permissões e o dono (ESSENCIAL!)
echo "Ajustando dono e permissões finais..."
chown -R "$TARGET_USER":"$TARGET_USER" "$SSH_DIR"
chmod 700 "$SSH_DIR"
chmod 600 "$AUTH_KEYS_FILE"

echo ""
echo "---------------------------------------------------------"
echo "SUCESSO! O usuário '$TARGET_USER' está pronto para o Ansible."
echo "---------------------------------------------------------"