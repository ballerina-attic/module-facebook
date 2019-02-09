[![Build Status](https://travis-ci.org/wso2-ballerina/module-facebook.svg?branch=master)](https://travis-ci.org/wso2-ballerina/module-facebook)

# Ballerina Facebook Connector

The Facebook connector allows you to create post, retrieve post, delete post, get friend list and get page access tokens through the Facebook Graph API. It handles OAuth 2.0 authentication.

**Post Operations**

The `wso2/facebook` module contains operations to create post, retrieve post, delete post, get friend list and get page access tokens.

## Compatibility

|                                 |       Version                  |
|  :---------------------------:  |  :---------------------------: |
|  Ballerina Language             |   0.990.3                      |
|  Facebook API                   |   v3.1                        |

## Sample

First, import the `wso2/facebook` module into the Ballerina project.

```ballerina
import wso2/facebook;
```

Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for BasicAuth and OAuth 2.0. Facebook uses OAuth 2.0 to authenticate and authorize requests. The Facebook connector can be instantiated in the HTTP client config using the access token.


**Run the Sample**

You can now enter the credentials in the HTTP client config:
```ballerina
facebook:FacebookConfiguration facebookConfig = {
    clientConfig:{
        auth:{
            scheme: http:OAUTH2,
            accessToken:accessToken
        }
    }
};

facebook:Client facebookClient = new(facebookConfig);

```

The `createPost` function creates a post for a user, page, event, or group.
```ballerina
//Create post.
var response = facebookClient->createPost(id,message,link,place);
```

The response from `createPost` is a `Post` object if the request is successful or an `error` if unsuccessful.
```ballerina
if (response is facebook:Post) {
   // If successful, print Post details.
   io:println("Post Details: ", response);
} else {
   // If unsuccessful, print the error returned.
   io:println("Error: ", response);
}
```

The `retrievePost` function retrieves the post specified by the ID. The `postId` represents the ID of the post to be retrieved. It returns the `Post` object on success or an `error` if unsuccessful.
```ballerina
var response = facebookEP.retrievePost(postId);
if (response is facebook:Post) {
    io:println("Post Details: ", response);
} else {
    io:println("Error: ", response);
}
```

The `deletePost` function deletes the post specified by the ID. The `postId` represents the ID of the post to be deleted. It returns the `True` object on success or an `error` if unsuccessful.
```ballerina
var response = facebookEP.deletePost(postId);
if (response is boolean) {
    io:println("Status: ", response);
} else {
    io:println("Error: ", response);
}
```
