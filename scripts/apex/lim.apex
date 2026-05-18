List<String> criteria = new List<String>{ 'Unused' };
List<List<MBLimit>> results = MBLimitInvocableApex.getLimits(criteria);
System.debug(results);
