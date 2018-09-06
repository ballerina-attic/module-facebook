# Ballerina Facebook Connector - Tests
The Facebook connector allows you to create post, retrieve post, delete post, get friend list and get page access tokens through the Facebook Graph API. It handles OAuth 2.0 authentication.


## Compatibility

| Ballerina Language Version  | Facebook API Version |
| ----------------------------| ---------------------|
|  0.981.0                    |   v3.1               |


## Running Samples
You can use the `tests.bal` file to test all the connector actions by following the below steps:
1. Navigate to package-facebook and initialize the ballerina project
    ```
    ballerina init
    ```

2. Obtain the access token and add that value in the package-facebook/ballerina.conf file.
    ```
    ACCESS_TOKEN="your_access_token"
    ```

4. Run the following command to execute the tests.
    ```
    ballerina test facebook --config ballerina.conf
    ```

