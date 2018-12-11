@isTest
private class CallQueueResponseTest
{

	@isTest static void testCallQueueResponseCallout()
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
		CallQueueResponse res = Connector.addContactToCallQueue('test','test');
		Test.stopTest();
		System.assertEquals(res.data.id, 'string');
	}


}