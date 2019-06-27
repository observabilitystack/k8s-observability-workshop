# Technical foundations of the workshop cluster

* __Automate everything__
  * Use Terraform for volatile infrastructure (servers, DNS records, certificates)
  * Use Ansible to provision servers
  * Logging in for provisoning is an anti-pattern!
* __Security__
  * Participants log in using the `workshop` ssh user using their ssh key
  * The server is equipped with a wildcard TLS certificate. Communication to the server should be encrypted (HTTPS)
  * (sudo rights are limited)
  * Firewall is active and limited to the ingress ports needed
* __Cloud__
  * Servers can be deployed into any cloud (e.g. _Hetzner_, _Digital Ocean_)
  * DNS records are managed at _Digital Ocean_ (which is free)
* __General__
  * Servers have random pet names (e.g. `upright-sunbird`)
  * Servers have a FQDN using a common domain name (e.g. `k8s.o12stack.org`)
  * Tools needed to view and edit text files are installed on the server

And finally: What would a workshop server be without a nice _motd_ welcome message: 
  
![alt](workshop-login.png)

