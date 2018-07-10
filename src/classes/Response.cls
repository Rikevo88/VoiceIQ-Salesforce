global virtual class Response
{
	public String httpStatusCode {get;set;}
	public List<error> errors
	{
		get
		{
			if(this.errors == null)
			{
				this.errors = new List<error>();
			}
			return this.errors;
		}
		set;
	}
	public Boolean isError;

	global class error
	{
		@InvocableVariable global String errorCode;
		@InvocableVariable global String title;
		@InvocableVariable global String details;

		private void debugError()
		{
			System.debug(this.errorCode);
			System.debug(this.title);
			System.debug(this.details);
		}

		private String getError()
		{
			return String.format('{0} : {1} : {2}', new List<String>
			{
				this.errorCode,
				this.title,
				this.details
			});
		}
	}

	public void debugErrors()
	{
		for(error err : this.errors)
		{
			err.debugError();
		}
	}

	public List<String> getErrors()
	{
		List<String> errorStrings = new List<String>();
		for(error err : this.errors)
		{
			errorStrings.add(err.getError());
		}
		return errorStrings;
	}
}