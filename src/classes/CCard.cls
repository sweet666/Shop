public with sharing class CCard {

    public Card__c crd {get; set;}
    public Boolean selected {get; set;}

    public cCard(Card__c c) {
        crd = c;
        selected = false;
    }

}