# Secure Repository Setup

## Prerequisites

- GPG installed
- Ansible installed
- git-crypt installed

## Setup Instructions

1. Clone the repository:
```sh
   git clone <your_git_repository_url>
   cd <repository>
```
    Import the GPG keys:
```sh

gpg --import public_key.asc
gpg --import private_key.asc
```
Unlock git-crypt:
```sh

git-crypt unlock
```
Access Ansible Vault:

```sh

    ansible-vault view --vault-password-file ~/.ansible_vault_password secret.yml
```

### Additional Notes

- **Security**: Publishing private keys and vault passwords makes the repository insecure. It's recommended to handle sensitive data securely and not publish such information in a public repository.
- **Backup**: Keep backups of your keys and passwords in a secure location.


