public class macalendarentry {
   public event event{get;set;}
   public Boolean flag{get;set;} 
   public boolean saveflag;
    public macalendarentry(ApexPages.StandardController stdController){

        if(event == null) event = new Event();
        event.ownerid = ApexPages.currentPage().getParameters().get('ownerID');
        event.whoid = ApexPages.currentPage().getParameters().get('whatid');
        string tempDate =  ApexPages.currentPage().getParameters().get('StartDate');
        string temptime =  ApexPages.currentPage().getParameters().get('StartTime');
        String[] startTime= Temptime.split(':');
        system.debug('<<<startTime>>>>'+startTime);
        Date newDate = Date.parse(TempDate)+1;
        flag=false;
        Datetime dt = Datetime.newInstanceGMT(newDate.year(), newDate.month(),newDate.day(),Integer.ValueOf(startTime[0])-17,Integer.ValueOf(startTime[1]),0);
        System.debug('<<<<>>>>'+dt);
        //DateTime dt = (DateTime) JSON.deserialize('TempDate', DateTime.class);
        event.StartDateTime=dt ;
        Datetime edt = Datetime.newInstanceGMT(newDate.year(), newDate.month(),newDate.day(),(Integer.ValueOf(startTime[0])-17)+1,Integer.ValueOf(startTime[1]),0);
        System.debug('<<<<>>>>'+dt);
        event.EndDateTime=edt;
        
      
    }
    
   public PageReference save() {
   string Lead_City=  ApexPages.currentPage().getParameters().get('LeadCity');
   string Leadid = ApexPages.currentPage().getParameters().get('whatid');
   
    Database.LeadConvert lc = new Database.LeadConvert();
    lc.setLeadId(Leadid);

    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    lc.setConvertedStatus(convertStatus.MasterLabel);
    Database.LeadConvertResult lcr = Database.convertLead(lc);

    id oppid=lcr.getOpportunityId();
    id conid=lcr.getContactId();
    system.debug('<<<oppid>>>>'+oppid);
   
    Event.location=Lead_City;
    Event.Whatid=oppid;
    Event.whoid=conid;
    Event.subject='Appointment';
   
    insert Event;    
            
   
        PageReference reRend = new PageReference('/00Q');
        reRend.setRedirect(true);
        return reRend;

    }

   public PageReference checkEvent() {
       Time sTime=event.StartDateTime.time();
       Integer Shours=sTime.hour();
       System.debug('<<<<Shours>>>>'+Shours);
       if(Shours>=20 || Shours<6){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You can select only 6:00 AM To 8:00 PM');
           ApexPages.addMessage(myMsg);
       }else{
       integer Count=0;
   list<event> Eve = New List<event>();
   Eve =[Select Id,Subject,Enddatetime,Startdatetime 
           from Event 
           where owner.id=:UserInfo.getUserId()];
           
       for(Event e:Eve){
        if(string.valueOf(event.StartDateTime)==string.valueOf(e.Startdatetime) || string.valueOf(event.EndDateTime)==string.valueOf(e.Enddatetime)){
            Count++;
        }
           system.debug('<<<Count>>>>'+Count);           
       }
       if(count>0){
           ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Warning,'Already You have some appoinment on same time. If you want continue click the Save Button');
           ApexPages.addmessage(msg);
           flag=true;
       }
       else{
           return save();       
       }
   } 
  
   return null;
   
}

}