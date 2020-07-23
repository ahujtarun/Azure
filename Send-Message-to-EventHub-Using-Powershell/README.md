# Post a message to Azure Event Hub

Azure event hub is used widely in event driven applications. 

A typical use case would be sending a message to the event hub in response to an event generated in an application. 
The eventhub message can be processed by an Azure function or by some other application.

In order to test the message processing, we can directly post a message to the event hub instead of the application.
So basically we send same message using powershell script as the application would have sent.

This allows for independent testing in a distributed architecture.

The key here is to know the format of the message(body) that we are going to send from powerhsell.

Here is how we do it:

1. **Change the below param values in the script PostMessage.ps1**

    param (\
        [string]$uri="eventhubnamespace.servicebus.windows.net/eventhubname",\
        [string]$policyName="policyName",\
        [string]$policyKey="Xd64pfQW5k8RhTWLMITXKj23",\
        [string]$body = '{\
        "id": "ab4fee7e-e065-4767-b214-37ab22d01ae9",\
        "metaData": "test message",\
        "readDate": "0001-01-01T00:00:00",\
        "createdDate": "2020-03-06T15:49:26.9937576+00:00"\
        }'\
    )

    **eventhubnamespace:** Event hub namespace\
    **eventhubname:** Event hub name to which you want to send the message\
    **policyName:** Shared access policy name, this is typically the shared access policy on the eventhub. If you don't have\ shared access policy configured on event hub, You can use shared access policy name configured on the event hub namespace.\
    **policyKey:** The shared access key corresponding to the shared access policy.\
    **body:** The message to be sent to the eventhub\

2. **Open powershell and login into Azure account, assumimg az module for powershell is installed.**

    az login

3. **Set the current subscription to the one that have event hub**

    az account set --subscription <subscriptionid>

4. **Execute the script ./PostMessage.ps1**

5. **Check message on the event hub.**

