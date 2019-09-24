import org.furynix.Jworld;

class Hworld {

    private Jworld jworld;

    public Hworld() {
        jworld = new Jworld();
    }

    String hworld(String name) {
        return String.format("Hi, %s", jworld.jworld(name));
    }

}
