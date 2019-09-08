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

import ballerina/http;
import ballerina/oauth2;
import ballerina/encoding;

# Facebook Client object.
# + facebookClient - HTTP Client endpoint
public type FacebookClient client object {

    http:Client facebookClient;

    # Initialize Facebook endpoint.
    #
    # + facebookconfig - Facebook configuraion
    public function __init(FacebookConfiguration facebookconfig) {
        string token = facebookconfig.accessToken;
        oauth2:OutboundOAuth2Provider oauth2Provider = new ({accessToken: token});
        http:BearerAuthHandler oauth2Handler = new (oauth2Provider);
        self.facebookClient = new (BASE_URL, config = {
            auth: {
                authHandler: oauth2Handler
            }            
        });
    }

    # Create a new post.
    # + id - The identifier
    # + msg - The main body of the post
    # + link - The URL of a link to attach to the post
    # + place - Page ID of a location associated with this post    # 
    # + pageToken - The access token of the page
    # + return - Post object on success and error on failure
    public remote function createPost(string id, string msg, string link, string place, string pageToken) returns @untainted Post | error {
        http:Request request = new;
        string facebookPath = VERSION + PATH_SEPARATOR + id + FEED_PATH;
        string uriParams;
        uriParams = msg != EMPTY_STRING ? MESSAGE + check encoding:encodeUriComponent(msg, UTF_8) : uriParams;
        uriParams = link != EMPTY_STRING ? LINK + check encoding:encodeUriComponent(link, UTF_8) : uriParams;
        uriParams = place != EMPTY_STRING ? PLACE + check encoding:encodeUriComponent(place, UTF_8) : uriParams;
        facebookPath = facebookPath + QUESTION_MARK + uriParams.substring(1, uriParams.length()) + PAGE_ACCESS_TOKEN + pageToken;
        request.setHeader("Accept", "application/json");
        var httpResponse = self.facebookClient->post(facebookPath, request);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var facebookJSONResponse = httpResponse.getJsonPayload();
            if (facebookJSONResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    Post fbPost = convertToPost(facebookJSONResponse);
                    return fbPost;
                } else {
                    return setResponseError(statusCode, facebookJSONResponse);
                }
            } else {
                error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while accessing the JSON payload
                                                    of the response.");
                return err;
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while invoking the facebook API");
            return err;
        }
    }

    # Retrieve a post.
    # + postId - The post ID
    # + return - Post object on success and error on failure
    public remote function retrievePost(string postId) returns @untainted Post | error {
        http:Request request = new;
        string facebookPath = VERSION + PATH_SEPARATOR + postId + FIELDS;

        request.setHeader("Accept", "application/json");
        var httpResponse = self.facebookClient->get(facebookPath, message = request);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var facebookJSONResponse = httpResponse.getJsonPayload();
            if (facebookJSONResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    Post fbPost = convertToPost(facebookJSONResponse);
                    return fbPost;
                } else {
                    return setResponseError(statusCode, facebookJSONResponse);
                }
            } else {
                error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while accessing the JSON payload
                                        of the response.");
                return err;
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while invoking the facebook API");
            return err;
        }
    }

    # Delete a post.
    # + postId - The post ID
    # + pageToken - The access token of the page
    # + return - True on success and error on failure
    public remote function deletePost(string postId, string pageToken) returns (boolean) | error {
        http:Request request = new;
        string facebookPath = PATH_SEPARATOR + postId + QUESTION_MARK + PAGE_ACCESS_TOKEN + pageToken;

        request.setHeader("Accept", "application/json");
        var httpResponse = self.facebookClient->delete(facebookPath, message = request);
        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var facebookJSONResponse = httpResponse.getJsonPayload();
            if (facebookJSONResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    return true;
                } else {
                    return setResponseError(statusCode, facebookJSONResponse);
                }
            } else {
                error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while accessing the JSON payload
                                                    of the response.");
                return err;
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while invoking the facebook API");
            return err;
        }
    }

    # Get the User's friends who have installed the app making the query.
    # Get the User's total number of friends (including those who have not installed the app making the query).
    # + userId - The user ID
    # + return - FriendList object on success and error on failure
    public remote function getFriendListDetails(string userId) returns @untainted FriendList | error {
        http:Request request = new;
        string facebookPath = VERSION + PATH_SEPARATOR + userId + FRIENDS;
        request.setHeader("Accept", "application/json");
        var httpResponse = self.facebookClient->get(facebookPath, message = request);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var facebookJSONResponse = httpResponse.getJsonPayload();
            if (facebookJSONResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    FriendList friendList = convertToFriendList(facebookJSONResponse);
                    return friendList;
                } else {
                    return setResponseError(statusCode, facebookJSONResponse);
                }
            } else {
                error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while accessing the JSON payload
                                                                            of the response.");
                return err;
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while invoking the facebook API");
            return err;
        }
    }

    # Get a list of all the Pages managed by that User, as well as a Page access tokens for each Page.
    # + userId - The user ID
    # + return - AccessTokens object on success and error on failure
    public remote function getPageAccessTokens(string userId) returns @untainted AccessTokens | error {
        http:Request request = new;
        string facebookPath = VERSION + PATH_SEPARATOR + userId + ACCOUNTS;
        request.setHeader("Accept", "application/json");
        var httpResponse = self.facebookClient->get(facebookPath, message = request);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var facebookJSONResponse = httpResponse.getJsonPayload();
            if (facebookJSONResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    AccessTokens accessTokens = convertToAccessTokens(facebookJSONResponse);
                    return accessTokens;
                } else {
                    return setResponseError(statusCode, facebookJSONResponse);
                }
            } else {
                error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while accessing the JSON payload
                                                                of the response.");
                return err;
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while invoking the facebook API");
            return err;
        }
    }

    # Retrieve details of the event.
    # + eventId - The event ID
    # + return - `Event` object on success or `error` on failure
    public remote function retrieveEventDetails(string eventId) returns @untainted Event | error {
        http:Request request = new;
        string facebookPath = VERSION + PATH_SEPARATOR + eventId;
        request.setHeader("Accept", "application/json");
        var httpResponse = self.facebookClient->get(facebookPath, message = request);

        if (httpResponse is http:Response) {
            int statusCode = httpResponse.statusCode;
            var facebookJSONResponse = httpResponse.getJsonPayload();
            if (facebookJSONResponse is json) {
                if (statusCode == http:STATUS_OK) {
                    if (Event.constructFrom(facebookJSONResponse) is Event) {
                        return Event.constructFrom(facebookJSONResponse);
                    } else {
                        error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while accessing the Event
                                        payload of the response.");
                        return err;
                    }
                } else {
                    return setResponseError(statusCode, facebookJSONResponse);
                }
            } else {
                error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while accessing the JSON payload
                                                                of the response.");
                return err;
            }
        } else {
            error err = error(FACEBOOK_ERROR_CODE, message = "Error occurred while invoking the facebook API");
            return err;
        }
    }
};

function setResponseError(int statusCode, json jsonResponse) returns error {
    error err = error(FACEBOOK_ERROR_CODE , message = jsonResponse.'error.message.toString());
    return err;
}
