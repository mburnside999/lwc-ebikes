public class MBEntityDefinitionIterator implements Iterator<EntityDefinition> {
    private List<EntityDefinition> entitydefinitions;
    private Integer currentIndex;

    public MBEntityDefinitionIterator(
        List<EntityDefinition> entitydefinitions
    ) {
        this.entitydefinitions = entitydefinitions;
        this.currentIndex = 0;
    }

    public Boolean hasNext() {
        return currentIndex < entitydefinitions.size();
    }

    public EntityDefinition next() {
        if (hasNext()) {
            return entitydefinitions[currentIndex++];
        } else {
            throw new NoSuchElementException('Iterator has no more elements.');
        }
    }
}