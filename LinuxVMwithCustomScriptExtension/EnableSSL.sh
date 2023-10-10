#for applicationgateway and windows we have to .pfx format certificate for that
#cat certificate.crt ca_bundle.crt >> fullchain.pem
#openssl.exe pkcs12 -in fullchain.pem -inkey private.key -export -out mypfx.pfx

#Copy downloaded ssl files to /etc/ssl i.e certificate.crt & ca_bundle.crt
#copy downloaded private.key to /etc/ssl/private
#installing apache2
sudo apt install apache2 -y
#we have to add site to apache available sites
sudo touch /etc/apache2/sites-available/www.domain.com.conf
#then we have to run en2site to add domain in apache
sudo a2ensite www.domain.com
#then we can able to see config in /etc/apache2/sites-enabled, naming as www.domain.com.conf
sudo tee -a /etc/apache2/sites-enabled/www.domain.com.conf << END
<VirtualHost *:443>
 DocumentRoot /var/www/html
 ServerName www.domain.com
 SSLEngine on
 SSLCertificateFile /etc/ssl/certificate.crt
 SSLCertificateKeyFile /etc/ssl/private/private.key
 SSLCertificateChainFile /etc/ssl/ca_bundle.crt
</VirtualHost>
END
#we have to enable ssl and restart apache to work ssl fine
sudo a2enmod ssl && systemctl restart apache2
