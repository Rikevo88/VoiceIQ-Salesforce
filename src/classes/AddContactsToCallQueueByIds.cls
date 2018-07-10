global class AddContactsToCallQueueByIds
{

	private class AddContactsToCallQueueByIdsException extends Exception {}

	private static String contactIdPrefix = Schema.Contact.SObjectType.getDescribe().getKeyPrefix();
	private static String leadIdPrefix = Schema.Lead.SObjectType.getDescribe().getKeyPrefix();

	@InvocableMethod(label='Add Contacts to Call Queue by Ids' description='Post a list of Leads and/or Contacts to the usuer&#39;s VoiceIQ call queue.')
	global static List<String> send (List<UserIdWithContactIds> userIdsWithContactIds)
	{
		List<String> responses = new List<String>();

		List<UserIdWithContactIds> requestInFuture = new List<UserIdWithContactIds>();

		for(UserIdWithContactIds userIdWithContactsIds : userIdsWithContactIds)
		{
			// validate Ids
			for(String contactId : userIdWithContactsIds.contactIds)
			{
				if(contactId == null)
				{
					throw new AddContactsToCallQueueByIdsException('Id can not be null.');
				} 
				// throw an exception if the id supplied is not a contact or a lead id
				else if(contactId.startsWith(contactIdPrefix) == false && contactId.startsWith(leadIdPrefix) == false)
				{
					throw new AddContactsToCallQueueByIdsException('Id is of invalid type: ' + contactId + '. Only Contact and Lead ids are supported.');
				}
			}
			String userId = userIdWithContactsIds.userId;
			Set<String> contactIds = new Set<String>(userIdWithContactsIds.contactIds);
			
			// if the invocable action has been specified to run in the future then add it to the list
			if(userIdWithContactsIds.inFuture == true)
			{
				requestInFuture.add(userIdWithContactsIds);
				// add blank entry so the processes get the correct responses
				responses.add('');
			}
			// process normally
			else
			{
				CallQueueResponse callQueueResponse = Connector.addContactsToCallQueue(userId, contactIds);
				responses.add(String.join(callQueueResponse.getErrors(), '\n'));
			}
		}

		// check if we have any requests to process in the future
		if(requestInFuture.isEmpty() == false)
		{
			sendInTheFuture(JSON.serialize(requestInFuture));
		}

		return responses;
	}

	@future(callout=true)
	private static void sendInTheFuture(String jsonStr)
	{
		List<UserIdWithContactIds> userIdsWithContactIds = (List<UserIdWithContactIds>)JSON.deserialize(jsonStr, List<UserIdWithContactIds>.class);

		for(UserIdWithContactIds userIdWithContactsIds : userIdsWithContactIds)
		{
			String userId = userIdWithContactsIds.userId;
			Set<String> contactIds = new Set<String>(userIdWithContactsIds.contactIds);
			CallQueueResponse callQueueResponse = Connector.addContactsToCallQueue(userId, contactIds);
			if(callQueueResponse.isError == true)
			{
				callQueueResponse.debugErrors();
			}
		}
	}

	global class UserIdWithContactIds
	{
		@InvocableVariable global String userId;
		@InvocableVariable global List<String> contactIds;
		@InvocableVariable global Boolean inFuture;
	}

}