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

# Facebook Client object.
# + facebookConnector - FacebookConnector Connector object
public type Client client object {

    public FacebookConnector facebookConnector;

    public function __init(FacebookConfiguration facebookconfig) {
        self.init(facebookconfig);
        self.facebookConnector = new(BASE_URL, facebookconfig);
    }

    # Initialize Facebook endpoint.
    #
    # + facebookconfig - Facebook configuraion
    public function init(FacebookConfiguration facebookconfig);

    # Create a new post.
    # + id - The identifier
    # + msg - The main body of the post
    # + link - The URL of a link to attach to the post
    # + place - Page ID of a location associated with this post
    # + return - Post object on success and error on failure
    remote function createPost(string id, string msg, string link, string place) returns Post|error {
        return self.facebookConnector->createPost(id, msg, link, place);
    }

    # Retrieve a post.
    # + postId - The post ID
    # + return - Post object on success and error on failure
    remote function retrievePost(string postId) returns Post|error {
        return self.facebookConnector->retrievePost(postId);
    }

    # Delete a post.
    # + postId - The post ID
    # + return - True on success and error on failure
    remote function deletePost(string postId) returns (boolean)|error {
        return self.facebookConnector->deletePost(postId);
    }

    # Get the User's friends who have installed the app making the query.
    # Get the User's total number of friends (including those who have not installed the app making the query).
    # + userId - The user ID
    # + return - FriendList object on success and error on failure
    remote function getFriendListDetails(string userId) returns FriendList|error {
        return self.facebookConnector->getFriendListDetails(userId);
    }

    # Get a list of all the Pages managed by that User, as well as a Page access tokens for each Page.
    # + userId - The user ID
    # + return - AccessTokens object on success and error on failure
    remote function getPageAccessTokens(string userId) returns AccessTokens|error {
        return self.facebookConnector->getPageAccessTokens(userId);
    }

    # Retrieve details of the event.
    # + eventId - The event ID
    # + return - `Event` object on success or `error` on failure
    remote function retrieveEventDetails(string eventId) returns Event|error {
        return self.facebookConnector->retrieveEventDetails(eventId);
    }
};

function Client.init(FacebookConfiguration facebookconfig) {
    http:AuthConfig? authConfig = facebookconfig.clientConfig.auth;
    if (authConfig is http:AuthConfig) {
        authConfig.scheme = http:OAUTH2;
    }
}
