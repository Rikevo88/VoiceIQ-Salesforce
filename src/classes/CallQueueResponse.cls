global class CallQueueResponse extends Response
{
	public data data {get;set;}

	public class data
	{
		public String id;
		public String userId;
		public List<callQueueItem> callQueueItems;
		public Datetime createdDate;
		public Datetime lastModifiedDate;
		public String type;
	}

	public class availabilityTimeSlots
	{
		public Datetime startTime;
		public Datetime endTime;
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
		public Integer contactType;
		public scheduledCalls scheduledCalls;
		public Datetime createdDate;
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

	public class scheduledCalls
	{
		public String id;
		public String contactId;
		public List<scheduleItems> scheduleItems;
		public String type;
		public Datetime createdDate;
		public Datetime lastModifiedDate;
	}

	public class scheduleItems
	{
		public String userId;
		public String username;
		public scheduledSlots scheduledSlots;
	}

	public class scheduledSlots {}

}