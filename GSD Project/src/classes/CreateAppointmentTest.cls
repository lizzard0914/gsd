@isTest(SeeAllData=true)
private class CreateAppointmentTest{
   
   static testmethod void testgetCalendarItems(){
       Test.startTest();
       
       Lead l = new Lead();
       l.Company = 'Test Lead';
       l.LastName = 'Lead Last Name';
       insert l;
       
       Account acc=new Account();
       acc.Name='Test';
       insert acc;
       
       Event e=new Event();
       e.Subject='Test';
       e.whoid=l.id;
       e.StartDatetime=system.today();
       e.EndDatetime=system.today()+10;
       insert e;
       
       String userid =UserInfo.getUserId();
       list<CreateAppointmentController.calendarWrapper> lstwrapper=CreateAppointmentController.getCalendarItems('Event','id','StartDatetime','EndDateTime','Subject');
       CreateAppointmentController CAC= New CreateAppointmentController();
       CAC.pullLead();
       CAC.createEvent();
       apexPages.CurrentPage().getParameters().Put('id',String.valueOf(e.id));
       apexPages.CurrentPage().getParameters().Put('ownerID',userid);
       apexPages.CurrentPage().getParameters().Put('StartDate','3/20/2018');
       apexPages.CurrentPage().getParameters().Put('StartTime','10:30');
       apexPages.CurrentPage().getParameters().Put('whatid',String.valueOf(l.id));
       Apexpages.StandardController stdController = new Apexpages.StandardController(e);
       macalendarentry MC= New macalendarentry(stdController);
       MC.save();
       MC.checkEvent();
   }

}