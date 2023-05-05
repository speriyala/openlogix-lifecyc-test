#!/bearer.txt
varOrg="18597255-2c03-46ab-a04b-1edc2205a2f8"
varEnv="c511fce5-e1cf-4800-8918-0dabb45a606b"
varAssetName="cicd-test-sapi"
varoutput=$(curl -X POST "https://anypoint.mulesoft.com/accounts/login" -H "Content-Type: application/json" -d ' {"username":"speriyala3", "password":"Psmohan@234"}' )
echo $varoutput
varAccess=$(echo $varoutput | cut -d '"' -f 4,4)
echo 'access token is ' $varAccess
var1=$(curl -X GET "https://anypoint.mulesoft.com/exchange/api/v2/assets?search=$varAssetName&organizationId=$varOrg" -H "Authorization: Bearer $varAccess")
#echo "${var1}"
varExch=$(echo $var1 | cut -d ',' -f 1,2,3,4)
varGrp=$(echo $varExch | cut -d '"' -f 4)
varAsset=$(echo $varExch | cut -d '"' -f 8)
varVersion=$(echo $varExch | cut -d '"' -f 12)
echo "group id is $varGrp  asset name is $varAsset  version is $varVersion"
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