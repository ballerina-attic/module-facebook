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

# FacebookConfiguration is used to set up the Facebook configuration. In order to use this Connector, you need
# to provide the valid access token.
# + accessToken - The Facebook access token
public type FacebookConfiguration record {
    string accessToken;
};

# Post object.
# + id - The post ID
# + message - The status message in the post
# + createdTime - The time the post was initially published
# + updatedTime - The time when the Post was created, edited, or commented upon
# + postType - A string indicating the object type of this post (link, status, photo, video, offer)
# + fromObject - Information (name and id) about the Profile that created the Post
# + isPublished - Indicates whether a scheduled post was published (applies to scheduled Page Post
# only, for users post and instantly published posts this value is always true). Note that this value is
# always false
public type Post record {
    string id = "";
    string message = "";
    string createdTime = "";
    string updatedTime = "";
    string postType = "";
    Profile fromObject = {};
    boolean isPublished = false;
};

# The profile object is used within the Graph API to refer to the generic type that includes all of these
# (User/Page/Group)other objects.
# + id - The object ID
# + name - The object name
public type Profile record {
    string id = "";
    string name = "";
};

# Friend list object.
# + data - A list of User nodes
# + summary - Aggregated information about the edge, such as counts
public type FriendList record {
    Data[] data = [];
    Summary summary = {};
};

# A user node.
# + id - The user ID
# + name - The user name
public type Data record {
    string id = "";
    string name = "";
};

# A Summary object.
# + totalCount - Total number of objects on this edge
public type Summary record {
    string totalCount = "";
};

# Contains page accesstoken object.
# + data - AccessTokenData objects
public type AccessTokens record {
    AccessTokenData[] data = [];
};

# Contains page accesstoken details.
# + category - Product category
# + pageName - Page name
# + pageAccessToken - Page accessToken
# + pageId - A page id
public type AccessTokenData record {
    string category = "";
    string pageName = "";
    string pageAccessToken = "";
    string pageId = "";
};

# Event object.
# + id - The event ID
# + attending_count - The number of people attending
# + can_guests_invite - Whether guests can invite others
# + category - The category the event belongs to
# + declined_count - The number of people attending
# + description - Description of the event
# + discount_code_enabled - Whether a discount code is enabled for the event
# + end_time - The end time if set
# + guest_list_enabled - Whether the guest list can be seen
# + interested_count - Number of people interested in the event
# + is_canceled - Whether the event is marked cancelled
# + is_draft - Whether the event is drafted or published
# + is_page_owned - Whether the event was created by a page
# + maybe_count - Number of people who have marked attendance as maybe
# + name - The name of the event
# + noreply_count - The number of people who did not reply to the invitation
# + scheduled_publish_time - The time the event is scheduled to be published
# + start_time - The time the event is scheduled to start
# + ticket_uri - The link to buy tickets at for the event
# + ticket_uri_start_sales_time - The time at which tickets will go on sale
# + ticketing_privacy_uri - The link to the privacy policies of the ticket seller
# + ticketing_terms_uri - The link to the terms of service of the ticket seller
# + timezone - The timezone of the event
# + type - The type of the event
# + place - The place the event is scheduled to start
public type Event record {
    string id = "";
    int? attending_count = 0;
    boolean? can_guests_invite = false;
    string? category = "";
    int? declined_count = 0;
    string? description = "";
    boolean? discount_code_enabled = false;
    string? end_time = "";
    boolean? guest_list_enabled = false;
    int? interested_count = 0;
    boolean? is_canceled = false;
    boolean? is_draft = false;
    boolean? is_page_owned = false;
    int? maybe_count =0;
    string name = "";
    int? noreply_count = 0;
    Place? place = {};
    string? scheduled_publish_time = "";
    string start_time = "";
    string? ticket_uri = "";
    string? ticket_uri_start_sales_time = "";
    string? ticketing_privacy_uri = "";
    string? ticketing_terms_uri = "";
    string? timezone = "";
    string? 'type = "";
};

# Contains Place details.
# + id - The identifier for the place
# + name - The name of the place
# + overall_rating - The overall rating of the place
public type Place record {
    string? id ="";
    string name = "";
    float? overall_rating = 0.0;
};