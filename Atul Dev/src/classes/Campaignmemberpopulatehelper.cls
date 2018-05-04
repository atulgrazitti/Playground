public class Campaignmemberpopulatehelper {
    public static void GetCampaignName(list<lead>newrecords){
        set<id>NewLeadsIdSet = new set<id>(); //Set to store IDs of new Leads
        set<string>CampaignNameSet = new set<string>();//set to store campaign name from the field of Lead coming from pardot
        map<string,id>CampaignMap = new map<string,id>();//Map of Campaign Name and ID
        if(NewLeadsIdSet.isempty()){
            		for(lead ldd : newrecords){
                		NewLeadsIdSet.add(ldd.id);
                    }
        }
        
        if(!newrecords.isEmpty()){
            system.debug('New Lead Records****************************'+newrecords);
             for(lead ld : newrecords){
            if(ld.ZakAssess__Hidden_Campaign_Field__c != null){
                CampaignNameSet.add(ld.ZakAssess__Hidden_Campaign_Field__c);
            }
                 system.debug('Campaign Set Values********************'+CampaignNameSet);
        }
        }
        for(Campaign cn : [select id,Name from campaign where name in: CampaignNameSet]){
            if(CampaignMap.isEmpty()){
                CampaignMap.put(cn.name, cn.Id);
            }
            system.debug('Campaign Map*************************'+CampaignMap.values());
        }
         map<id,list<id>> LeadwithCampaignNameMap = new map<id,list<id>>();
      	for(campaignmember cmp :[select id,LeadId,CampaignId from campaignmember where leadid in:NewLeadsIdSet] ){
            if(!LeadwithCampaignNameMap.containsKey(cmp.LeadId)){
                LeadwithCampaignNameMap.put(cmp.LeadId,new list<id>{cmp.CampaignId});
            }
            else{
                LeadwithCampaignNameMap.get(cmp.LeadId).add(cmp.CampaignId);
            }
            system.debug('LeadwithCampaignNameMap **************************'+LeadwithCampaignNameMap);
        }
       list<campaignmember> CampaignMemberList = new list<campaignmember>();
        for(lead ld1 : newrecords){
             //create new campaign member
        	campaignmember cmb = new campaignmember();
            if(!LeadwithCampaignNameMap.containsKey(cmb.LeadId)){
                   cmb.CampaignId= CampaignMap.get(ld1.ZakAssess__Hidden_Campaign_Field__c);
                cmb.LeadId = ld1.Id;
                CampaignMemberList.add(cmb);
               
            }
            
        } 
       insert CampaignMemberList;
        /*for(Campaignmember updatecmp :CampaignMemberList){
            updatecmp.CampaignId = null;
            updatecmp.LeadId = null;
           CampaignMemberList.add(updatecmp); 
        }
       update CampaignMemberList;
     
        }*/
    }
}