public class MBEntityDefinitionIterable implements Iterable<EntityDefinition> {
    public Iterator<EntityDefinition> iterator() {
        List<EntityDefinition> entitydefinitions = [
            SELECT qualifiedapiname
            FROM entitydefinition
        ];
        return new MBEntityDefinitionIterator(entitydefinitions);
    }
}