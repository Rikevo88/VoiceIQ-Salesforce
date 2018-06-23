global class Connector
{

	private static String VOICEIQ_URL = 'https://enviqst01apiapp.azurewebsites.net';
	private static String VOICEIQ_AUTH_URL = 'https://enviqdv01authapp.azurewebsites.net';

	global class VoiceIQRequest
	{
		public String endpoint;
		public String body;
		public String method;
		public Map<String,String> headers = new Map<String,String>();
	}

	global static HttpResponse sendRequest(VoiceIQRequest request)
	{
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
		return res;
	}

	global static HttpResponse sendAuthRequest(VoiceIQRequest request)
	{
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
		return res;
	}

	global static LoginResponse authenticate()
	{
		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint =  '/connect/token';
		request.method = 'POST';
		request.body = 'client_id=viqapex&client_secret=fd7ceb9c-f380-4c39-b340-83821747eb12&grant_type=client_credentials';
		HttpResponse res = sendAuthRequest(request);
		String responseStr = res.getBody();
		LoginResponse response = (LoginResponse)JSON.deserialize(responseStr, LoginResponse.class);
		system.debug(response);
		return response;
	}

	global static UserResponse getUser(String authToken, String tenantCode)
	{
		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint = String.format('/api/v1/user/{0}', new List<String>
		{
			'voiceiq'
		});
		request.method = 'GET';
		request.headers = new Map<String,String>
		{
			'Authorization' => 'Bearer ' + authToken,
			'X-TENANT-CODE' => tenantCode
		};
		HttpResponse res = sendRequest(request);

		String responseStr = res.getBody();
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

}