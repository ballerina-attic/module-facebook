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

import ballerina/config;
import ballerina/io;
import ballerina/test;

string accessToken = config:getAsString("ACCESS_TOKEN");

endpoint Client client {
    clientConfig:{
        auth:{
            accessToken:accessToken
        }
    }
};

AccessTokens accessTokenList = {};
string pageToken;

@test:Config
function testGetPageAccessTokens() {
    io:println("-----------------Test case for GetPageAccessTokens method------------------");
    var fbRes = client->getPageAccessTokens("me");
    match fbRes {
        AccessTokens list => accessTokenList = list;
        FacebookError e => test:assertFail(msg = e.message);
    }
    pageToken = accessTokenList.data[0].pageAccessToken;
    test:assertNotEquals(accessTokenList.data, null, msg = "Failed to get page access tokens");
}

@test:Config
function testGetFriendListDetails() {
    io:println("-----------------Test case for GetFriendListDetails method------------------");
    FriendList friendList = {};
    var fbRes = client->getFriendListDetails("me");
    match fbRes {
        FriendList list => friendList = list;
        FacebookError e => test:assertFail(msg = e.message);
    }
    test:assertNotEquals(friendList.data, null, msg = "Failed to get friend list");
    test:assertNotEquals(friendList.summary.totalCount, null, msg = "Failed to get friend list");
}

Post facebookPost = {};

@test:Config {
    dependsOn:["testGetPageAccessTokens"]
}
function testCreatePost() {
    endpoint Client facebookClient {
        clientConfig:{
            auth:{
                accessToken:pageToken
            }
        }
    };
    io:println("-----------------Test case for createPost method------------------");
    var fbRes = facebookClient->createPost("me","testBalMeassage","","");
    match fbRes {
        Post post => facebookPost = post;
        FacebookError e => test:assertFail(msg = e.message);
    }
    test:assertNotEquals(facebookPost.id, null, msg = "Failed to create post");
}

@test:Config {
    dependsOn:["testGetPageAccessTokens", "testCreatePost"]
}
function testRetrievePost() {
    endpoint Client facebookClient {
        clientConfig:{
            auth:{
                accessToken:pageToken
            }
        }
    };
    io:println("-----------------Test case for retrievePost method------------------");
    var fbRes = facebookClient->retrievePost(facebookPost.id);
    match fbRes {
        Post post => test:assertNotEquals(post.id, null, msg = "Failed to retrieve the post");
        FacebookError e => test:assertFail(msg = e.message);
    }
}

@test:Config {
    dependsOn:["testGetPageAccessTokens", "testRetrievePost"]
}
function testDeletePost() {
    endpoint Client facebookClient {
        clientConfig:{
            auth:{
                accessToken:pageToken
            }
        }
    };
    io:println("-----------------Test case for deletePost method------------------");
    var fbRes = facebookClient->deletePost(facebookPost.id);
    match fbRes {
        boolean isDeleted => test:assertTrue(isDeleted, msg = "Failed to delete the post!");
        FacebookError e => test:assertFail(msg = e.message);
    }
}

