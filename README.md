# ⚙️ Meus Estudos de Ansible

Repositório com *playbooks*, *roles* e configurações da minha jornada de aprendizado em automação com **Ansible**.

![Ansible Banner](https://files.readme.io/4179edf-Cloudsmith-Integrations-Banner-Ansible.png)

<p align="center">
  <img src="https://img.shields.io/badge/Ansible-2.9%2B-red?style=for-the-badge&logo=ansible" alt="Versão do Ansible">
  <img src="https://img.shields.io/badge/Licen%C3%A7a-MIT-green?style=for-the-badge" alt="Licença">
</p>

---

## 📂 Estrutura do Projeto

```
inventories/        # Arquivos de inventário (staging, production)
playbooks/          # Playbooks principais
roles/              # Estrutura de papéis reutilizáveis
group_vars/         # Variáveis de grupo
ansible.cfg         # Configurações padrão do Ansible
```

---

## 🚀 Objetivo
Explorar e documentar boas práticas de automação com **Ansible**, criando uma base sólida para:
- Padronizar ambientes.
- Automatizar tarefas repetitivas.
- Reutilizar papéis e variáveis.
- Evoluir para cenários com **CI/CD** e **Infra as Code (IaC)**.

---

## 🧭 Como executar (exemplo)
```bash
# rodar playbook principal (inventório staging)
ansible-playbook -i inventories/staging site.yml
```

---

## 🧠 Referências
- [Documentação oficial do Ansible](https://docs.ansible.com/)
- [Guia de boas práticas do Ansible Galaxy](https://galaxy.ansible.com/docs/)
- [Exemplos de Playbooks no GitHub](https://github.com/ansible/ansible-examples)
