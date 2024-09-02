trigger trgWine on Wines__c(after insert, after update) {
    if (System.isFuture()) {
        return;
    }

    Set<id> updatedWines = new Set<id>();

    for (Wines__c wine : Trigger.new) {
        updatedWines.add(wine.Id);
    }

    if (updatedWines.size() > 0) {
        WinePredictionCallout.makeCallout(updatedWines);
    }

}
