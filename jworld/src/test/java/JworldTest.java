import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.furynix.Jworld;

import static org.junit.Assert.assertEquals;

public class JworldTest {

    private Jworld jworld;

    @Before
    public void setup() {
        jworld = new Jworld();
    }

    @Test
    public void testNameGiven() {
        String input = "test";
        String expected = "Hello test";

        assertEquals(expected, jworld.jworld(input));
    }
}
