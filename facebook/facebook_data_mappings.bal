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

function convertToPost(json jsonPost) returns Post {
    Post post = {};
    Profile profile = {};
    post.id = jsonPost.id.toString();
    post.message = jsonPost.message != null ? jsonPost.message.toString() : "";
    post.createdTime = jsonPost.created_time != null ? jsonPost.created_time.toString() : "";
    post.updatedTime = jsonPost.updated_time != null ? jsonPost.updated_time.toString() : "";
    post.postType = jsonPost["type"] != null ? jsonPost["type"].toString() : "";
    post.isPublished = jsonPost.is_published != null ? convertToBoolean(jsonPost.is_published) : false;
    profile.id = jsonPost["from"].id != null ? jsonPost["from"].id.toString() : "";
    profile.name = jsonPost["from"].name != null ? jsonPost["from"].name.toString() : "";
    post.fromObject = profile;
    return post;
}

function convertToBoolean(json jsonVal) returns (boolean) {
    string stringVal = jsonVal.toString();
    return <boolean>stringVal;
}

function convertToFriendList(json jsonFriend) returns FriendList {
    FriendList friendList = {};
    Summary summary = {};
    summary.totalCount = jsonFriend.summary.total_count != null ? jsonFriend.summary.total_count.toString() : "";
    friendList.summary = summary;
    friendList.data = convertToDatas(jsonFriend.data);
    return friendList;
}

function convertToDatas(json jsonDatas) returns Data[] {
    Data[] dataArray = [];
    int i = 0;
    foreach jsonData in jsonDatas {
        Data data = {};
        data.id = jsonData.id != null ? jsonData.id.toString() : "";
        data.name = jsonData.name != null ? jsonData.name.toString() : "";
        dataArray[i] = data;
        i = i + 1;
    }
    return dataArray;
}

function convertToAccessTokens(json jsonToken) returns AccessTokens {
    AccessTokens accessTokens = {};
    accessTokens.data = convertToAccessTokenData(jsonToken.data);
    return accessTokens;
}

function convertToAccessTokenData(json jsonData) returns AccessTokenData[] {
    AccessTokenData[] tokenData = [];
    int i = 0;
    foreach data in jsonData {
        AccessTokenData accessTokenData = {};
        accessTokenData.category = data.category != null ? data.category.toString() : "";
        accessTokenData.pageAccessToken = data.access_token != null ? data.access_token.toString() : "";
        accessTokenData.pageId = data.id != null ? data.id.toString() : "";
        accessTokenData.pageName = data.name != null ? data.name.toString() : "";
        tokenData[i] = accessTokenData;
        i = i + 1;
    }
    return tokenData;
}