// Copyright (c) 2025, WSO2 LLC. (https://www.wso2.com). All Rights Reserved.
//
// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
// You may not alter or remove any copyright or other notice from copies of this content.

# Response record for the SCIM group search request
public type GroupSearchRequest record {|
    string filter;
|};

# Response record for the SCIM group search response
public type GroupSearchResponse record {|
    int totalResults;
    int startIndex;
    int itemsPerPage;
    string[] schemas;
    GroupResource[] Resources;
|};

# Record representing the group resource of group search record
public type GroupResource record {|
    string id;
    string displayName;
    GroupMember[] members;
    GroupMeta meta;
|};

# Record representing the group member of group resource record
public type GroupMember record {|
    string value;
    string display;
    string \$ref;
|};

# Record representing the meta record of group search record
public type GroupMeta record {|
    string created;
    string location;
    string lastModified;
|};
