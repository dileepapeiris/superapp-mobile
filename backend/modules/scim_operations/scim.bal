// Copyright (c) 2025, WSO2 LLC. (https://www.wso2.com). All Rights Reserved.
//
// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein in any form is strictly forbidden, unless permitted by WSO2 expressly.
// You may not alter or remove any copyright or other notice from copies of this content.
import ballerina/io;

# Get emails from a group.
#
# + groupFilter - Filter to search for the group (e.g., "app-superapp-developer")
# + organization - The organization name to search groups in (defaults to "wso2")
# + return - Returns an array of email strings or an error if operation fails.
public isolated function getGroupMemberEmails(string groupFilter, string organization) returns string[]|error {
    GroupSearchResponse groupResponse = check searchGroups(groupFilter, organization);

    if groupResponse.totalResults <= 0 || groupResponse.Resources.length() <= 0 {
        return [];
    }

    GroupResource groupResource = groupResponse.Resources[0];

    // if groupResource.members is [] {
    //     return [];
    // }

    GroupMember[] members = <GroupMember[]>groupResource.members;
    string[] emails = [];

    from GroupMember member in members
    where member.display is string
    let string displayName = <string>member.display
    let string[] parts = re `${STORE_NAME}`.split(displayName)
    do {
        if parts.length() > 1 {
            emails.push(parts[1]);
        } else {
            emails.push(displayName);
        }
    };
    io:print(emails);

    return emails;
}

# Search for groups in the organization.
#
# + filter - The filter string to search groups (e.g., "app-superapp-developer")
# + organization - The organization name to search groups in (defaults to "wso2")
# + return - Returns a GroupSearchResponse on success or an error on failure.
public isolated function searchGroups(string filter, string organization) returns GroupSearchResponse|error {

    return {
        totalResults: 1,
        startIndex: 1,
        itemsPerPage: 1,
        schemas: [
            "urn:ietf:params:scim:api:messages:2.0:ListResponse"
        ],
        Resources: [
            {
                id: "873f2718-af10-4fcb-b21b-23e7d9334f32",
                displayName: "DEFAULT/app-superapp-developer",
                meta: {
                    created: "2025-05-02T04:40:57.647Z",
                    location: "https://api.asgardeo.io/t/wso2/scim2/Groups/873f2718-af10-4fcb-b21b-23e7d9334f32",
                    lastModified: "2025-05-02T04:40:57.647Z"
                },
                members: [
                    {
                        display: "DEFAULT/shayan@wso2.com",
                        value: "833aaf82-cd64-4683-8ce6-3c546e53d055",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/833aaf82-cd64-4683-8ce6-3c546e53d055"
                    },
                    {
                        display: "DEFAULT/rashmika@wso2.com",
                        value: "485ebaad-fcf7-4c73-b468-94f47a9a0468",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/485ebaad-fcf7-4c73-b468-94f47a9a0468"
                    },
                    {
                        display: "DEFAULT/suhanr@wso2.com",
                        value: "fd234f92-4266-4a04-876b-1a6d62968a55",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/fd234f92-4266-4a04-876b-1a6d62968a55"
                    },
                    {
                        display: "DEFAULT/chamodk@wso2.com",
                        value: "da4c2ef4-ea76-41cf-ba0f-4e16bcff29e0",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/da4c2ef4-ea76-41cf-ba0f-4e16bcff29e0"
                    },
                    {
                        display: "DEFAULT/dileepap@wso2.com",
                        value: "19fbb395-5698-4197-80d7-5ae514c0f4ec",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/19fbb395-5698-4197-80d7-5ae514c0f4ec"
                    },
                    {
                        display: "DEFAULT/visalr@wso2.com",
                        value: "fe77c91a-37ba-4a24-86a6-a7c0adde06c1",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/fe77c91a-37ba-4a24-86a6-a7c0adde06c1"
                    },
                    {
                        display: "DEFAULT/chanuka@wso2.com",
                        value: "c38e545c-c66a-4024-9ae6-b175c9487559",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/c38e545c-c66a-4024-9ae6-b175c9487559"
                    },
                    {
                        display: "DEFAULT/sachinr@wso2.com",
                        value: "d7d8f3d7-4ab5-4720-be5a-994b9b800f40",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/d7d8f3d7-4ab5-4720-be5a-994b9b800f40"
                    },
                    {
                        display: "DEFAULT/lithika@wso2.com",
                        value: "97ad7f1c-ddd0-43e3-8481-fda0a30537f0",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/97ad7f1c-ddd0-43e3-8481-fda0a30537f0"
                    },
                    {
                        display: "DEFAULT/anuradhab@wso2.com",
                        value: "543d80a5-cd73-4f16-a718-2ccc9983274e",
                        \$ref: "https://api.asgardeo.io/t/wso2/scim2/Users/543d80a5-cd73-4f16-a718-2ccc9983274e"
                    }
                ]
            }
        ]
    };

}
