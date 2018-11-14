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

function FacebookConnector::createPost(string id, string msg, string link, string place) returns Post|error {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + id + FEED_PATH;
    string uriParams;
    uriParams = msg != EMPTY_STRING ? MESSAGE + check http:encode(msg, UTF_8) : uriParams;
    uriParams = link != EMPTY_STRING ? LINK + check http:encode(link, UTF_8) : uriParams;
    uriParams = place != EMPTY_STRING ? PLACE + check http:encode(place, UTF_8) : uriParams;
    facebookPath = facebookPath + QUESTION_MARK + uriParams.substring(1, uriParams.length());
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->post(facebookPath, request);

    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        Post fbPost = convertToPost(jsonResponse);
                        return fbPost;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function FacebookConnector::retrievePost(string postId) returns Post|error {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + postId + FIELDS;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        Post fbPost = convertToPost(jsonResponse);
                        return fbPost;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function FacebookConnector::deletePost(string postId) returns (boolean)|error {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + postId;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        return true;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function FacebookConnector::retrieveEventDetails(string eventId) returns Event|error {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + eventId;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        match(<Event> jsonResponse) {
                            Event fbEvent => return fbEvent;
                            error err => {
                                return err;
                            }
                        }
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function FacebookConnector::getFriendListDetails(string userId) returns FriendList|error {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + userId + FRIENDS;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        FriendList friendList = convertToFriendList(jsonResponse);
                        return friendList;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function FacebookConnector::getPageAccessTokens(string userId) returns AccessTokens|error {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + userId + ACCOUNTS;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            return err;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        AccessTokens accessTokens = convertToAccessTokens(jsonResponse);
                        return accessTokens;
                    } else {
                        return setResponseError(statusCode, jsonResponse);
                    }
                }
            }
        }
    }
}

function setResponseError(int statusCode, json jsonResponse) returns error {
    error err = {};
    err.message = jsonResponse.error.message.toString();
    err.statusCode = statusCode;
    return err;
}
