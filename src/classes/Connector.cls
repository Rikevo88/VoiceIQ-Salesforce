global class Connector
{

	private static String VOICEIQ_URL = 'https://enviqdv01apiapp.azurewebsites.net';
	private static String VOICEIQ_AUTH_URL = 'https://enviqdv01authapp.azurewebsites.net';

	private class ConnectorException extends Exception {}

	global class VoiceIQRequest
	{
		public String endpoint;
		public String body;
		public String method;
		public Map<String,String> headers = new Map<String,String>();
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
		for(String header : request.headers.keySet())
		{
			req.setHeader(header, request.headers.get(header));
		}

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
		req.setBody(request.body);
		req.setHeader('Content-Type', 'application/json');
		for(String header : request.headers.keySet())
		{
			req.setHeader(header, request.headers.get(header));
		}

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
		request.body = 'client_id=viqapex&client_secret=fd7ceb9c-f380-4c39-b340-83821747eb12&grant_type=client_credentials';
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
		request.body = '';
		request.headers = new Map<String,String>
		{
			'Authorization' => 'Bearer ' + loginResponse.access_token
		};
		HttpResponse res = sendRequest(request);
		String responseStr = res.getBody();
		ClientResponse response = (ClientResponse)handleJSONDeserialize('ClientResponse', responseStr);
		return response;
	}

	global static UserResponse getUser(String authToken, String tenantCode)
	{
		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint = String.format('/api/v1/user/{0}', new List<String>
		{
			'63ceb516-b1d6-404c-8047-097e0610f0d2'
		});
		request.method = 'GET';
		request.body = '';
		request.headers = new Map<String,String>
		{
			'Authorization' => 'Bearer ' + authToken,
			'X-Tenant-Code' => tenantCode
		};
		HttpResponse res = sendRequest(request);

		String responseStr = res.getBody();
		system.debug(responseStr);
		return (UserResponse)JSON.deserialize(responseStr, UserResponse.class);
	}

	global static CallQueueResponse addContactToCallQueue(String voiceIQUserId, String callQueueId, String authToken, String tenantCode, String salesforceContactId)
	{
		CallQueueBody callQueueBody = new CallQueueBody();
		callQueueBody.contactId = salesforceContactId;
		callQueueBody.scheduleType = 'UnScheduled';

		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint = String.format('/external/api/v1/user/{0}/callqueue/{1}', new List<String>
		{
			voiceIQUserId,
			callQueueId
		});
		request.method = 'POST';
		request.body = JSON.serialize(callQueueBody);
		request.headers = new Map<String,String>
		{
			'Authorization' => 'Bearer ' + authToken,
			'X-TENANT-CODE' => tenantCode
		};
		HttpResponse res = sendRequest(request);

		String responseStr = res.getBody();
		return (CallQueueResponse)JSON.deserialize(responseStr, CallQueueResponse.class);
	}

	public class CallQueueBody
	{
		public String contactId;
		public String scheduleType;
		public String callTime;
		public String callTimeEnd;
	}

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
