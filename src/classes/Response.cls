global virtual class Response
{
	public String httpStatusCode;
	public List<error> errors;
	public Boolean isError;

	public class error
	{
		public String errorCode;
		public String title;
		public String details;
	}
}