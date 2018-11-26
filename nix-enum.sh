#!/bin/bash

###LINUX TRIAGE SCRIPT
###This is a script designed to perform an at-a-glance view of a system's
###properties to determine if a system should be analyzed further.

###CHANGELOG
###201805091300 Ealy - Added documentation for each command, added timedatectl under system info to help keep accurate timestamping
###201805090400 Ealy - Finished documentation one-liners for script, removed lsof commands (see notes below)
###201805131115 Haas - Cleaned up formatting and changed some arguments to better fit quick-response actions
###201806061145 Haas - Commented out some R&D commands; might use later but don't need right now
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###
###

printf '%s\n\n' ""
printf '%s\n' "===================== LINUX TRIAGE SCRIPT ====================="
printf '%s\n'


printf '%s\n' ""
printf '%s\n\n' "////////////////////// START DATE/TIME /////////////////////////"
printf '%s\n'

#Track when the script began processing - note when the system locale is set under system info
printf '%s\n' "START DATE/TIME:"
printf '%s\n' "================"
date
printf '%s\n' ""

#Ensure timezone is correct setting & if NTP sync
printf '%s\n' "TIMEZONE SETTINGS:"
printf '%s\n' "=================="
timedatectl
printf '%s\n' ""

#Heading - Basic System Info
printf '%s\n\n' "///////////////////////// SYSTEM INFO //////////////////////////"
printf '%s\n'

#Collect hostname details
#printf '%s\n' "HOSTNAME:"
#printf '%s\n' "========="
#hostname -s
#hostname -i
#hostname -d
#printf '%s\n' ""

#Get network hostname, kernel release, kernel version, and operating system
printf '%s\n' "HOSTNAME:"
printf '%s\n' "========="
printf 'LOCAL:      ' && hostname -s
printf 'NETWORK:    ' && uname -n
printf '%s\n' ""

#Get kernel release, kernel version, OS details
printf '%s\n' "DETAILS:"
printf '%s\n' "========"
printf 'IP ADDRESS: ' && hostname -i
printf 'DOMAIN:     ' && hostname -d
printf 'KERNEL:     ' && uname -r
#uname -v - taken out because it didn't add much
#uname -o - taken out because it didn't add much
printf '%s\n' ""

#Get system uptime
printf '%s\n' "UPTIME:"
printf '%s\n' "======="
uptime -p	#-p makes it quicker to read
printf '%s\n' ""

printf '%s\n\n' "/////////////// ENVIRONMENT ///////////////"
printf '%s\n'

#Get Linux environment variables
printf '%s\n' "SETTINGS:"
printf '%s\n' "========="
printenv
printf '%s\n' ""

