@isTest
private class AddCampaignMembersToCallQueueTest 
{

	@testSetup static void setupData()
	{
		Campaign testCampaign = new Campaign(Name = 'Test Campaign');
		insert testCampaign;
		Lead testLead = new Lead(LastName = 'Test', Company = 'Test Company');
		insert testLead;
		CampaignMember testMember = new CampaignMember(CampaignId = testCampaign.Id, LeadId = testLead.Id);
		insert testMember;
	}

	@isTest static void testSendSuccess()
	{
		AddCampaignMembersToCallQueue.UserIdWithCampaignMembers item = new AddCampaignMembersToCallQueue.UserIdWithCampaignMembers();
		item.userId = '123456789';
		item.campaignMembers = [select LeadOrContactId from CampaignMember limit 1];

		String callQueueResponseStr = '{"data": {"id": "string","userId": "string","availabilityTimeSlots": [{"startTime": "string","endTime": "string"}],"timezone": "string","callQueueItems": [{"id": "string","contactDetails": {"id": "string","remoteId": "string","account": {"id": "string","name": "string"},"firstName": "string","lastName": "string","title": "string","email": "string","homePhone": "string","mobilePhone": "string","phone": "string","isDeleted": true,"ownerId": "string","photoUrl": "string","contactType": 0,"scheduledCalls": {"id": "string","contactId": "string","scheduleItems": [{"userId": "string","username": "string","scheduledSlots": {}}],"type": "string","createdDate": "2018-12-10T22:33:23.125Z","lastModifiedDate": "2018-12-10T22:33:23.125Z"},"createdDate": "2018-12-10T22:33:23.125Z","createdById": "string","lastModifiedDate": "2018-12-10T22:33:23.125Z","lastModifiedbyId": "string","type": "string"},"scheduleType": 0,"callTime": "2018-12-10T22:33:23.125Z","callTimeEnd": "2018-12-10T22:33:23.125Z"}],"createdDate": "2018-12-10T22:33:23.125Z","lastModifiedDate": "2018-12-10T22:33:23.125Z","type": "string"},"httpStatusCode": "string","errors": [{"errorCode": "string","title": "string","details": "string"}],"isError": true}';
		SingleRequestMock fakeResponse = new SingleRequestMock(
			200,
			'Complete',
			callQueueResponseStr,
			new Map<String,String>{ 'testheader' => 'test' }
		);
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		List<String> errors;
		Test.startTest();
		errors = AddCampaignMembersToCallQueue.send(new List<AddCampaignMembersToCallQueue.UserIdWithCampaignMembers> { item });
		Test.stopTest();
	}

}