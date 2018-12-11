@isTest
private class ClientResponseTest
{

	@isTest static void testClientResponseCallout()
	{
		String clientResponseStr = '{"data": {"id": "string","tenantCode": "string","name": "string","description": "string","remoteId": "string"},"httpStatusCode": "string","errors": [{"errorCode": "string","title": "string","details": "string"}],"isError": true}';
		SingleRequestMock fakeResponse = new SingleRequestMock(
			200,
			'Complete',
			clientResponseStr,
			new Map<String,String>{ 'testheader' => 'test' }
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		ClientResponse res = Connector.authenticate();
		Test.stopTest();
		System.assertEquals(res.data.id, 'string');
	}

	@isTest static void testClientResponseCalloutFail()
	{
		String clientResponseStr = '{"isError": true,"errors": [{"errorCode": "string","title": "string","details": "string"}],"data": {"user": {"id": "string","displayName": "string","firstName": "string","lastName": "string","email": "string","mobilePhone": "string","username": "string","callQueueId": "string","photoUrl": "string","documentTrayInfo": {"remoteId": "string","serviceName": "string"},"organisationDetails": {"id": "string","name": "string","tenantCode": "string"},"authInfo": {"salesforceUserId": "string","salesforceUserUri": "string","instanceUrl": "string","accessToken": "string","refreshToken": "string","apiVersion": "string"},"preferences": {"callReminderSettings": {"minutesBeforeCall": 0}},"createdDate": "2018-12-10T22:33:22.640Z","lastModifiedDate": "2018-12-10T22:33:22.640Z","type": "string"}},"httpStatusCode": "string"}';
		SingleRequestMock fakeResponse = new SingleRequestMock(
			200,
			'Complete',
			clientResponseStr,
			new Map<String,String>{ 'testheader' => 'test' }
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);
		Test.startTest();
		ClientResponse res = Connector.authenticate();
		Test.stopTest();
		System.assertEquals(res.isError, true);
		res.debugErrors();
		List<String> errors = res.getErrors();
	}

}