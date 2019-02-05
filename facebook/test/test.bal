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
AccessTokens accessTokenList = {};
string retrivePostId = "";

FacebookConfiguration facebookConfig = {
    clientConfig:{
        auth:{
            scheme: http:OAUTH2,
            accessToken:accessToken
        }
    }
};

Client facebookclient = new(facebookConfig);

@test:Config
function testGetPageAccessTokens() {
    io:println("-----------------Test case for GetPageAccessTokens method------------------");
    var response = facebookclient->getPageAccessTokens("me");
    if (response is AccessTokens) {
        accessTokenList = untaint response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    //pageToken = accessTokenList.data[0].pageAccessToken;
    test:assertNotEquals(accessTokenList.data, null, msg = "Failed to get page access tokens");
}

@test:Config
function testGetFriendListDetails() {
    io:println("-----------------Test case for GetFriendListDetails method------------------");
    FriendList friendList = {};
    var response = facebookclient->getFriendListDetails("me");
    if (response is FriendList) {
        friendList = response;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertNotEquals(friendList.data, null, msg = "Failed to get friend list");
    test:assertNotEquals(friendList.summary.totalCount, null, msg = "Failed to get friend list");
}

Post facebookPost = {};

FacebookConfiguration facebookPageConfig = {
    clientConfig:{
        auth:{
            scheme: http:OAUTH2,
            accessToken: getpageToken()
        }
    }
};

Client facebookPageclient = new(facebookPageConfig);

@test:Config
function getpageToken() returns string {
    var response = facebookclient->getPageAccessTokens("me");
    if (response is AccessTokens) {
        accessTokenList = untaint response;
    }
    string pageToken = accessTokenList.data[0].pageAccessToken;
    return pageToken;
}

@test:Config
function testCreatePost() {
    var response = facebookPageclient->createPost("me","testBalMeassage","","");
    if (response is Post) {
        facebookPost = response;
        retrivePostId = facebookPost.id;
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
    test:assertNotEquals(facebookPost.id, null, msg = "Failed to create post");
}

@test:Config {
    dependsOn:["testCreatePost"]
}
function testRetrievePost() {
    io:println("-----------------Test case for retrievePost method------------------");
    var response = facebookPageclient->retrievePost(retrivePostId);
    if (response is Post) {
        test:assertNotEquals(response.id, null, msg = "Failed to retrieve the post");
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
}

@test:Config {
    dependsOn:["testRetrievePost"]
}
function testDeletePost() {
    io:println("-----------------Test case for deletePost method------------------");
    var response = facebookPageclient->deletePost(facebookPost.id);
    if (response is boolean) {
        test:assertTrue(response, msg = "Failed to delete the post!");
    } else {
        test:assertFail(msg = <string>response.detail().message);
    }
}
