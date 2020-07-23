param (
    [string]$uri="eventhubnamespace.servicebus.windows.net/eventhubname", 
    [string]$policyName="policyName",    
    [string]$policyKey="Xd64pfQW5k8RhTWLMITXKj23",
    [string]$body = '{
	   "id": "ab4fee7e-e065-4767-b214-37ab22d01ae9",
	   "metaData": "test message",
	   "readDate": "0001-01-01T00:00:00",
	   "createdDate": "2020-03-06T15:49:26.9937576+00:00"
	}'
)

[Reflection.Assembly]::LoadWithPartialName("System.Web")| out-null
#token expires in current time + 5000seconds
$expires=([DateTimeOffset]::Now.ToUnixTimeSeconds())+5000
$signatureString=[System.Web.HttpUtility]::UrlEncode($uri)+ "`n" + [string]$expires
$hashKey = New-Object System.Security.Cryptography.HMACSHA256
$hashKey.key = [Text.Encoding]::ASCII.GetBytes($policyKey)
$signature = $hashKey.ComputeHash([Text.Encoding]::ASCII.GetBytes($signatureString))
$signature = [Convert]::ToBase64String($signature)
$token = "SharedAccesssignature sr=" + [System.Web.HttpUtility]::UrlEncode($uri) + "&sig=" + [System.Web.HttpUtility]::UrlEncode($signature) + "&se=" + $expires + "&skn=" + $policyName


$method = "POST"
$uri = "https://" + $uri + "/messages"
echo "sending message to:" $uri
$signature = "$token"

#headers
$headers = @{
            "Authorization"=$signature;
            "Content-Type"="application/atom+xml;type=entry;charset=utf-8";
            }

#call the Azure REST API
Invoke-RestMethod -uri $uri -Method $method -Headers $headers -Body $body