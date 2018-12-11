@isTest
public class SingleRequestMock implements HttpCalloutMock
{

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;

    public SingleRequestMock(Integer code, String status, String body, Map<String, String> responseHeaders)
    {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }

    public HTTPResponse respond(HTTPRequest req)
    {
        HttpResponse res = new HttpResponse();

        // handle login request
        if(req.getEndpoint().contains('/connect/token'))
        {
            res.setBody('{"access_token": "testaccesstoken", "expires_in": "testexpire", "token_type": "testtokentype"}');
            res.setStatusCode(200);
            res.setStatus('success');
            return res;
        }
        
        // handle get client request
        if(req.getEndpoint().contains('/external/api/v1/client/'))
        {
            res.setBody('{"data": {"id": "string","tenantCode": "string","name": "string","description": "string","remoteId": "string"},"httpStatusCode": "string","errors": [{"errorCode": "string","title": "string","details": "string"}],"isError": true}');
            res.setStatusCode(200);
            res.setStatus('success');
            return res;
        }

        // handle test method responses
        for (String key : this.responseHeaders.keySet())
        {
            res.setHeader(key, this.responseHeaders.get(key));
        }
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        return res;
    }

}