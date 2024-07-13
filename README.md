#  use on remotes:

decrypt git-crypt key:

```
toggle_vault  ~/Documents/projects/personal/secret/key/assh-decrypt-key

```

unlock git-encrypted files

```
vcsh run assh git-crypt unlock ~/Documents/projects/personal/secret/key/assh-decrypt-key
```

# under the hood assh Branch
To encrypt files before adding them to Git, you can use the tool `git-crypt`. Here's how to set it up and use it:

1. Install git-crypt:
```
brew install git-crypt  # for macOS
sudo apt install git-crypt  # for Ubuntu/Debian
```

2. Initialize git-crypt in your repository:
```
cd /path/to/your/repo
git-crypt init
```

3. Create a `.gitattributes` file in your repository root to specify which files should be encrypted:
```
echo "secretfile.txt filter=git-crypt diff=git-crypt" >> .gitattributes
echo "*.key filter=git-crypt diff=git-crypt" >> .gitattributes
```

This example will encrypt `secretfile.txt` and all files with the `.key` extension.

4. Add and commit the `.gitattributes` file:
```
git add .gitattributes
git commit -m "Add .gitattributes for git-crypt"
```

5. Now, when you add and commit the specified files, git-crypt will automatically encrypt them:
```
echo "secret data" > secretfile.txt
git add secretfile.txt
git commit -m "Add encrypted secret file"
```

6. When you push to the remote repository, the files will be encrypted. When you pull or clone the repository, the files will remain encrypted until you unlock the repository.

7. To unlock the repository on a new machine or for a new collaborator, you'll need to export the encryption key:
```
git-crypt export-key /path/to/key-file
```

Then on the new machine:
```
git-crypt unlock /path/to/key-file
```

This setup allows you to transparently work with encrypted files in your Git repository. The specified files are automatically encrypted when committed and decrypted when checked out, ensuring that sensitive data remains protected in your remote repository[1][2][4].

Remember to never commit the encryption key to the repository itself, and to manage access to the key securely[5].

## Troubleshoot 
If your *.yml pattern didn't work as expected, there could be a few reasons for this. Let's troubleshoot and ensure your YAML files get encrypted properly:

Check your .gitattributes file:
Make sure the pattern for YAML files is correctly specified. It should look like this:

```
    *.yml filter=git-crypt diff=git-crypt
```

Ensure the .gitattributes file is committed:
The .gitattributes file must be committed for the patterns to take effect.

Clean the Git cache:
If you added the YAML files before setting up git-crypt, you might need to clean the Git cache:

```
git rm --cached '*.yml'
git add '*.yml'
```

Verify git-crypt status:
Run this command to see which files git-crypt is managing:

```
git-crypt status
```

This should show your YAML files as encrypted.
Check for nested .gitattributes:
Ensure there are no nested .gitattributes files overriding your root configuration.
Try a more specific pattern:
If you have YAML files in specific directories, you might want to use a more specific pattern:

```
path/to/config/*.yml filter=git-crypt diff=git-crypt
```

Commit and push:
After making these changes, commit your files and push to the remote repository.

Verify encryption:
Clone the repository to a new location without unlocking it. The YAML files should appear as binary/encrypted content.

Citations:
[1] https://thearjunmdas.github.io/entries/encrypt-decrypt-files-with-git/
[2] https://www.reddit.com/r/selfhosted/comments/11fvug8/howto_to_encrypt_selected_files_in_a_git/
[3] https://stackoverflow.com/questions/48330742/file-encryption-in-git-repository
[4] https://dev.to/heroku/how-to-manage-your-secrets-with-git-crypt-56ih
[5] https://tuxette.nathalievialaneix.eu/2022/08/encrypting-files-in-git.html
