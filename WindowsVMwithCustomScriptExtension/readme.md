#for application gateway
#for applicationGatewat integration,it only supports which is in .pfx format certificate only
#for that we have to combile certificate.crt and ca_bundle.crt to fullchain.crt
#by using below command we can able to create .pfx,here fullchain.crt & private.key files are required
#`openssl pkcs12 -export -out certificatep12.pfx -inkey private.key -in fullchain.crt`

1.before proceeding we have to enable Web-Server including IIS Management tools
2.IIS Manager > Choose 'Server' > Server certificates > create CSR > import certificatep12.pfx
3.under 'Server' > select 'site' > Bindings > add 'https'(not need to enter anything,as we are creating for default site) > Save
4.under 'Server' > select 'site' > SSL Settings > Check 'require SSL' save
5.restart IIS
