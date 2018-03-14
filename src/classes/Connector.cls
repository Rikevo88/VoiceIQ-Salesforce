global class Connector
{

	private static String VOICEIQ_URL = 'http://enviqst01api.azurewebsites.net';

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

	global static LoginResponse authenticate()
	{
		VoiceIQRequest request = new VoiceIQRequest();
		request.endpoint =  '/api/v1/authentication/login';
		request.method = 'POST';
		request.body = '{ "username": "mehran@getviq.com", "password": "4KZf2*lvEgcf9G2@" }';
		HttpResponse res = sendRequest(request);
		String responseStr = res.getBody();
		LoginResponse response = (LoginResponse)JSON.deserialize(responseStr, LoginResponse.class);
		return response;
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
			'Authorization' => authToken,
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
