public class MBIterable implements Iterable<EntityDefinition> {
    public Iterator<EntityDefinition> iterator() {
        List<EntityDefinition> entityresults = [
            SELECT qualifiedapiname
            FROM entitydefinition
        ];
        return new MBIterator(entityresults);
    }
}