for (Schema.SObjectType object_i : Schema.getGlobalDescribe().values()) {
    for (Schema.SObjectField field_i : object_i.getDescribe().fields.getMap().values()) {
        if (field_i.getDescribe().isEncrypted()) {
            system.debug(object_i.getDescribe().name + ': ' + field_i.getDescribe().getName());
        }
    }
}