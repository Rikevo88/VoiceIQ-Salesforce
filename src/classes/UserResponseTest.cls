@isTest
private class UserResponseTest
{

	@isTest static void test_method_one()
	{
		String userResponseStr = '{"data": {"id": "string","displayName": "string","firstName": "string","lastName": "string","email": "string","mobilePhone": "string","username": "string","callQueueId": "string","photoUrl": "string","documentTrayInfo": {"remoteId": "string","serviceName": "string"},"organisationDetails": {"id": "string","name": "string","tenantCode": "string"},"authInfo": {"salesforceUserId": "string","salesforceUserUri": "string","instanceUrl": "string","accessToken": "string","refreshToken": "string","apiVersion": "string"},"preferences": {"callReminderSettings": {"minutesBeforeCall": 0}},"createdDate": "2018-12-10T22:33:23.324Z","lastModifiedDate": "2018-12-10T22:33:23.324Z","type": "string"},"httpStatusCode": "string","errors": [{"errorCode": "string","title": "string","details": "string"}],"isError": true}';
		SingleRequestMock fakeResponse = new SingleRequestMock(
		    200,
		    'Complete',
		    userResponseStr,
		    new Map<String,String>{ 'testheader' => 'test' }
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		Test.startTest();
		UserResponse res = Connector.getUser();
		Test.stopTest();
		System.assertEquals(res.data.id, 'string');
	}

}