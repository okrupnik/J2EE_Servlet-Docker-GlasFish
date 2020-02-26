#!/bin/sh
# change password (it's horrible, but gf seems to accept as password parameters files only...)
echo "AS\_ADMIN\_PASSWORD= AS\_ADMIN\_NEWPASSWORD=password" >> /home/gf-password.txt asadmin --user=admin --passwordfile=/home/gf-password.txt change-admin-password --domain\_name domain1
rm /home/gf-password.txt

# enable secure area asadmin start-domain
echo "AS\_ADMIN_PASSWORD=password" >> /home/gf-password.txt asadmin --user=admin --passwordfile=/home/gf-password.txt enable-secure-admin rm /home/gf-password.txt asadmin --user=admin stop-domain

# finally start db and glassfish
asadmin start-database
asadmin start-domain -v