Connects to Facebook from Ballerina.

# Module Overview
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


**Obtaining Tokens to Run the Sample**

1. Setup a new web application client in the [Facebook APP console](https://developers.facebook.com/apps)
2. Open the [Graph API Explorer](https://developers.facebook.com/tools/explorer/) and get a new User Access Token.

This token can be used to initialize the Facebook client. Additionally, to pulish or delete a post in a page, you would require a page token. For that you can either get the page token from the Graph API explorer or use the `getPageAccessTokens(userId)` method of the connector.

Following is how the Facebook client should be initialized.
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
var response = facebookClient->retrievePost(postId);
if (response is facebook4:Post) {
    io:println("Post Details: ", response);
} else {
    io:println("Error: ", response);
}
```

The `deletePost` remote function deletes the post specified by the ID. The `postId` represents the ID of the post to be deleted. It returns deletion status on success or an `error` if an error occurred.
```ballerina
var response = facebookClient->deletePost(postId, page_token);
if (response is boolean) {
    io:println("Status: ", response);
} else {
    io:println("Error: ", response);
}
```

The `getFriendListDetails` remote function is used to get the user's friends who have installed the app making the query. The `userId` represents the ID of the user. It returns a `FriendList` object on success or an `error` if unsuccessful.
```ballerina
var response = facebookClient->getFriendListDetails(userId);
if (response is facebook4:FriendList) {
    io:println("Friend List: ", response);
} else {
     io:println("Error: ", response);
}
```

The `getPageAccessTokens` remote function is used to get the page access tokens. The `userId` represents the ID of the user. It returns an `AccessTokens` object on success or an `error` if unsuccessful.
```ballerina
var response = facebookClient->getPageAccessTokens(userId);
if (response is facebook4:AccessTokens) {
    io:println("Page Access Tokens: ", response);
} else {
    io:println("Error: ", response);
}
```

##### Example

```
import ballerina/config;
import ballerina/http;
import ballerina/io;
import wso2/facebook4;

facebook4:FacebookConfiguration facebookConfig = {
        accessToken: <YOUR_ACCESS_TOKEN>
    };

facebook4:FacebookClient facebookclient = new (facebookConfig);

string pageAccessToken = "";

public function main(string... args) {
    pageAccessToken = untaint callMethodsWithUserToken();
    callMethodsWithPageToken();
}

function callMethodsWithUserToken() returns string {
    io:println("-----------------Calling to get page accessTokens details------------------");
    //Get page tokens
    var tokenResponse = facebookClient->getPageAccessTokens("me");

    if (tokenResponse is facebook4:AccessTokens) {
        pageAccessToken = tokenResponse.data[0].pageAccessToken;
        io:println("Page token details: ", tokenResponse.data);
        io:println("Page Name: ", tokenResponse.data[0].pageName);
        io:println("Page token: ", pageToken);
    } else {
        io:println("Error: ", tokenResponse.detail().message);
    }

    io:println("-----------------Calling to get friends list details------------------");
    //Get Friends list details
    var friendsResponse = facebookClient->getFriendListDetails("me");
    if (friendsResponse is facebook4:FriendList) {
        io:println("Friends list Details: ", friendsResponse.data);
        io:println("Friends list count: ", friendsResponse.summary.totalCount);
    } else {
        io:println("Error: ", friendsResponse.detail().message);
    }
    return pageToken;
}

function callMethodsWithPageToken() {
    io:println("-----------------Calling to create fb post------------------");
    var createPostResponse = facebookClient->createPost("me", "testBalMeassage", "", "", pageAccessToken);
    string postId = "";
    if (createPostResponse is facebook4:Post) {
        postId = untaint createPostResponse.id;
        io:println("Post Details: ", createPostResponse);
        io:println("Post Id: ", postId);
    } else {
        io:println("Error: ", createPostResponse.detail().message);
    }

    io:println("-----------------Calling to retrieve fb post------------------");
    var retrievePostResponse = facebookClient->retrievePost(postId);
    if (retrievePostResponse is facebook4:Post) {
        io:println("Post Details: ", retrievePostResponse);
    } else {
        io:println("Error: ", retrievePostResponse.detail().message);
    }

    io:println("-----------------Calling to delete fb post------------------");
    var deleteResponse = facebookClient->deletePost(postId, pageAccessToken);
    if (deleteResponse is boolean) {
        io:println("Deleted Status: ", deleteResponse);
    } else {
        io:println("Error: ", deleteResponse.detail().message);
    }
}
```