global class Connector
{

	private final static String VOICEIQ_URL;
	private final static String VOICEIQ_AUTH_URL;
	private final static String CLIENT_ID;
	private final static String CLIENT_SECRET;
	private final static String GRANT_TYPE;

	static 
	{
		Settings__mdt setting = [select Client_Id__c, Client_Secret__c, Grant_Type__c, VoiceIQ_App__c, VoiceIQ_Auth__c from Settings__mdt where DeveloperName = 'Default'];
		VOICEIQ_URL = setting.VoiceIQ_App__c;
		VOICEIQ_AUTH_URL = setting.VoiceIQ_Auth__c;
		CLIENT_ID = setting.Client_Id__c;
		CLIENT_SECRET = setting.Client_Secret__c;
		GRANT_TYPE = setting.Grant_Type__c;
	}

	private class ConnectorException extends Exception {}

	private static ClientResponse clientResponse;

	global class VoiceIQRequest
	{
		public String endpoint;
		public String body;
		public String method;
		public Map<String,String> headers = new Map<String,String>();
	}

	public class RemoteContacts
	{
		public List<CallQueueBody> remoteContacts;
	}

	public class CallQueueBody
	{
		public String remoteContactId;
		public Integer scheduleType;
		public String callTime;
		public String callTimeEnd;
		public CallQueueBody(String remoteContactId, Integer scheduleType)
		{
			this.remoteContactId = remoteContactId;
			this.scheduleType = scheduleType;
		}
	}

	global static HttpResponse sendAuthRequest(VoiceIQRequest request)
	{
		System.debug(request);
		// Instantiate a new http object
		Http h = new Http();

		// Instantiate a new HTTP request, specify the method as well as the endpoint
		HttpRequest req = new HttpRequest();
		String requestURL = VOICEIQ_AUTH_URL + request.endpoint;
		req.setEndpoint(requestURL);
		req.setMethod(request.method);
		req.setBody(request.body);
		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

		// Send the request, and return a response
		HttpResponse res = h.send(req);
		System.debug(res);
		return res;
	}

	global static HttpResponse sendRequest(VoiceIQRequest request)
	{
		System.debug(request);
		// Instantiate a new http object
		Http h = new Http();

		// Instantiate a new HTTP request, specify the method as well as the endpoint
		HttpRequest req = new HttpRequest();
		String requestURL = VOICEIQ_URL + request.endpoint;
		req.setEndpoint(requestURL);
		req.setMethod(request.method);
		// only set the body if it's not blank
		if(String.isBlank(request.Body) == false) req.setBody(request.body);
		req.setHeader('Content-Type', 'application/json');
		for(String header : request.headers.keySet())
		{
			req.setHeader(header, request.headers.get(header));
		}
		System.debug(req);

		// Send the request, and return a response
		HttpResponse res = h.send(req);
		System.debug(res);
		return res;
	}

	global static ClientResponse authenticate()
	{
		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint =  '/connect/token';
		request.method = 'POST';
		request.body = String.format('client_id={0}&client_secret={1}&grant_type={2}', new List<String>
		{
			CLIENT_ID,
			CLIENT_SECRET,
			GRANT_TYPE
		});
		HttpResponse res = sendAuthRequest(request);
		String responseStr = res.getBody();
		LoginResponse response = (LoginResponse)handleJSONDeserialize('LoginResponse', responseStr);
		return getClient(response);
	}

	global static ClientResponse getClient(LoginResponse loginResponse)
	{
		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint = String.format('/external/api/v1/client/{0}', new List<String>
		{
			UserInfo.getOrganizationId()
		});
		request.method = 'GET';
		request.headers = new Map<String,String>
		{
			'Authorization' => 'Bearer ' + loginResponse.access_token
		};
		HttpResponse res = sendRequest(request);
		String responseStr = res.getBody();
		clientResponse = (ClientResponse)handleJSONDeserialize('ClientResponse', responseStr);
		clientResponse.setLoginResponse(loginResponse);
		System.debug(clientResponse);
		return clientResponse;
	}

	/**
	 *	@description 		Sends a contact id to VoiceIQ and adds them to the user's call queue 
	 *						as an Unscheduled call.
	 *	@param 				String salesforceUserId	The id of the user whos call queue will recieve the contact.
	 *	@param 				String salesforceContactId A contact id to add to the user's call queue.
	 */
	global static CallQueueResponse addContactToCallQueue(String salesforceUserId, String salesforceContactId)
	{
		CallQueueBody payload = new CallQueueBody(salesforceContactId, 1);

		// authenticate with VoiceIQ
		ClientResponse response = clientResponse == null ? Connector.authenticate() : clientResponse;

		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint = String.format('/external/api/v1/user/{0}/callqueue/contact', new List<String>
		{
			salesforceUserId
		});
		request.method = 'POST';
		request.body = JSON.serialize(payload);
		request.headers = setAuthenticationHeaders(response);
		
		HttpResponse res = sendRequest(request);
		String responseStr = res.getBody();
		return (CallQueueResponse)handleJSONDeserialize('CallQueueResponse', responseStr);
	}

	/**
	 *	@description 		Sends a list of contact ids to VoiceIQ and adds them to the user's call queue 
	 *						as Unscheduled calls.
	 *
	 *	@param 				String salesforceUserId	The id of the user whos call queue will recieve the contacts.
	 *	@param 				List<String> salesforceContactIds List of contact ids to add to the user's call queue.
	 */
	global static CallQueueResponse addContactsToCallQueue(String salesforceUserId, Set<String> salesforceContactIds)
	{
		if(salesforceContactIds == null || salesforceContactIds.isEmpty() == true) throw new ConnectorException('No salesforce contact ids were supplied.');

		
		List<CallQueueBody> payload = new List<CallQueueBody>();
		for(String contactId : salesforceContactIds)
		{
			payload.add(new CallQueueBody(contactId, 1));
		}
		RemoteContacts remoteContacts = new RemoteContacts();
		remoteContacts.remoteContacts = payload;
		System.debug(JSON.serialize(remoteContacts));

		// authenticate with VoiceIQ
		ClientResponse response = clientResponse == null ? Connector.authenticate() : clientResponse;

		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint = String.format('/external/api/v1/user/{0}/callqueue/contacts', new List<String>
		{
			salesforceUserId
		});
		request.method = 'POST';
		request.body = JSON.serialize(remoteContacts);
		request.headers = setAuthenticationHeaders(response);

		HttpResponse res = sendRequest(request);
		String responseStr = res.getBody();
		return (CallQueueResponse)handleJSONDeserialize('CallQueueResponse', responseStr);
	}

	global static UserResponse getUser()
	{		
		// authenticate with VoiceIQ
		ClientResponse response = Connector.authenticate();

		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint = String.format('/api/v1/user/{0}', new List<String>
		{
			'63ceb516-b1d6-404c-8047-097e0610f0d2'
		});
		request.method = 'GET';
		request.headers = setAuthenticationHeaders(response);

		HttpResponse res = sendRequest(request);
		String responseStr = res.getBody();
		return (UserResponse)JSON.deserialize(responseStr, UserResponse.class);
	}

	/**
	 * 	@description 		Sets the authentication headers required to communicate with VoiceIQ
	 *
	 *	@param 				ClientResponse response The authentication response class which holds the 
	 *												access_token and tenantCode
	 */
	private static Map<String,String> setAuthenticationHeaders(ClientResponse response)
	{
		return new Map<String,String>
		{
			'Authorization' => 'Bearer ' + response.loginResponse.access_token,
			'X-TENANT-CODE' => response.data.tenantCode
		};
	}

	/**
	 * 	@description 		Dynamically deserializes the json response into the specified class name and
	 *						handles any exceptions.
	 *
	 *	@param 				String className the name of the class to type cast.
	 * 	@param 				String responseStr the json to deserialize.
	 */
	private static Object handleJSONDeserialize(String className, String responseStr)
	{
		try
		{
			// when we upgrade to name space, use Type.forName(namespace, class);
			return JSON.deserialize(responseStr, Type.forName(className));
		}
		catch(JSONException ex)
		{
			System.debug(ex);
			throw new ConnectorException(ex.getMessage() + ': deserializing ' + className + ': response ' + responseStr);
		}	
	}

}