@isTest
private class ClientResponseTest
{

	@isTest static void testClientResponseCallout()
	{
		String clientResponseStr = '{"data": {"id": "string","userId": "string","availabilityTimeSlots": ["string"],"timezone": "string","callQueueItems": [{"id": "string","contactDetails": {"id": "string","remoteId": "string","account": {"id": "string","name": "string"},"firstName": "string","lastName": "string","title": "string","email": "string","homePhone": "string","mobilePhone": "string","phone": "string","isDeleted": true,"ownerId": "string","photoUrl": "string","createdDate": "2018-07-03T14:16:29.960Z","createdById": "string","lastModifiedDate": "2018-07-03T14:16:29.960Z","lastModifiedbyId": "string","type": "string"},"scheduleType": 0,"callTime": "2018-07-03T14:16:29.960Z","callTimeEnd": "2018-07-03T14:16:29.960Z"}],"createdDate": "2018-07-03T14:16:29.960Z","lastModifiedDate": "2018-07-03T14:16:29.960Z","type": "string"},"httpStatusCode": "string","errors": [{"errorCode": "string","title": "string","details": "string"}],"isError": true}';
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
	
}