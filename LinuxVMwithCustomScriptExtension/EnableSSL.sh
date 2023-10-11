#for application gateway
#for applicationGatewat integration,it only supports which is in .pfx format certificate only
#for that we have to combile certificate.crt and ca_bundle.crt to fullchain.crt
#by using below command we can able to create .pfx,here fullchain.crt & private.key files are required
#`openssl pkcs12 -export -out certificatep12.pfx -inkey private.key -in fullchain.crt`

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
 ServerName www.www.domain.com
 SSLEngine on
 SSLCertificateFile /etc/ssl/certificate.crt
 SSLCertificateKeyFile /etc/ssl/private/private.key
 SSLCertificateChainFile /etc/ssl/ca_bundle.crt
</VirtualHost>
END
#we have to enable ssl and restart apache to work ssl fine
sudo a2enmod ssl && systemctl restart apache2
