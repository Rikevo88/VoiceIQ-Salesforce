global class AddContactToCallQueue implements Process.Plugin
{

	global Process.PluginResult invoke(Process.PluginRequest request)
	{
		// Get the organisationId and userId From Flow
		String organisationId = (String) request.inputParameters.get('organisationId');
		String userId = (String) request.inputParameters.get('userId');
		String contactId = (String) request.inputParameters.get('contactId');

		System.debug(organisationId);
		System.debug(userId);
		System.debug(contactId);

		// add contact to the user's call queue
		CallQueueResponse callQueue = Connector.addContactToCallQueue(userId, contactId);

		Map<String,Object> result = new Map<String,Object>();
		result.put('isError', callQueue.isError);
		String errorMessage = '';
		if(callQueue.errors != null && callQueue.errors.isEmpty() == false)
		{
			for(Response.Error error : callQueue.errors)
			{
				errorMessage += error.details + '\n';
			}
		}
		result.put('errorMessage', errorMessage);
		return new Process.PluginResult(result);
	}

	global Process.PluginDescribeResult describe()
	{
		Process.PluginDescribeResult result = new Process.PluginDescribeResult();
		result.Name = 'Add Contact To Call Queue';
		result.Tag = 'voiceiq';
		result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>
		{
			new Process.PluginDescribeResult.InputParameter('organisationId', Process.PluginDescribeResult.ParameterType.STRING, true),
			new Process.PluginDescribeResult.InputParameter('userId', Process.PluginDescribeResult.ParameterType.STRING, true),
			new Process.PluginDescribeResult.InputParameter('contactId', Process.PluginDescribeResult.ParameterType.STRING, true) 
		};
		result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
			new Process.PluginDescribeResult.OutputParameter('isError', Process.PluginDescribeResult.ParameterType.Boolean),
			new Process.PluginDescribeResult.OutputParameter('errorMessage', Process.PluginDescribeResult.ParameterType.String)
		};
		return result;
	}

}