#Get details on Linux version being run
printf '%s\n' "LINUX RELEASE INFO:"
printf '%s\n' "==================="
sed -n 1,10p /etc/*release*
printf '%s\n' ""

printf '%s\n\n' "/////////////// NETWORK SETTINGS ///////////////"
printf '%s\n'

#Ensure all network adapters needing IPs/connectivity have them
printf '%s\n' "NETWORK ADAPTERS:"
printf '%s\n' "================="
ifconfig -a
printf '%s\n' ""

#Active and listening connections
printf '%s\n' "NETWORK CONNECTIONS:"
printf '%s\n' "===================="
netstat -pantue
printf '%s\n' ""

#Routes for packets to traverse
printf '%s\n' "ROUTE TABLE:"
printf '%s\n' "============"
route -n
printf '%s\n' ""

#Is list of DNS Servers correct?
printf '%s\n' "DNS RESOLUTION:"
printf '%s\n' "==============="
cat /etc/resolv.conf
printf '%s\n' ""

printf '%s\n\n' "/////////////// USER INFO ///////////////"
printf '%s\n'

#Show.....users currently logged in
printf '%s\n' "USERS CURRENTLY LOGGED IN:"
printf '%s\n' "=========================="
who -H	#switched from "w" to "who -H" to show headings
printf '%s\n' ""

#Show user's most recent login time
printf '%s\n' "USER'S MOST RECENT LOGIN:"
printf '%s\n' "========================="
lastlog
printf '%s\n' ""

#Show user info
printf '%s\n' "CURRENT EFFECTIVE USER INFO:"
printf '%s\n' "============================"
id
printf '%s\n' ""

#Show last logged in users
printf '%s\n' "LAST LOGGED IN USERS:"
printf '%s\n' "====================="
last
printf '%s\n' ""

#Show full user list
printf '%s\n' "FULL USER LIST:"
printf '%s\n' "==============="
cat /etc/passwd
printf '%s\n' ""

#Ensure no users are sudoers that shouldn't be, and sudoers file has correct modifications
printf '%s\n' "SUDOER FILE:"
printf '%s\n' "============"
cat /etc/sudoers
printf '%s\n' ""

#Ensure root users are approved
printf '%s\n' "ROOT USERS:"	#users with uid 0
printf '%s\n' "==========="
awk -F: '($3 == "0") {print}' /etc/passwd
printf '%s\n' ""

#Show all groups
printf '%s\n' "FULL GROUP LIST:"
printf '%s\n' "===================="
cat /etc/group
printf '%s\n' ""

#Show incorrect attempts to login
printf '%s\n' "FAILED LOGINS:"	#using /var/log/secure instead of lastb
printf '%s\n' "=================="
tail -100 /var/log/secure | grep -i fail
printf '%s\n' ""

printf '%s\n\n' "/////////////// PROCESSES/SERVICES ///////////////"
printf '%s\n'

#Get top 5 CPU-intensive processes
printf '%s\n' "TOP PROCESSES BY CPU:"
printf '%s\n' "============================"
ps aux | sort -nrk 3,3 | head -n 5
printf '%s\n' ""

#Get processes using memory
printf '%s\n' "TOP PROCESSES BY MEMORY:"
printf '%s\n' "============================"
top -n 1 -b
printf '%s\n' ""

#List all running processes
printf '%s\n' "RUNNING PROCESSES:"
printf '%s\n' "======================"
ps -ejfH
printf '%s\n' ""

#This needs to be flavor specific
printf '%s\n' "SERVICE LIST:"
printf '%s\n' "================="
service --status-all
printf '%s\n' ""

printf '%s\n\n' "/////////////// FIREWALL INFO ///////////////"
printf '%s\n'

#Display allowed hosts for file used in firewall
printf '%s\n' "ALLOWED HOSTS:"
printf '%s\n' "=================="
cat /etc/hosts.allow
printf '%s\n' ""

#Display denied hosts for file used in firewall
printf '%s\n' "DENIED HOSTS:"
printf '%s\n' "================="
cat /etc/hosts.deny
printf '%s\n' ""

#Show active firewall properties - do allowed/denied hosts match firewall?
printf '%s\n' "IPTABLES:"	#added -nv for verbosity and numeric addresses:ports
printf '%s\n' "============="
iptables -nvL
printf '%s\n%s\n' ""

printf '%s\n\n' "/////////////// FILES/KERNEL ///////////////"
printf '%s\n'

#Show all mounted devices on system
printf '%s\n' "MOUNTED DEVICES:"
printf '%s\n' "===================="
mount
printf '%s\n' ""

#Show disk info
printf '%s\n' "DISK INFO:"
printf '%s\n' "=============="
fdisk -l
printf '%s\n' ""

#Show free and used disk space - is there enough free space on HDDs?
printf '%s\n' "DISK SPACE:"	#drive usage and mounted location
printf '%s\n' "==============="
df -h
printf '%s\n' ""

#REMOVED BECAUSE LSOF IS NOT INSTALLED BY DEFAULT ON AWS IMAGES - WILL THIS CHANGE?
#What files are currently open?
#printf '%s\n' "LIST OF OPEN FILES:"
#printf '%s\n' "======================="
#lsof -i -n -P
#printf '%s\n' ""

#REMOVED BECAUSE LSOF IS NOT INSTALLED BY DEFAULT ON AWS IMAGES - WILL THIS CHANGE?
#List of open files using the network
#printf '%s\n' "LIST OF OPEN FILES USING THE NETWORK:"
#printf '%s\n' "========================================="
#lsof -nPi | cut -f 1 -d " " | uniq | tail -n +2
#printf '%s\n' ""

#Are world readable file permissions correct?
printf '%s\n' "WORLD-READABLE FILES:"	#added
printf '%s\n' "========================="
find / -xdev -type d \( -perm -0002 -a ! -perm 1000 \) -print
printf '%s\n' ""

#List kernel modules on system
printf '%s\n' "LOADED KERNEL MODULES:"	#content heavy; might take out grep for IOCs
printf '%s\n' "=========================="
lsmod
printf '%s\n' ""

printf '%s\n\n' "/////////////// MISC ///////////////"
printf '%s\n'

#List last 20 commands for each user
printf '%s\n' "LAST 20 COMMANDS FOR USERS"
printf '%s\n' "=============================="
for i in `ls /home/`
do 
	printf '%s\n'
	printf $i
	printf  ":%s\n"
	printf '%s\n' "====================="
	tail -20 /home/$i/.bash_history
	printf '%s\n' ""
done

#List scheduled jobs
printf '%s\n' "LIST OF CRON JOBS:"
printf '%s\n' "======================"
crontab -l
printf '%s\n' ""

#List scheduled jobs with root permissions to run
printf '%s\n' "LIST OF ROOT CRON JOBS:" 	#added to check cronjobs running for root
printf '%s\n' "==========================="
crontab -u root -l
printf '%s\n' ""

#Where is cron.d running from?
printf '%s\n' "CRON.D DIR LISTING:"
printf '%s\n' "======================="
ls -lR /etc/cron.d/*
printf '%s\n' ""


###LAST FEW TEMP FILES??? NEED COMMAND


printf '%s\n' "///////////////////////// END OF FILE /////////////////////////"
printf '%s\n'
#LIST_OF_ALL_UPDATES
#Version 1.1 - Changed typo preventing post processing file hashing to occur. Fixed typo adding "v" to filename
#Version 1.0 - Initial compilation and release of nix data gathering
exit




#printf '%s\n' "SSH authorized keys"	#added to check ssh keys
#printf '%s\n' "--------------------"
#cat /root/.ssh/authorized_keys
#printf '%s\n' ""



#PERSISTENCE MECHANISMS





#NETWORK INFO

#printf '%s\n' "ss"		#netstat covers this?
#printf '%s\n' "---"
#ss
#printf '%s\n' ""





#printf '%s\n' "netstat -rn"	### this is done above in route -n ###
#printf '%s\n' "-----------"
#netstat -rn
#printf '%s\n' ""

#printf '%s\n' "arp -anv"	#added the -v for verbosity; helps see if anything was skipped or masked
#printf '%s\n' "--------"
#arp -anv
#printf '%s\n' ""



#PROCESSING DETAILS AND HASHES
#echo OS Type: nix
#echo Computername: $cname
#echo Time stamp: $ts
#echo
#echo ==========MD5 HASHES==========
#find $computername -type f \( ! -name Processing_Details_and_Hashes.txt \) -exec md5sum {} \;
#echo
#echo ==========SHA256 HASHES==========
#find $computername -type f \( ! -name Processing_Details_and_Hashes.txt \) -exec shasum -a 256 {} \;
#echo "Computing hashes of files"


