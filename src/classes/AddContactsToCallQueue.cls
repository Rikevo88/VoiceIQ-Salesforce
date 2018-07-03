global class AddContactsToCallQueue
{
	
	@InvocableMethod(label='Add Contacts to Call Queue' description='Posts a list of salesforce contacts to the VoiceIQ CallQueue API')
	global static List<Response.Error> send (List<UserIdWithContacts> userIdsWithContacts)
	{
		String userId;
		Set<String> contactIds = new Set<String>();
		for(UserIdWithContacts userIdWithContacts : userIdsWithContacts)
		{			
			for(Contact contact : userIdWithContacts.contacts)
			{
				contactIds.add(contact.Id);
			}
			userId = userIdWithContacts.userId;
		}
		CallQueueResponse res = Connector.addContactsToCallQueue(userId, contactIds);
		return res.errors;
	}

	global class UserIdWithContacts
	{
		@InvocableVariable global String userId;
		@InvocableVariable global List<Contact> contacts;
	}
}