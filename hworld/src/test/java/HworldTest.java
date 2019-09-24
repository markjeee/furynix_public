import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class HworldTest {

    private Hworld hworld;

    @Before
    public void setup() {
        hworld = new Hworld();
    }

    @Test
    public void testNameGiven() {
        String input = "test";
        String expected = "Hi, Hello test";

        assertEquals(expected, hworld.hworld(input));
    }

}
