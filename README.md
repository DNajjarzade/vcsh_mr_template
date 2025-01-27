# Bootstrap

Install `vcsh`, `mr`, and checkout projects with ease. This script automates the setup of your environment by installing required tools, cloning repositories, and managing configurations.

---

## Quick Start

### Install with Shortened URL:
```bash
curl https://pb.najjarza.de/~bootstrap | bash
```

### Install Directly from GitHub:
```bash
curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash
```

### Alternative Shortened URL:
```bash
curl https://pb.najjarza.de/~setup | xargs -I{} curl {} | bash
```

---

## Features

- **Automatic Installation**: Installs `vcsh`, `mr`, and other required tools (`ansible`, `git`, `tmux`, `vim`, etc.).
- **Repository Management**: Clones and updates repositories managed by `mr`.
- **Customizable**: Supports custom repository URLs and branches.
- **Verbose Mode**: Use the `-v` flag for detailed output.
- **Auto-Yes Mode**: Use the `-y` flag to automatically confirm prompts.

---

## Usage

### Script Options:
```bash
Usage: ./bootstrap.sh [-h] [-v] [-y] [repository_url]
  -h  Display this help message
  -v  Verbose mode
  -y  Automatic yes to prompts
  repository_url  Optional: Specify a custom repository URL
```

### Manual Setup:
1. **Initialize and Update Repositories**:
   ```bash
   vcsh clone https://github.com/DNajjarzade/vcsh_mr_template.git mr
   vcsh mr checkout mr
   mr update
   ```

2. **Clone and Track Branch**:
   ```bash
   cd ~
   vcsh clone https://github.com/DNajjarzade/vcsh_mr_template.git mr
   vcsh mr checkout mr
   vcsh mr branch --track mr origin/mr
   mr update
   ```

---

## Dependencies

The script installs the following packages if they are not already installed:
- `ansible`
- `atuin`
- `ble.sh` (required by `atuin`)
- `curl`
- `git`
- `git-crypt`
- `gpg`
- `gpg-agent`
- `lolcat`
- `mc`
- `myrepos`
- `neofetch`
- `starship`
- `tmux`
- `vcsh`
- `vim`
- `wget`

---

## Additional Tools

- **Starship**: A cross-shell prompt.
  ```bash
  curl -sS https://starship.rs/install.sh | sh
  ```

- **Atuin**: A modern shell history manager.
  ```bash
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  ```

---

## Logs

The script logs all actions to `/var/log/vcsh_mr_setup.log` for debugging and reference.

---

## Troubleshooting

- **Unsupported Package Manager**: If your package manager is not supported, the script will prompt you to install the required packages manually.
- **Failed Installations**: If a package fails to install, the script will log the error and continue. You can manually install the package later.

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on the [GitHub repository](https://github.com/DNajjarzade/vcsh_mr_template).

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Author

- **Dariush Najjarzade**  
  GitHub: [DNajjarzade](https://github.com/DNajjarzade)  
  Email: [dnajjarzade@gmail.com](mailto:dnajjarzade@gmail.com)

---
