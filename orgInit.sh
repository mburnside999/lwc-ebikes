sfdx force:org:delete -u ebikes
sfdx shane:org:create --verbose --userprefix=mike --userdomain=mbebikesdemo.com -f config/project-scratch-def.json -d 30 -s -a ebikes

# install nebula logging and assign permissions
# sfdx force:package:install -w 20 -r -p  04t5Y0000015lmOQAQ
# sfdx force:user:permset:assign -n LoggerAdmin
# sfdx force:user:permset:assign -n LoggerEndUser	
# sfdx force:user:permset:assign -n LoggerLogCreator
# sfdx force:user:permset:assign -n LoggerLogViewer

sfdx force:source:push
sfdx force:user:permset:assign -n ebikes
sfdx shane:user:password:set -p sfdx1234 -g User -l User
sfdx force:user:permset:assign -n Walkthroughs
sfdx force:data:tree:import -p ./data/sample-data-plan.json
sfdx force:community:publish -n E-Bikes
sfdx force:mdapi:deploy -d guest-profile-metadata -w 10
#Athena
#sfdx force:package:install -w 20 -r -p 04tB0000000UpqU

#streaming monitor
sfdx force:package:install -w 20 -r -p 04t1t000003Po3VAAS
#mobile pub
sfdx force:package:install -w 20 -r -p  04t1I000003RkFQQA0
sfdx force:org:open
