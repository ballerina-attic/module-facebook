# Ballerina Facebook Connector - Tests
The Facebook connector allows you to create post, retrieve post, delete post, get friend list and get page access tokens through the Facebook Graph API. It handles OAuth 2.0 authentication.


## Compatibility

| Ballerina Language Version  | Facebook API Version |
| ----------------------------| ---------------------|
|  1.0.0                      |   v4.0               |


## Running Samples
You can use the `tests.bal` file to test all the connector actions by following the below steps:
1. Create ballerina.conf file in module-facebook.
2. Obtain the access token and add that value in the ballerina.conf file.
    ```
    ACCESS_TOKEN = "your_access_token"
    ```
3. Navigate to the folder module-facebook.

4. Run the following command to execute the tests.
    ```
    ballerina test facebook4 --b7a.config.file=./ballerina.conf
    ```

