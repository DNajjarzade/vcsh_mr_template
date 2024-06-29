# Bootstrap 

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

# vcsh clone

```
cd ~
vcsh clone https://github.com/DNajjarzade/vcsh_mr_template.git mr
vcsh mr checkout mr
vcsh mr branch --track mr origin/mr
mr update
```
