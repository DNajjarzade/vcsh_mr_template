# vcsh & mr 

Install vcsh, mr and checkout projects.
install with shortend url:

```
curl https://pb.najjarza.de/~bootstrap | bash
```

or directly from github

```
curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash
```

or

```
curl https://pb.najjarza.de/~setup | xargs -I{} curl {} | bash
```

## manual

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

This configuration allows you to pull using HTTP (which doesn't require authentication) and push using SSH (which uses your SSH key for authentication)[1].

To verify your setup, you can use:

```
git remote -v
```

This should show you two URLs for the origin remote - one for fetch (HTTP) and one for push (SSH)[1].

Alternatively, you can use Git's global configuration to achieve this for all repositories:

```
git config --global url."https://github.com/".insteadOf git@github.com:
git config --global url."git@github.com:".pushInsteadOf https://github.com/
```

This configuration rewrites SSH URLs to HTTPS for pulls, and HTTPS URLs to SSH for pushes[1].

Remember to replace "github.com" with your Git server's domain if you're not using GitHub.

This setup allows you to benefit from the simplicity of HTTP for pulling (which doesn't require authentication) while still using the more secure SSH protocol for pushing changes, which requires authentication[1].

Citations:
[1] https://stackoverflow.com/questions/3553270/how-to-config-git-to-pull-from-http-and-push-through-ssh-in-one-remote
[2] https://groups.google.com/g/repo-discuss/c/b0bMdq69KL4
[3] https://www.warp.dev/terminus/git-clone-ssh
[4] https://superuser.com/questions/230694/how-can-i-push-a-git-repository-to-a-folder-over-ssh
[5] https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols