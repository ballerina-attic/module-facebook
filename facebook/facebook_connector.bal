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

function FacebookConnector::createPost(string id, string msg, string link, string place) returns Post|FacebookError {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    FacebookError facebookError = {};
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
            facebookError.message = err.message;
            facebookError.cause = err.cause;
            return facebookError;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    facebookError.message = "Error occured while extracting Json Payload";
                    facebookError.cause = err.cause;
                    return facebookError;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        Post fbPost = convertToPost(jsonResponse);
                        return fbPost;
                    } else {
                        facebookError.message = jsonResponse.error.message.toString();
                        facebookError.statusCode = statusCode;
                        return facebookError;
                    }
                }
            }
        }
    }
}

function FacebookConnector::retrievePost(string postId) returns Post|FacebookError {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    FacebookError facebookError = {};
    string facebookPath = VERSION + PATH_SEPARATOR + postId + FIELDS;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            facebookError.message = err.message;
            facebookError.cause = err.cause;
            return facebookError;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    facebookError.message = "Error occured while extracting Json Payload";
                    facebookError.cause = err.cause;
                    return facebookError;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        Post fbPost = convertToPost(jsonResponse);
                        return fbPost;
                    } else {
                        facebookError.message = jsonResponse.error.message.toString();
                        facebookError.statusCode = statusCode;
                        return facebookError;
                    }
                }
            }
        }
    }
}

function FacebookConnector::deletePost(string postId) returns (boolean)|FacebookError {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    FacebookError facebookError = {};
    string facebookPath = VERSION + PATH_SEPARATOR + postId;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            facebookError.message = err.message;
            facebookError.cause = err.cause;
            return facebookError;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    facebookError.message = "Error occured while extracting Json Payload";
                    facebookError.cause = err.cause;
                    return facebookError;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        return true;
                    } else {
                        facebookError.message = jsonResponse.error.message.toString();
                        facebookError.statusCode = statusCode;
                        return facebookError;
                    }
                }
            }
        }
    }
}

function FacebookConnector::retrieveEventDetails(string eventId) returns Event|FacebookError {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    string facebookPath = VERSION + PATH_SEPARATOR + eventId;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            FacebookError facebookError = { message: "Error retrieving event details", cause: err };
            return facebookError;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    FacebookError facebookError = { message: "Error occured while extracting JSON Payload",
                                                    cause: err };
                    return facebookError;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        match(<Event> jsonResponse) {
                            Event fbEvent => return fbEvent;
                            error err => {
                                FacebookError facebookError = { message: "Error converting JSON to Event record",
                                                                cause: err };
                                return facebookError;
                            }
                        }
                    } else {
                        FacebookError facebookError = { message: jsonResponse.error.message.toString(),
                                                        statusCode: statusCode };
                        return facebookError;
                    }
                }
            }
        }
    }
}

function FacebookConnector::getFriendListDetails(string userId) returns FriendList|FacebookError {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    FacebookError facebookError = {};
    string facebookPath = VERSION + PATH_SEPARATOR + userId + FRIENDS;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            facebookError.message = err.message;
            facebookError.cause = err.cause;
            return facebookError;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    facebookError.message = "Error occured while extracting Json Payload";
                    facebookError.cause = err.cause;
                    return facebookError;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        FriendList friendList = convertToFriendList(jsonResponse);
                        return friendList;
                    } else {
                        facebookError.message = jsonResponse.error.message.toString();
                        facebookError.statusCode = statusCode;
                        return facebookError;
                    }
                }
            }
        }
    }
}

function FacebookConnector::getPageAccessTokens(string userId) returns AccessTokens|FacebookError {
    endpoint http:Client httpClient = self.httpClient;
    http:Request request = new;
    FacebookError facebookError = {};
    string facebookPath = VERSION + PATH_SEPARATOR + userId + ACCOUNTS;
    request.setHeader("Accept", "application/json");
    var httpResponse = httpClient->get(facebookPath, message = request);

    match httpResponse {
        error err => {
            facebookError.message = err.message;
            facebookError.cause = err.cause;
            return facebookError;
        }
        http:Response response => {
            int statusCode = response.statusCode;
            var facebookJSONResponse = response.getJsonPayload();
            match facebookJSONResponse {
                error err => {
                    facebookError.message = "Error occured while extracting Json Payload";
                    facebookError.cause = err.cause;
                    return facebookError;
                }
                json jsonResponse => {
                    if (statusCode == http:OK_200) {
                        AccessTokens accessTokens = convertToAccessTokens(jsonResponse);
                        return accessTokens;
                    } else {
                        facebookError.message = jsonResponse.error.message.toString();
                        facebookError.statusCode = statusCode;
                        return facebookError;
                    }
                }
            }
        }
    }
}
