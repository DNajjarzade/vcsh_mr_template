# DaNa Profile
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
