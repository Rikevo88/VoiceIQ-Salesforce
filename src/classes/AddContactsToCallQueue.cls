global class AddContactsToCallQueue
{

	private class AddContactsToCallQueueException extends Exception {}
	
	@InvocableMethod(label='Add Contacts to Call Queue' description='Posts a list of salesforce contacts to the VoiceIQ CallQueue API')
	global static List<String> send (List<UserIdWithContacts> userIdsWithContacts)
	{
		List<String> responses = new List<String>();

		for(UserIdWithContacts userIdWithContacts : userIdsWithContacts)
		{
			String userId = userIdWithContacts.userId;
			
			Set<String> contactIds = new Set<String>();
			for(Contact contact : userIdWithContacts.contacts)
			{
				contactIds.add(contact.Id);
			}
			
			CallQueueResponse callQueueResponse = Connector.addContactsToCallQueue(userId, contactIds);
			responses.add(String.join(callQueueResponse.getErrors(), '\n'));
		}
		
		return responses;
	}

	global class UserIdWithContacts
	{
		@InvocableVariable(label='User Id' description='The Id of the User to add Contacts to their call queue.' required=true)
		global String userId;

		@InvocableVariable(label='Contacts' description='Contact records to add the User\'s call queue.' required=true)
		global List<Contact> contacts;
	}
}