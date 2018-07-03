global virtual class Response
{
	public String httpStatusCode {get;set;}
	public List<error> errors;
	public Boolean isError;

	global class error
	{
		@InvocableVariable global String errorCode;
		@InvocableVariable global String title;
		@InvocableVariable global String details;
	}
}