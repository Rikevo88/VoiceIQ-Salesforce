global class AddCampaignMembersToCallQueue
{

	private class AddCampaignMembersToCallQueueException extends Exception {}
	
	@InvocableMethod(label='Add Campaign Members to Call Queue' description='Posts a list of salesforce contacts and/or leads to the VoiceIQ CallQueue API.')
	global static List<String> send (List<UserIdWithCampaignMembers> userIdsWithContacts)
	{
		List<String> responses = new List<String>();

		for(UserIdWithCampaignMembers userIdWithCampaignMembers : userIdsWithContacts)
		{
			String userId = userIdWithCampaignMembers.userId;

			Set<String> contactAndLeadIds = new Set<String>();
			for(CampaignMember member : userIdWithCampaignMembers.campaignMembers)
			{
				contactAndLeadIds.add(member.LeadOrContactId);
			}

			CallQueueResponse callQueueResponse = Connector.addContactsToCallQueue(userId, contactAndLeadIds);
			responses.add(String.join(callQueueResponse.getErrors(), '\n'));
		}
		
		return responses;
	}

	global class UserIdWithCampaignMembers
	{
		@InvocableVariable(label='User Id' description='The Id of the User to add Campaign Members to their call queue.' required=true)
		global String userId;

		@InvocableVariable(label='Campaign Members' description='Campaign Member records to add the User\'s call queue.' required=true)
		global List<CampaignMember> campaignMembers;
	}
}