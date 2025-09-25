// Copyright (c) 2025 WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
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
import ballerina/sql;

configurable int resultLimit = 100;

# Query to retrieve distinct micro app IDs allowed for the given user groups.
#
# + groups - An array of user groups used to filter allowed micro apps
# + return - sql:ParameterizedQuery to retrieve the list of allowed micro app IDs
isolated function getMicroAppIdsByGroupsQuery(string[] groups) returns sql:ParameterizedQuery => sql:queryConcat(`
    SELECT DISTINCT
        micro_app_id as appId
    FROM
        micro_app_role
    WHERE
        active = 1
    AND role IN (`, sql:arrayFlattenQuery(groups), `)
`);

# Query to get all MicroApps allowed for given groups.
#
# + appIds - MicroApp Ids
# + return - Generated Query to get all MicroApps
isolated function getMicroAppsByAppIdsQuery(string[] appIds) returns sql:ParameterizedQuery => sql:queryConcat(`
    SELECT
        name,
        description,
        promo_text,
        micro_app_id,
        icon_url,
        banner_image_url,
        mandatory
    FROM
        micro_app 
    WHERE
        active = 1
    AND 
        micro_app_id IN (`, sql:arrayFlattenQuery(appIds), `)
`);

# Query to get MicroApp versions by appId.
#
# + appId - MicroApp Id
# + return - Generated Query to get MicroApp versions
isolated function getAllMicroAppVersionsQuery(string appId) returns sql:ParameterizedQuery => `
    SELECT
        version,
        build,
        release_notes,
        icon_url,
        download_url
    FROM
        micro_app_version
    WHERE
        micro_app_id = ${appId}
    AND
        active = 1
    ORDER BY
        build DESC
`;

# Query to get MicroApp by appId.
#
# + appId - MicroApp Id
# + return - Generated Query to get MicroApp by appId
isolated function getMicroAppByAppIdQuery(string appId) returns sql:ParameterizedQuery => `
    SELECT
        name,
        description,
        promo_text,
        micro_app_id,
        icon_url,
        banner_image_url,
        mandatory
    FROM
        micro_app 
    WHERE
        micro_app_id = ${appId}
    AND
        active = 1
`;

# Query to get Super App versions by platform
#
# + platform - Platform (ios or android)
# + return - Generated Query to get Super App versions
isolated function getVersionsByPlatformQuery(string platform) returns sql:ParameterizedQuery => `
    SELECT
        version,
        build,
        platform,
        release_notes,
        download_url
    FROM
        superapp_version
    WHERE
        platform = ${platform}
    AND
        active = 1
    ORDER BY
        build DESC
`;

# Query to get app configurations by email
#
# + email - User email
# + return - Generated Query to get app configurations by email
isolated function getAppConfigsByEmailQuery(string email) returns sql:ParameterizedQuery => `
    SELECT
        email,
        config_key,
        config_value,
        active
    FROM
        user_config
    WHERE
        email = ${email}
    AND
        active = 1
`;

# Query update configurations by email
#
# + email - User email
# + configKey - Configuration key
# + configValue - Configuration value
# + isActive - status 1 or 0
# + return - Generated Query to insert/update configurations
isolated function updateAppConfigsByEmailQuery(string email, string configKey, string configValue, int isActive)
    returns sql:ParameterizedQuery => `
        INSERT INTO user_config (
            email,
            config_key,
            config_value,
            created_by,
            updated_by,
            active
        )
        VALUES (
            ${email},
            ${configKey},
            ${configValue},
            ${email},
            ${email},
            ${isActive}
        )
        ON DUPLICATE KEY UPDATE
            updated_by = ${email},
            config_value = ${configValue},
            active = ${isActive}
`;

# Query to get FCM tokens for a given email.
#
# + emails - Array of user emails to retrieve tokens for
# + startIndex - Start index for pagination
# + return - Generated query to get FCM tokens from the device_tokens table
public isolated function getFcmTokensQuery(string[] emails, int startIndex) returns sql:ParameterizedQuery =>
    sql:queryConcat(`
        SELECT 
            dt.fcm_token
        FROM 
            device_tokens dt
        INNER JOIN 
            user_config uc ON dt.user_id = uc.id
        WHERE
            uc.email IN (`, sql:arrayFlattenQuery(emails), `) LIMIT ${resultLimit} OFFSET ${startIndex}
    `);

# Query to count FCM tokens for a given list of emails.
#
# + emails - Array of user emails to count tokens for
# + return - Generated query to count FCM tokens from the device_tokens table
public isolated function countFcmTokensQuery(string[] emails) returns sql:ParameterizedQuery =>
    sql:queryConcat(`
        SELECT 
            COUNT(*) as count
        FROM 
            device_tokens dt
        INNER JOIN 
            user_config uc ON dt.user_id = uc.id
        WHERE
            uc.email IN (`, sql:arrayFlattenQuery(emails), `) 
    `);

# Query to insert an FCM token.
#
# + email - The user email used to fetch the corresponding `user_id` from `user_config`
# + fcmToken - The FCM token to be inserted
# + return - Generated query to insert the FCM token into `device_tokens`
public isolated function addFcmTokenQuery(string email, string fcmToken) returns sql:ParameterizedQuery =>
    `INSERT INTO device_tokens (user_id, fcm_token, created_at)
     VALUES (
        (SELECT id FROM user_config WHERE email = ${email}),
        ${fcmToken},
        CURRENT_TIMESTAMP
     )`;

# Query to delete an FCM token.
#
# + fcmToken - The FCM token to be deleted
# + return - Generated query to remove the matching FCM token from the `device_tokens` table
public isolated function deleteFcmTokenQuery(string fcmToken) returns sql:ParameterizedQuery =>
    `DELETE FROM device_tokens WHERE fcm_token = ${fcmToken}`;

# Query to retrieve an application configuration by key.
#
# + ConfigKey - The configuration key used to look up the value.
# + return - A Query that selects the `Value` and `Type`fields from the `appconfig` table for the given `ConfigKey`.
public isolated function getAppConfigsQuery(string ConfigKey) returns sql:ParameterizedQuery => `
    SELECT Value, Type
    FROM appconfig
    WHERE ConfigKey = ${ConfigKey}
`;
