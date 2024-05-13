#
# Server side Duckey setup script
#

#
# Create jailrooted user
#

# Run as root
sudo su

# Add user
groupadd sftponly # add sftp only group
useradd -g sftponly -s /bin/false -m -d /home/duckey duckey # add new user, and add them to sftponly
echo -e "quack\nquack" | passwd duckey # set password for new user

# Make root own the user's directories
chown root: /home/duckey 
chmod 755 /home/duckey

# Give user limited access to it's directories
mkdir /home/duckey/passwords
chmod 755 /home/duckey/passwords
chown duckey:sftponly /home/duckey/passwords

#
# Configuring SSH
#

echo "# Added by Duckey setup script
Subsystem sftp internal-sftp
Match Group sftponly
  ChrootDirectory %h
  ForceCommand internal-sftp
  AllowTcpForwarding no
  X11Forwarding no" >> /etc/ssh/sshd_config

systemctl restart ssh