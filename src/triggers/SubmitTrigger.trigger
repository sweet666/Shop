trigger SubmitTrigger on Shop_Order__c (after insert) {

    for (Shop_Order__c o : Trigger.new) {
        if (o.Status__c == ShopConstants.PENDING_STATUS){
            SubmitApproval.submitRequestApproval(o.id);
        }
    }

}