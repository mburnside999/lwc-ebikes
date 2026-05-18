public class MBIterator implements Iterator<EntityDefinition> {
    private List<EntityDefinition> edresults;
    private Integer currentIndex;

    public MBIterator(List<EntityDefinition> edresults) {
        this.edresults = edresults;
        this.currentIndex = 0;
    }

    public Boolean hasNext() {
        return currentIndex < edresults.size();
    }

    public EntityDefinition next() {
        if (hasNext()) {
            return edresults[currentIndex++];
        } else {
            throw new NoSuchElementException('Iterator has no more elements.');
        }
    }
}