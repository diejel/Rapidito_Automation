

# Multi Network Object Creator #
![rapidito-img](https://user-images.githubusercontent.com/15971140/129296008-cec4df7f-a828-4b1d-875d-9796e2e5f6f1.JPG)

*r[API]dito* is an iniatitive software for contributing to automation CheckPoint tasks. It's based on the _API Management Tool_ .

- Particularly, this shell script belongs to that project which allows you to perform a simple paste on terminal for creating several network objects using CIDR notation on Smart Console ( > R80.10 ).
## Possible uses ##
- When you nedd to apply Bypass inspection and need to update some network objects which belongs to an specific application.
- When you have several neworks that must created and included in an specific new group. 
- It can be a re-utilized in any other future implementation, being part of another function.

## How to use it? ##
- This script works straightforward in your current working directory (CWD).
- Run as following: 
  - `user@host~$ chmod +x multi_network_creator.sh`
  - `user@host~$ ./multi_net_creator.sh` 
- Do not forget to verify the API is running: 
  - `user@host~$ run api status && api restart ` 

## How does it work? ##
### Simple paste of Network in CIDR format  ###
![video](https://user-images.githubusercontent.com/15971140/129293935-218a8743-917b-445f-8155-162b4c9c2204.gif)
### Verification of creation process in Object Explorer within Smart Console ###
![video2](https://user-images.githubusercontent.com/15971140/129294281-1c555ccd-13ee-4d04-958c-8eae962b894a.gif)

## Connect with me ##
I use to upload some videos about what I'm currently developing in Shell script for CheckPoint Firewalls.
- Here is one video about _"network objects creation"_ : https://www.linkedin.com/posts/diegocuba_checkpoint-cybersecurity-shellscript-activity-6827238327779934208-PFdJ 
- Linkedin: https://linkedin.com/in/diegocuba

## Share and help others ##
If you like this initiative and you find interesting my work in automation tasks, please share this work and help others. Feel free to contact me and leave your comments, suggest new ideas. Regards! 
