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

documentation {
    FacebookConfiguration is used to set up the Facebook configuration. In order to use this connector, you need
    to provide the valid access token.
    F{{clientConfig}} - The HTTP client congiguration
}
public type FacebookConfiguration record {
    http:ClientEndpointConfig clientConfig = {};
};

documentation {
    Facebook Endpoint object.
    E{{}}
    F{{facebookConfig}} - Facebook client endpoint configuration object
    F{{facebookConnector}} - Facebook connector object
}
public type Client object {

    public FacebookConfiguration facebookConfig = {};
    public FacebookConnector facebookConnector = new;

    documentation {
        Facebook endpoint initialization function
        P{{config}} - Facebook client endpoint configuration object
    }
    public function init(FacebookConfiguration config);

    documentation {
        Get Facebook connector client
        R{{}} - Facebook connector client
    }
    public function getCallerActions() returns FacebookConnector;
};

documentation {
    Facebook client connector
    F{{httpClient}} - The HTTP Client
}
public type FacebookConnector object {

    public http:Client httpClient = new;

    documentation {
        Create a new post
        P{{id}} - The identifier
        P{{msg}} - The main body of the post
        P{{link}} - The URL of a link to attach to the post
        P{{place}} - Page ID of a location associated with this post
        R{{}} - Post object on success and FacebookError on failure
    }
    public function createPost(string id, string msg, string link, string place) returns Post|FacebookError;

    documentation {
        Retrieve a post
        P{{postId}} - The post ID
        R{{}} - Post object on success and FacebookError on failure
    }
    public function retrievePost(string postId) returns Post|FacebookError;

    documentation {
        Delete a post
        P{{postId}} - The post ID
        R{{}} - True on success and FacebookError on failure
    }
    public function deletePost(string postId) returns (boolean)|FacebookError;

    documentation {
        Get the User's friends who have installed the app making the query
        Get the User's total number of friends (including those who have not installed the app making the query)
        P{{userId}} - The user ID
        R{{}} - FriendList object on success and FacebookError on failure
    }
    public function getFriendListDetails(string userId) returns FriendList|FacebookError;

    documentation {
        Get a list of all the Pages managed by that User, as well as a Page access tokens for each Page
        P{{userId}} - The user ID
        R{{}} - AccessTokens object on success and FacebookError on failure
    }
    public function getPageAccessTokens(string userId) returns AccessTokens|FacebookError;

    documentation {
        Retrieve details of the event
        P{{eventId}} - The event ID
        R{{}} - `Event` object on success or `FacebookError` on failure
    }
    public function retrieveEventDetails(string eventId) returns Event|FacebookError;
};

documentation {
    Facebook error.
    F{{message}} - Error message.
    F{{cause}} - The error which caused the Facebook error.
    F{{statusCode}} - The status code.
}
public type FacebookError record {
    string message;
    error? cause;
    int statusCode;
};

documentation {
    Post object.
    F{{id}} - The post ID.
    F{{message}} - The status message in the post.
    F{{createdTime}} - The time the post was initially published.
    F{{updatedTime}} - The time when the Post was created, edited, or commented upon.
    F{{postType}} - A string indicating the object type of this post (link, status, photo, video, offer).
    F{{fromObject}} - Information (name and id) about the Profile that created the Post.
    F{{isPublished}} - Indicates whether a scheduled post was published (applies to scheduled Page Post
    only, for users post and instantly published posts this value is always true). Note that this value is
    always false
}
public type Post record {
    string id;
    string message;
    string createdTime;
    string updatedTime;
    string postType;
    Profile fromObject;
    boolean isPublished;
};

documentation {
    The profile object is used within the Graph API to refer to the generic type that includes all of these
     (User/Page/Group)other objects.
     F{{id}} - The object ID.
     F{{name}} - The object name.
}
public type Profile record {
    string id;
    string name;
};

documentation {
    Friend list object.
    F{{data}} - A list of User nodes.
    F{{summary}} - Aggregated information about the edge, such as counts.
}
public type FriendList record {
    Data[] data;
    Summary summary;
};

documentation {
    A user node.
    F{{id}} - The user ID.
    F{{name}} - The user name.
}
public type Data record {
    string id;
    string name;
};

documentation {
    A Summary object.
    F{{totalCount}} - Total number of objects on this edge.
}
public type Summary record {
    string totalCount;
};

documentation {
    Contains page accesstoken object.
    F{{data}} - AccessTokenData objects.
}
public type AccessTokens record {
    AccessTokenData[] data;
};

documentation {
    Contains page accesstoken details.
    F{{category}} - Product category.
    F{{pageName}} - Page name.
    F{{pageAccessToken}} - Page accessToken.
    F{{pageId}} - A page id.
}
public type AccessTokenData record {
    string category;
    string pageName;
    string pageAccessToken;
    string pageId;
};

documentation {
    Event object.
    F{{id}} - The event ID.
    F{{attending_count}} - The number of people attending.
    F{{can_guests_invite}} - Whether guests can invite others.
    F{{category}} - The category the event belongs to.
    F{{declined_count}} - The number of people attending.
    F{{description}} - Description of the event.
    F{{discount_code_enabled}} - Whether a discount code is enabled for the event.
    F{{end_time}} - The end time if set.
    F{{guest_list_enabled}} - Whether the guest list can be seen.
    F{{interested_count}} - Number of people interested in the event.
    F{{is_canceled}} - Whether the event is marked cancelled.
    F{{is_draft}} - Whether the event is drafted or published.
    F{{is_page_owned}} - Whether the event was created by a page.
    F{{maybe_count}} - Number of people who have marked attendance as maybe.
    F{{name}} - The name of the event.
    F{{noreply_count}} - The number of people who did not reply to the invitation.
    F{{scheduled_publish_time}} - The time the event is scheduled to be published.
    F{{start_time}} - The time the event is scheduled to start.
    F{{ticket_uri}} - The link to buy tickets at for the event.
    F{{ticket_uri_start_sales_time}} - The time at which tickets will go on sale.
    F{{ticketing_privacy_uri}} - The link to the privacy policies of the ticket seller.
    F{{ticketing_terms_uri}} - The link to the terms of service of the ticket seller.
    F{{timezone}} - The timezone of the event.
    F{{^"type"}} - The type of the event.
}
public type Event record {
    string id;
    int? attending_count;
    boolean? can_guests_invite;
    string? category;
    int? declined_count;
    string? description;
    boolean? discount_code_enabled;
    string? end_time;
    boolean? guest_list_enabled;
    int? interested_count;
    boolean? is_canceled;
    boolean? is_draft;
    boolean? is_page_owned;
    int? maybe_count;
    string name;
    int? noreply_count;
    Place? place;
    string? scheduled_publish_time;
    string start_time;
    string? ticket_uri;
    string? ticket_uri_start_sales_time;
    string? ticketing_privacy_uri;
    string? ticketing_terms_uri;
    string? timezone;
    string? ^"type";
    // TODO Add missing fields
};

documentation {
    Contains Place details.
    F{{id}} - The identifier for the place.
    F{{name}} - The name of the place.
    F{{overall_rating}} - The overall rating of the place.
}
public type Place record {
    string? id;
    //todo" Add Location field
    string name;
    float? overall_rating;
};