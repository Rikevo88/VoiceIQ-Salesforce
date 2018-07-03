global class UserResponse extends Response
{

	public data data {get; set;}

	public class data
	{
		public String id;
		public String displayName;
		public String firstName;
		public String lastName;
		public String email;
		public String mobilePhone;
		public String username;
		public String callQueueId;
		public organisationDetails organisationDetails;
		public authInfo authInfo;
		public preferences preferences;
		public Datetime createdDate;
		public Datetime lastModifiedDate;
		public String type;
	}

	public class organisationDetails
	{
		public String id;
		public String name;
		public String tenantCode;
	}

	public class authInfo
	{
		public String salesforceUserId;
		public String salesforceUserUri;
		public String instanceUrl;
		public String accessToken;
		public String refreshToken;
		public String apiVersion;
	}

	public class preferences
	{
		public callReminderSettings callReminderSettings;
	}

	public class callReminderSettings
	{
		public Integer minutesBeforeCall;
	}

}