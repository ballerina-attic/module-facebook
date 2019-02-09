Connects to Facebook from Ballerina.

# Module Overview
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


**Obtaining Tokens to Run the Sample**

1. Setup a new web application client in the [Facebook APP console](https://developers.facebook.com/apps)
2. Obtain client_id, client_secret and register a callback URL.
3. Replace your client_id and redirect URI in the following URL and navigate to that URL in the browser. It will redirect you to a page allow the access with the required permission.
    `https://www.facebook.com/v3.1/dialog/oauth?client_id=<your_client_id>&redirect_uri=<your_redirect_uri>&scope=<scopes>`
4. After accepting the permission to allow access it will return a code in the url.
5. Send a post request to with the above code to the following endpoint to get the access_token. Replace your client_id, client_secret, redirect_uri, and code(retrieved from step 4).
    `https://graph.facebook.com/oauth/access_token?client_id=<your_client_id>&redirect_uri=<your_redirect_uri>&client_secret=<your_client_secret>&code=<code>`
6. You will get a user access token in the response.
7. If you want to publish the post to a page you need to retrieve the page token by invoking the following facebook connector method with the user access token you obtain in the step 6:
    `getPageAccessTokens(userId)`.
    Page token and page details will be returned in the response.

    For this enter user token in the following HTTP client config to use `getPageAccessTokens(userId)`:
    ```ballerina
    facebook:FacebookConfiguration facebookConfig = {
        clientConfig:{
            auth:{
                scheme: http:OAUTH2,
                accessToken:accessToken
            }
        }
    };
    
    facebook:Client facebookclient = new(facebookConfig);
    ```

You can now enter page token to publish a post in a facebook page in the HTTP client config:
```ballerina
facebook:FacebookConfiguration facebookConfig = {
    clientConfig:{
        auth:{
            scheme: http:OAUTH2,
            accessToken:accessToken
        }
    }
};

facebook:Client facebookclient = new(facebookConfig);
```

The `createPost` remote function creates a post for a user, page, event, or group.
```ballerina
// Create a post.
var response = facebookEP->createPost(id,message,link,place);
```

The response from `createPost` is a `Post` object if the request is successful or an `error` if unsuccessful.
```ballerina
if (response is facebook:Post) {
   // If successful, print the Post details.
   io:println("Post Details: ", response);
} else {
   // If unsuccessful, print the error returned.
   io:println("Error: ", response);
}
```

The `retrievePost` remote function retrieves the post specified by the ID. The `postId` represents the ID of the post to be retrieved. It returns the `Post` object on success or an `error` if unsuccessful.
```ballerina
var response = facebookEP.retrievePost(postId);
if (response is facebook:Post) {
    io:println("Post Details: ", response);
} else {
    io:println("Error: ", response);
}
```

The `deletePost` remote function deletes the post specified by the ID. The `postId` represents the ID of the post to be deleted. It returns deletion status on success or an `error` if an error occurred.
```ballerina
var response = facebookEP.deletePost(postId);
if (response is boolean) {
    io:println("Status: ", response);
} else {
    io:println("Error: ", response);
}
```

The `getFriendListDetails` remote function is used to get the user's friends who have installed the app making the query. The `userId` represents the ID of the user. It returns a `FriendList` object on success or an `error` if unsuccessful.
```ballerina
var response = facebookEP.getFriendListDetails(userId);
if (response is facebook:FriendList) {
    io:println("Friend List: ", response);
} else {
     io:println("Error: ", response);
}
```

The `getPageAccessTokens` remote function is used to get the page access tokens. The `userId` represents the ID of the user. It returns an `AccessTokens` object on success or an `error` if unsuccessful.
```ballerina
var response = facebookEP.getPageAccessTokens(userId);
if (response is facebook:AccessTokens) {
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
import wso2/facebook;

facebook:FacebookConfiguration facebookConfig = {
    clientConfig:{
        auth:{
            scheme: http:OAUTH2,
            accessToken: config:getAsString("ACCESS_TOKEN")
        }
    }
};

facebook:Client facebookclient = new(facebookConfig);

string pageAccessToken = "";
public function main(string... args) {
    pageAccessToken = untaint callMethodsWithUserToken();
    callMethodsWithPageToken();
}

function callMethodsWithUserToken() returns string {
    io:println("-----------------Calling to get page accessTokens details------------------");
    //Get page tokens
    var tokenResponse = facebookclient->getPageAccessTokens("me");
    string pageToken = "";

    if (tokenResponse is facebook:AccessTokens) {
        pageToken = tokenResponse.data[0].pageAccessToken;
        io:println("Page token details: ", tokenResponse.data);
        io:println("Page Name: ", tokenResponse.data[0].pageName);
        io:println("Page token: ", pageToken);
    } else {
        io:println("Error: ", tokenResponse.detail().message);
    }

    io:println("-----------------Calling to get friends list details------------------");
    //Get Friends list details
    var friendsResponse = facebookclient->getFriendListDetails("me");
    if (friendsResponse is facebook:FriendList) {
        io:println("Friends list Details: ", friendsResponse.data);
        io:println("Friends list count: ", friendsResponse.summary.totalCount);
    } else {
        io:println("Error: ", friendsResponse.detail().message);
    }
    return pageToken;
}

facebook:FacebookConfiguration facebookPageConfig = {
    clientConfig:{
        auth:{
            scheme: http:OAUTH2,
            accessToken: getpageToken()
        }
    }
};

facebook:Client facebookPageclient = new(facebookPageConfig);

function getpageToken() returns string {
    return pageAccessToken;
}

function callMethodsWithPageToken() {
    io:println("-----------------Calling to create fb post------------------");
    var createPostResponse = facebookPageclient->createPost("me","testBalMeassage","","");
    string postId = "";
    if (createPostResponse is facebook:Post) {
        postId = untaint createPostResponse.id;
        io:println("Post Details: ", createPostResponse);
        io:println("Post Id: ", postId);
    } else {
        io:println("Error: ", createPostResponse.detail().message);
    }

    io:println("-----------------Calling to retrieve fb post------------------");
    var retrievePostResponse = facebookPageclient->retrievePost(postId);
    if (retrievePostResponse is facebook:Post) {
        io:println("Post Details: ", retrievePostResponse);
    } else {
        io:println("Error: ", retrievePostResponse.detail().message);
    }

    io:println("-----------------Calling to delete fb post------------------");
    var deleteResponse = facebookPageclient->deletePost(postId);
    if (deleteResponse is boolean) {
        io:println("Deleted Status: ", deleteResponse);
    } else {
        io:println("Error: ", deleteResponse.detail().message);
    }
}
```