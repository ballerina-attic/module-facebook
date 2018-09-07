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

//API urls
@final string BASE_URL = "https://graph.facebook.com";
@final string VERSION = "/v3.1";
@final string FEED = "/feed";
@final string FRIENDS = "/friends";
@final string ACCOUNTS = "/accounts";
@final string FIELDS = "?fields=from,created_time,is_published,message,updated_time,type";
@final string VALUE_INPUT_OPTION = "valueInputOption=RAW";
@final string BATCH_UPDATE_REQUEST = ":batchUpdate";

//Symbols
@final string QUESTION_MARK = "?";
@final string PATH_SEPARATOR = "/";
@final string EMPTY_STRING = "";

//string constants
@final string UTF_8 = "UTF-8";
@final string FEED_PATH = "/feed";
@final string MESSAGE = "&message=";
@final string LINK = "&link=";
@final string PLACE = "&place=";