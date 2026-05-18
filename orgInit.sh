sfdx force:org:delete -u ebikes

#create a scratch org
sfdx shane:org:create --verbose --userprefix=mike --userdomain=mbebikesdemo.com -f config/project-scratch-def.json -d 30 -s -a ebikes
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

#mobile security
sfdx force:package:install -w 20 -r -p  04t1I000003RkFQQA0

#open org
sfdx force:org:open
