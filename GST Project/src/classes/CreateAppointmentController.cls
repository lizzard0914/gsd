global with sharing class CreateAppointmentController{

 public string todaysdate{get;set;}
 public List<event> Eve{get;set;}
 public List<Lead> LeadList{get;set;}
 Public id LeadId{get;set;}
 
 global CreateAppointmentController(){
     todaysdate=system.now().format('yyyy-MM-dd');
     LeadId=ApexPages.currentPage().getParameters().get('id');
     
     
     //createEvent();
     pullLead();
 }
     public void pullLead(){
         LeadList= New List<Lead>();
         LeadList=[Select id,FirstName,LastName,Email,MobilePhone,Street,city,PostalCode,State,Owner.Firstname,owner.lastname,owner.Email,owner.phone,owner.id
                      from Lead 
                      where id=:LeadId];
         system.debug('<<<<>>>'+LeadList);
     }
     public void createEvent(){
            Eve=New List<Event>();
            Event Eve1 = New Event();
            Eve1.Subject='Test';
            Eve.add(Eve1);
            
        }
    
   @RemoteAction
    global static list<calendarWrapper> getCalendarItems(string ObjectName,string URL,string startdatetimeField,string enddatetimeField,string title){
       
       list<calendarWrapper> lstcalendar=new list<calendarWrapper>();
       TimeZone tz = UserInfo.getTimeZone();
       String userid =UserInfo.getUserId();
       string querystr='Select Id'+','+title+','+enddatetimeField+','+startdatetimeField;
       
       if(URL!='id'){
         querystr=querystr+','+URL;
       }
       
       querystr=querystr+' from '+ObjectName+' where owner.id=\''+userid+'\' order by createdDate DESC limit 25000';//Limit the data
       system.debug('<><>'+querystr);
       
       for(Sobject t:Database.query(querystr)){
           calendarWrapper c=new calendarWrapper();
           c.title=(string)t.get(title);
           c.Id=(string)t.get(URL);
           if(startdatetimeField !=null){
             if(t.get(startdatetimeField)!=null){
                c.start=((datetime)t.get(startdatetimeField)).gettime()+tz.getOffset((datetime)t.get(startdatetimeField));
             }
           }
           if(enddatetimeField != null){
              if(t.get(enddatetimeField)!=null){
                c.endd=((datetime)t.get(enddatetimeField)).gettime()+tz.getOffset((datetime)t.get(enddatetimeField));
             }
           }
           if(URL!='id'){
              c.url=(string)t.get(URL);
           }else{
              c.url='/'+c.Id;
           }
           lstcalendar.add(c);
       }
       return lstcalendar;

    }
   
    global class calendarWrapper{
       public string Id;
       public string title;
       public string url;
       public long start;
       public long endd;
    }
    
}