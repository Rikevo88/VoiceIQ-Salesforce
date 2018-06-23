@isTest
public class LoginResponseTest
{

    @isTest static void testLoginCallout()
    {
        String loginResponseStr ='{"data": {"user": {"id": "string","displayName": "string","firstName": "string","lastName": "string","email": "string","mobilePhone": "string","username": "string","callQueueId": "string","organisationDetails": {"id": "string","name": "string","tenantCode": "string"},"authInfo": {"salesforceUserId": "string","salesforceUserUri": "string","instanceUrl": "string","accessToken": "string","refreshToken": "string","apiVersion": "string"},"preferences": {"callReminderSettings": {"minutesBeforeCall": 0}},"createdDate": "2018-03-08T11:06:57.276Z","lastModifiedDate": "2018-03-08T11:06:57.276Z","type": "string"},"token": "string","expiryTime": "string"},"httpStatusCode": "string","errors": [{"errorCode": "string","title": "string","details": "string"}],"isError": true}';
        SingleRequestMock fakeResponse = new SingleRequestMock(
            200,
            'Complete',
            '{"data": {"user": {"id": "string","displayName": "string","firstName": "string","lastName": "string","email": "string","mobilePhone": "string","username": "string","callQueueId": "string","organisationDetails": {"id": "string","name": "string","tenantCode": "string"},"authInfo": {"salesforceUserId": "string","salesforceUserUri": "string","instanceUrl": "string","accessToken": "string","refreshToken": "string","apiVersion": "string"},"preferences": {"callReminderSettings": {"minutesBeforeCall": 0}},"createdDate": "2018-03-08T11:06:57.276Z","lastModifiedDate": "2018-03-08T11:06:57.276Z","type": "string"},"token": "string","expiryTime": "string"},"httpStatusCode": "string","errors": [{"errorCode": "string","title": "string","details": "string"}],"isError": true}',
            null
        );
        Test.setMock(HttpCalloutMock.class, fakeResponse);

        // replace with actual login request callout
        LoginResponse res = (LoginResponse)JSON.deserialize(loginResponseStr, LoginResponse.class);

        system.assertEquals(res.data.user.id, 'string');
    }

}