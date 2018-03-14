global class CallQueueResponse extends Response
{
	public data data {get; set;}

	public class data
	{
		public String id;
		public String userId;
		List<String> availabilityTimeSlots;
		public String timezone;
		List<callQueueItem> callQueueItems;
		public Datetime createdDate;
		public Datetime lastModifiedDate;
		public String type;
	}

	public class callQueueItem
	{
		public String id;
		public contactDetails contactDetails;
		public Integer scheduleType;
		public Datetime callTime;
		public Datetime callTimeEnd;
	}

	public class contactDetails
	{
		public String id;
		public String remoteId;
		public account account;
		public String firstName;
		public String lastName;
		public String title;
		public String email;
		public String homePhone;
		public String mobilePhone;
		public String phone;
		public Boolean isDeleted;
		public String ownerId;
		public String photoUrl;
		//public Datetime date;
		public String createdById;
		public Datetime lastModifiedDate;
		public String lastModifiedbyId;
		public String type;
	}

	public class account
	{
		public String id;
		public String name;
	}

}
