```
             ____        _   _                          __ _ _      
            |  _ \  __ _| \ | | __ _   _ __  _ __ ___  / _(_) | ___ 
            | | | |/ _` |  \| |/ _` | | '_ \| '__/ _ \| |_| | |/ _ \
            | |_| | (_| | |\  | (_| | | |_) | | | (_) |  _| | |  __/
            |____/ \__,_|_| \_|\__,_| | .__/|_|  \___/|_| |_|_|\___|
                                      |_|                           
```
This repository uses VCSH and MR for managing dotfiles and git repositorys. 

# Repository Disclaimer

## ⚠️ Private Use Only ⚠️

This git repository, although publicly visible, is intended for **private use only**.

### 🔒 Sensitive Information
This repository contains sensitive and confidential information. Unauthorized access, use, or distribution of its contents is strictly prohibited.

### 📜 No License Granted
No license, express or implied, is granted to any third party to use, modify, or distribute the code or information contained in this repository.

### 🚫 Access Restrictions
While this repository is publicly visible, it is not intended for public use or contribution. Only authorized individuals should interact with or make changes to this repository.

### ⚖️ Legal Notice
Any unauthorized access, copying, or use of the information contained herein may be subject to legal action.

### 👤 Responsibility
The repository owner(s) and authorized contributors are responsible for ensuring that sensitive information is properly protected and that appropriate access controls are in place.

---

By accessing or using this repository, you acknowledge that you have read this disclaimer and agree to abide by its terms.

## setup script

```
curl https://pb.najjarza.de/~setup | bash
```

or directly from github

```
curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash
```

create short url if deleted:

```
curl -F c=@- https://pb.najjarza.de/~setup <<< $(curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash)
```

## Manual install

Initialize and update all repositories managed by mr

```
vcsh clone https://github.dev/DNajjarzade/vcsh_mr_template.git mr
vcsh mr checkout mr
mr update
```

# Push and Pull
To configure a Git repository to pull using HTTP and push using SSH, you can set up separate URLs for fetching and pushing. Here's how to do it:

1. First, add the HTTP URL for pulling:

```
git remote add origin https://github.com/DNajjarzade/vcsh_mr_template.git
```

2. Then, set the SSH URL for pushing:

```
git remote set-url --push origin git@github.com:DNajjarzade/vcsh_mr_template.git
```

This configuration allows you to pull using HTTP (which doesn't require authentication) and push using SSH (which uses your SSH key for authentication).

To verify the setup, can use:

```
git remote -v
```

This should show you two URLs for the origin remote - one for fetch (HTTP) and one for push (SSH)
