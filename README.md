

# Multi Network Object Creator #
Shell script that allows you perform a simple paste on terminal to create several network objects with CIDR notation on Check Point Firewall.
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
