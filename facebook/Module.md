Connects to Facebook from Ballerina.

# Module Overview
The Facebook connector allows you to create post, retrieve post, delete post, get friend list and get page access tokens through the Facebook Graph API. It handles OAuth 2.0 authentication.

**Post Operations**

The `wso2/facebook` module contains operations to create post, retrieve post, delete post, get friend list and get page access tokens.

## Compatibility

|                                 |       Version                  |
|  :---------------------------:  |  :---------------------------: |
|  Ballerina Language             |   0.990.0                      |
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

The `createPost` function creates a post for a user, page, event, or group.
```ballerina
//Create post.
var response = facebookEP->createPost(id,message,link,place);
```

The response from `createPost` is a `Post` object if the request was successful or a `error` on failure. .
```ballerina
if (response is Post) {
   //If successful, returns the Post object.
   response = response;
   io:println(fbRes);
} else {
   //Unsuccessful attempts return a error.
   io:println(response);
}
```

The `retrievePost` function retrieves the post specified by the ID. The `postId` represents the ID of the post to be retrieved. It returns the `Post` object on success and `error` on failure.
```ballerina
var response = facebookEP.retrievePost(postId);
if (response is Post) {
    p = response;
    io:println(p);
} else {
    io:println(response);
}
```

The `deletePost` function deletes the post specified by the ID. The `postId` represents the ID of the post to be deleted. It returns the `True` object on success and `error` on failure.
```ballerina
var response = facebookEP.deletePost(postId);
if (response is boolean) {
    b = response;
    io:println(b);
} else {
    io:println(response);
}
```

The `getFriendListDetails` function used to get the User's friends who have installed the app making the query. The `userId` represents the ID of the user. It returns the `FriendList` object on success and `error` on failure.
```ballerina
var response = facebookEP.getFriendListDetails(userId);
if (response is FriendList) {
    friendList = response; 
    io:println(friendList); 
} else {
     io:println(response);
}
```

The `getPageAccessTokens` function used to get the page access tokens. The `userId` represents the ID of the user. It returns the `AccessTokens` object on success and `error` on failure.
```ballerina
var response = facebookEP.getPageAccessTokens(userId);
if (response is AccessTokens) {
    list = response; 
    io:println(accessTokenList); 
} else {
    io:println(response);
}
```

##### Example

```
import ballerina/io;
import wso2/facebook;
import ballerina/config;

public function main() {
    string userAccessToken = config:getAsString("ACCESS_TOKEN");
    string pageAccessToken = callMethodsWithUserToken(userAccessToken);
    callMethodsWithPageToken(pageAccessToken);
}

facebook:FacebookConfiguration facebookConfig = {
    clientConfig:{
        auth:{
            scheme: http:OAUTH2,
            accessToken:accessToken
        }
    }
};

facebook:Client facebookclient = new(facebookConfig);

function callMethodsWithUserToken(string userAccessToken) returns string {
    
    io:println("-----------------Calling to get page accessTokens details------------------");
    //Get page tokens
    var tokenResponse = client->getPageAccessTokens("me");
    //facebook:AccessTokens accessTokenList = {};
    string pageToken;

    if (tokenResponse is facebook:AccessTokens) {
            pageToken = tokenResponse.data[0].pageAccessToken;
            io:println("Page token details: ");
            io:println(tokenResponse.data);
            io:println("Page Name: ");
            io:println(tokenResponse.data[0].pageName);
            io:println("Page token: ");
            io:println(pageToken);
    } else {
        io:println(tokenResponse.detail().message);
    }

    io:println("-----------------Calling to get friends list details------------------");
    //Get Friends list details
    var friendsResponse = client->getFriendListDetails("me");
    if (friendsResponse is facebook:FriendList) {
        io:println("Friends list: ");
        io:println(friendsResponse.data);
        io:println("Friends list count: ");
        io:println(list.summary.totalCount);
    } else {
        io:println(e.message);
    }
    return pageToken;
}

function callMethodsWithPageToken(string pageAccessToken) {
    endpoint facebook:Client client {
        clientConfig:{
            auth:{
                accessToken:pageAccessToken
            }
        }
    };
    io:println("-----------------Calling to create fb post------------------");
    var createPostResponse = client->createPost("me","testBalMeassage","","");
    string postId;
    if (createPostResponse is facebook:Post) {
        postId = createPostResponse.id;
        io:println("Post Id: ");
        io:println(createPostResponse);
    } else {
       io:println(createPostResponse.detail().message);
    }

    io:println("-----------------Calling to retrieve fb post------------------");
    var retrievePostResponse = client->retrievePost(postId);
    if (retrievePostResponse is facebook:Post) {
        io:println("Post Details: ");
        io:println(retrievePostResponse);
    } else {
        io:println(retrievePostResponse.detail().message);
    }

    io:println("-----------------Calling to delete fb post------------------");
    var deleteResponse = client->deletePost(postId);
    if (deleteResponse is boolean) {
        io:println(deleteResponse);
    } else {
        io:println(deleteResponse.detail().message);
    }
}

```