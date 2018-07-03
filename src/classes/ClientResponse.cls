global class ClientResponse extends Response
{

	public LoginResponse loginResponse {get; private set;}

	public data data {get; set;}

	public class data
	{
		public String id;
		public String tenantCode;
		public String name;
		public String description;
		public String remoteId;
	}

	public void setLoginResponse(LoginResponse loginResponse)
	{
		this.loginResponse = loginResponse;
	}
	
}