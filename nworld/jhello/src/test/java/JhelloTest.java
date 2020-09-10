import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.furynix.Jhello;

import static org.junit.Assert.assertEquals;

public class JhelloTest {

    private Jhello jhello;

    @Before
    public void setup() {
        jhello = new Jhello();
    }

    @Test
    public void testNameGiven() {
        String input = "test";
        String expected = "Hohoho test";

        assertEquals(expected, jhello.jhello(input));
    }
}
