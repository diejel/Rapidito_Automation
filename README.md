

# r[API]dito Automation #
![rapidito-img](https://user-images.githubusercontent.com/15971140/129296008-cec4df7f-a828-4b1d-875d-9796e2e5f6f1.JPG)

*r[API]dito* is an iniatitive software for contributing to automation CheckPoint Firewall tasks. It's based on the _API Management Tool_  and Shell script language.

---

## Features
- Creation of a well organized folder hierarchy since the first time you use it. This folder contains the output and logs of the task you have performed ordered by date.
- Due to its simple environment it does not require too many resources as Smart Console needs.
- Easy installation and simple customization, just editing a .ini format file according your actual name convention servers environment.
- Include your ticket number and tags in every operation, this helps to map and find easily ITSM tickets.
- Easily customization of objects colors from changing file values.
- Fully compatible with Firewalls and SMS R8X.X versions.

---

## What is New on v2.0 ?

- Addition of several IP addresses to blacklist group (simple copy/paste on terminal).
- Addition of a FQDN and non-FQDN extensive list to blacklist (simple copy/paste on terminal)
- Addition of an extensive list of IP addresses to a blacklist group from file.
- Add a Blocklist from feed.
- Schedule One-time Policy Installation Pre-defined Policy Package (cron-based).
- Schedule Recursively Policy Installation Pre-defined Policy Package (cron-based).
- Schedule Recursively Policy Installation in all existing Policies Packages.
- Creation of a CSV indicator file.  

---

## Installation
r[API]dito should be placed in **/var** folder, it can be executed without problems since you configure it correctly and grant permission accordingly to the admin user you've created in Smart Console.

For stable released versions the parent folder should be named as **rapidito** and beta version as **rapibeta**. By default the ownership of files is **admin** for user and group. 

- First, move the main folder to **/var** directory.

  `[user@sms]# mv rapidito/ /var/`

- Inside Smart Console terminal, dentify which is the user you are working on and grant permissions as follows. 

  `[user@sms]# chown -R $(grep -i $(whoami) /etc/passwd | cut -d':' -f1): /var/rapidito` 

- For ensuring security, take off permission to `others` users and grant just only `owner` user. 
  
  `[user@sms]# chmod -R u+rwx /var/rapidito`

- Inside the `setup` folder, run the `./install.sh` file.

- Finally, logout from current terminal and login again, now just type on terminal
    
    `[user@sms]# rapidito`

- r[API]dito will start, that's all.

* There is one file within **config** folder called `init.rap`, in this file you can edit and change for the name of your existing groups in SmartConsole! 
----

  
## Possible uses ##

- When you nedd to apply Bypass inspection and need to update some network objects which belongs to an specific application.
- When you have several neworks that must created and included in an specific new group. 
- Host addition into an existing group.
- Several Network Objects creation. 
  - *[Important]*: When the script finish processing all the objects, do not forget to press [ENTER](↵), this is necessary for the script understand there will no exist more objects to be processed. 
- Addition of a single IP address to blacklist group.
- Addition of several IP addresses to blacklist group (simple copy/paste on terminal).
- Addition of a FQDN and non-FQDN extensive list to blacklist (simple copy/paste on terminal)
- Addition of an extensive list of IP addresses to a blacklist group from file.
- Add a Blocklist from feed.
- Schedule One-time Policy Installation Pre-defined Policy Package (cron-based).
- Schedule Recursively Policy Installation Pre-defined Policy Package (cron-based).
- Schedule Recursively Policy Installation in all existing Policies Packages.
- Check IP Reputation (based on abusedbip).
- Routine for removing IPs from blacklist.
- Creation of a CSV indicator file.  

---

## How does it work? ##

Example for : "Several Network Objects creation."

### Simple paste of Network in CIDR format  ###
![video](https://user-images.githubusercontent.com/15971140/129293935-218a8743-917b-445f-8155-162b4c9c2204.gif)
### Verification of creation process in Object Explorer within Smart Console ###
![video2](https://user-images.githubusercontent.com/15971140/129294281-1c555ccd-13ee-4d04-958c-8eae962b894a.gif)

## Some other examples with videos.
### Several Network Objects creation
- https://www.linkedin.com/posts/diegocuba_checkpoint-cybersecurity-shellscript-activity-6827238327779934208-PFdJ 
### Schedule Recursively Policy Installation in all existing Policies Packages.
- https://www.linkedin.com/posts/diegocuba_linuxengineer-linux-sysadmin-activity-6827788481884942336-IlZu/?utm_source=linkedin_share&utm_medium=member_desktop_web
### Addition of an extensive list of IP addresses to a blacklist group from file.
- https://www.linkedin.com/posts/diegocuba_serpro-serpro-blocklist-activity-6828887998311002112-1Yo-/?utm_source=linkedin_share&utm_medium=member_desktop_web
### Check IP Reputation (based on abusedbip) & Routine for removing IPs from blacklist.
- https://www.linkedin.com/posts/diegocuba_script-regex-apikey-activity-6829200866118033408-Qg2x/?utm_source=linkedin_share&utm_medium=member_desktop_web
### Creation of a CSV indicator file.
- https://www.linkedin.com/posts/diegocuba_cybersecurity-security-databreach-activity-6830343035495211008-bePu/?utm_source=linkedin_share&utm_medium=member_desktop_web

---

## Special Thanks
I can not leave to give special thanks to my friend **[@Nelson A Leite Jr](www.linkedin.com/in/nelson-a-leite-jr)**, due to the help with disruptives ideas, and new challenging situations that made me think '_out of the box_' and trust myself to continue this project.

## Connect with me ##
- Linkedin: https://linkedin.com/in/diegocuba
- Github: https://github.com/diejel
- Linux Foundation: https://openprofile.dev/profile/dcubaz
- Check Point CHECKMATES: https://community.checkpoint.com/t5/user/viewprofilepage/user-id/67305
- Creddly: https://www.credly.com/users/diego-cuba-zuniga/badges
  
## Share and help others ##
If you like this initiative and you find interesting my work in automation tasks, please share this work and help others. Feel free to reach me oute and leave your comments, also suggest new ideas. Best Regards!

Diego.
