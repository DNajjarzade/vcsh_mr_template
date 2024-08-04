# ansible playbooks
ansible-pull uses this branch to pull and run playbooks locally.

```
sudo ansible-pull -C ansible -U https://github.com/DNajjarzade/vcsh_mr_template.git ~/Documents/projects/personal/ansible/local.yml
```
after this a cronjob is set to pull this repository every 10 min.
