[![Build Status](https://travis-ci.org/wso2-ballerina/module-facebook.svg?branch=master)](https://travis-ci.org/wso2-ballerina/module-facebook)

# Ballerina Facebook Connector

The Facebook connector allows you to create post, retrieve post, delete post, get friend list and get page access tokens through the Facebook Graph API. It handles OAuth 2.0 authentication.

**Post Operations**

The `wso2/facebook4` module contains operations to create post, retrieve post, delete post, get friend list and get page access tokens.

## Compatibility

|                                 |       Version                  |
|  :---------------------------:  |  :---------------------------: |
|  Ballerina Language             |   1.0.0                        |
|  Facebook API                   |   v4.0                         |

## Sample

First, import the `wso2/facebook4` module into the Ballerina project.

```ballerina
import wso2/facebook4;
```

Instantiate the connector by giving authentication details in the HTTP client config. The HTTP client config has built-in support for BasicAuth and OAuth 2.0. Facebook uses OAuth 2.0 to authenticate and authorize requests. The Facebook connector can be instantiated in the HTTP client config using the access token.


**Run the Sample**

You can now enter the credentials in the HTTP client config:
```ballerina
facebook4:FacebookConfiguration facebookConfig = {
    accessToken: <YOUR_ACCESS_TOKEN>
};

facebook4:FacebookClient facebookclient = new (facebookConfig);
```

The `createPost` remote function creates a post for a user, page, event, or group.
```ballerina
// Create a post.
var response = facebookClient->createPost(id,message,link,place,page_token);
```

The response from `createPost` is a `Post` object if the request is successful or an `error` if unsuccessful.
```ballerina
if (response is facebook4:Post) {
   // If successful, print the Post details.
   io:println("Post Details: ", response);
} else {
   // If unsuccessful, print the error returned.
   io:println("Error: ", response);
}
```

The `retrievePost` remote function retrieves the post specified by the ID. The `postId` represents the ID of the post to be retrieved. It returns the `Post` object on success or an `error` if unsuccessful.
```ballerina
var response = facebookEP->retrievePost(postId);
if (response is facebook4:Post) {
    io:println("Post Details: ", response);
} else {
    io:println("Error: ", response);
}
```

The `deletePost` remote function deletes the post specified by the ID. The `postId` represents the ID of the post to be deleted. It returns deletion status on success or an `error` if an error occurred.
```ballerina
var response = facebookEP->deletePost(postId,page_token);
if (response is boolean) {
    io:println("Status: ", response);
} else {
    io:println("Error: ", response);
}
```
