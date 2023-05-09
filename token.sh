#!/bearer.txt
###########################################################################
# name : shell script for entry into api manager
# created by : vizag offshore mulesoft team
# version : 1.0.0
###########################################################################

#declared variables which dont change for a project
varOrg="18597255-2c03-46ab-a04b-1edc2205a2f8"
varEnv="c511fce5-e1cf-4800-8918-0dabb45a606b"
varAssetName="cicd-test-sapi"
# 1st STEP:  to retrieve access token using username and password
varoutput=$(curl -X POST "https://anypoint.mulesoft.com/accounts/login" -H "Content-Type: application/json" -d ' {"username":"speriyala3", "password":"Psmohan@234"}' )
echo $varoutput
varAccess=$(echo $varoutput | cut -d '"' -f 4,4)
echo 'access token is ' $varAccess
# 2nd STEP: to retrieve asset details from exchange using org id and existing api name
var1=$(curl -X GET "https://anypoint.mulesoft.com/exchange/api/v2/assets?search=$varAssetName&organizationId=$varOrg" -H "Authorization: Bearer $varAccess")
# derive the group id and asset name and version from the var1 field
varExch=$(echo $var1 | cut -d ',' -f 1,2,3,4)
varGrp=$(echo $varExch | cut -d '"' -f 4)
varAsset=$(echo $varExch | cut -d '"' -f 8)
varVersion=$(echo $varExch | cut -d '"' -f 12)
echo "group id is $varGrp  asset name is $varAsset  version is $varVersion"

# 3rd STEP:  to post the api into api manager

#check if api name already exists in api manager , insert into api manager only if no record with api name and version exists

varApi=$(curl -X GET "https://anypoint.mulesoft.com/apimanager/api/v1/organizations/$varOrg/environments/$varEnv/apis?ascending=false&limit=20&offset=0&sort=createdDate" -H "Authorization: Bearer $varAccess")


assetExists=$(grep -o '"assetId":"cicd-test-sapi","assetVersion":"1.0.0"' <<< "$varApi" | wc -l)
echo "no of occurance is " $assetExists

if [ $assetExists -eq 0 ]; then

            curl -X POST "https://anypoint.mulesoft.com/apimanager/api/v1/organizations/$varOrg/environments/$varEnv/apis" \
               -H "Content-Type: application/json" \
               -H "Authorization: Bearer $varAccess" \
               -d '{
               "endpoint":{
                  "deploymentType":"CH",
                  "isCloudHub":null,
                  "muleVersion4OrAbove":true,

                  "proxyUri":null,
                  "referencesUserDomain":null,
                  "responseTimeout":null,
                  "type":"raml",
                  "uri":null
               },
               "providerId":null,
               "instanceLabel":null,
               "spec":{
                  "assetId":"'$varAsset'",
                  "groupId":"'$varGrp'",
                  "version":"'$varVersion'"
               }
            }'

fi