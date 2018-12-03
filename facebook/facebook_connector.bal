// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/mime;
import ballerina/http;

# Facebook Client Connector.
# + facebookClient - The HTTP Client

public type FacebookConnector client object {

    public http:Client facebookClient;

    public function __init(string url, FacebookConfiguration facebookconfig) {
        self.facebookClient = new(url, config = facebookconfig.clientConfig);
    }

    # Create a new post.
    # + id - The identifier
    # + msg - The main body of the post
    # + link - The URL of a link to attach to the post
    # + place - Page ID of a location associated with this post
    # + return - Post object on success and error on failure
    remote function createPost(string id, string msg, string link, string place) returns Post|error;

    # Retrieve a post.
    # + postId - The post ID
    # + return - Post object on success and error on failure
    remote function retrievePost(string postId) returns Post|error;

    # Delete a post.
    # + postId - The post ID
    # + return - True on success and error on failure
    remote function deletePost(string postId) returns (boolean)|error;

    # Get the User's friends who have installed the app making the query.
    # Get the User's total number of friends (including those who have not installed the app making the query).
    # + userId - The user ID
    # + return - FriendList object on success and error on failure
    remote function getFriendListDetails(string userId) returns FriendList|error;

    # Get a list of all the Pages managed by that User, as well as a Page access tokens for each Page.
    # + userId - The user ID
    # + return - AccessTokens object on success and error on failure
    remote function getPageAccessTokens(string userId) returns AccessTokens|error;

    # Retrieve details of the event.
    # + eventId - The event ID
    # + return - `Event` object on success or `error` on failure
    remote function retrieveEventDetails(string eventId) returns Event|error;
};

remote function FacebookConnector.createPost(string id, string msg, string link, string place) returns Post|error {
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + id + FEED_PATH;
    string uriParams;
    uriParams = msg != EMPTY_STRING ? MESSAGE + check http:encode(msg, UTF_8) : uriParams;
    uriParams = link != EMPTY_STRING ? LINK + check http:encode(link, UTF_8) : uriParams;
    uriParams = place != EMPTY_STRING ? PLACE + check http:encode(place, UTF_8) : uriParams;
    facebookPath = facebookPath + QUESTION_MARK + uriParams.substring(1, uriParams.length());
    request.setHeader("Accept", "application/json");
    var httpResponse = self.facebookClient->post(facebookPath, request);
    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var facebookJSONResponse = httpResponse.getJsonPayload();
        if(facebookJSONResponse is json) {
            if (statusCode == http:OK_200) {
                Post fbPost = convertToPost(facebookJSONResponse);
                return fbPost;
            } else {
                return setResponseError(statusCode, facebookJSONResponse);
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while accessing the JSON payload
                                        of the response." });
            return err;
        }
    } else {
        error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while invoking the facebook API" });
        return err;
    }
}

remote function FacebookConnector.retrievePost(string postId) returns Post|error {
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + postId + FIELDS;
    request.setHeader("Accept", "application/json");
    var httpResponse = self.facebookClient->get(facebookPath, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var facebookJSONResponse = httpResponse.getJsonPayload();
            if(facebookJSONResponse is json) {
                if (statusCode == http:OK_200) {
                    Post fbPost = convertToPost(facebookJSONResponse);
                    return fbPost;
                } else {
                    return setResponseError(statusCode, facebookJSONResponse);
                }
            } else {
                error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while accessing the JSON payload
                            of the response." });
                return err;
            }
    } else {
        error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while invoking the facebook API" });
        return err;
    }
}

remote function FacebookConnector.deletePost(string postId) returns (boolean)|error {
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + postId;
    request.setHeader("Accept", "application/json");
    var httpResponse = self.facebookClient->get(facebookPath, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var facebookJSONResponse = httpResponse.getJsonPayload();
        if(facebookJSONResponse is json) {
            if (statusCode == http:OK_200) {
                return true;
            } else {
                return setResponseError(statusCode, facebookJSONResponse);
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while accessing the JSON payload
                                        of the response." });
            return err;
        }
    } else {
        error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while invoking the facebook API" });
        return err;
    }
}

remote function FacebookConnector.retrieveEventDetails(string eventId) returns Event|error {
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + eventId;
    request.setHeader("Accept", "application/json");
    var httpResponse = self.facebookClient->get(facebookPath, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var facebookJSONResponse = httpResponse.getJsonPayload();
        if(facebookJSONResponse is json) {
            if (statusCode == http:OK_200) {
                if (Event.create(facebookJSONResponse) is Event) {
                    return Event.create(facebookJSONResponse);
                } else {
                    error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while accessing the Event
                    payload of the response." });
                    return err;
                }
            } else {
                return setResponseError(statusCode, facebookJSONResponse);
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while accessing the JSON payload
                                                    of the response." });
            return err;
        }
    } else {
        error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while invoking the facebook API" });
        return err;
    }
}

remote function FacebookConnector.getFriendListDetails(string userId) returns FriendList|error {
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + userId + FRIENDS;
    request.setHeader("Accept", "application/json");
    var httpResponse = self.facebookClient->get(facebookPath, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var facebookJSONResponse = httpResponse.getJsonPayload();
        if(facebookJSONResponse is json) {
            if (statusCode == http:OK_200) {
                FriendList friendList = convertToFriendList(facebookJSONResponse);
                return friendList;
            } else {
                return setResponseError(statusCode, facebookJSONResponse);
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while accessing the JSON payload
                                                                of the response." });
            return err;
        }
    } else {
        error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while invoking the facebook API" });
        return err;
    }
}

remote function FacebookConnector.getPageAccessTokens(string userId) returns AccessTokens|error {
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + userId + ACCOUNTS;
    request.setHeader("Accept", "application/json");
    var httpResponse = self.facebookClient->get(facebookPath, message = request);

    if (httpResponse is http:Response) {
        int statusCode = httpResponse.statusCode;
        var facebookJSONResponse = httpResponse.getJsonPayload();
        if(facebookJSONResponse is json) {
            if (statusCode == http:OK_200) {
                AccessTokens accessTokens = convertToAccessTokens(facebookJSONResponse);
                return accessTokens;
            } else {
                return setResponseError(statusCode, facebookJSONResponse);
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while accessing the JSON payload
                                                    of the response." });
            return err;
        }
    } else {
        error err = error(FACEBOOK_ERROR_CODE , { message : "Error occurred while invoking the facebook API" });
        return err;
    }
}

function setResponseError(int statusCode, json jsonResponse) returns error {
    error err = error(FACEBOOK_ERROR_CODE , { message : jsonResponse["error"].message.toString() });
    return err;
}
