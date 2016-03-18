package tests;

import graffle.model.GraffleSheet;
import graffle.GraffleLoader;
import graffle.model.GraffleDiagram;
import haxe.unit.TestCase;

class GraphicTests extends TestCase {

    var diagram: GraffleDiagram;
    var sheet: GraffleSheet;

    override function setup() {
        diagram = GraffleLoader.diagramFromFile(UnitTests.graffle1);
        sheet = diagram.sheets[0];
    }

    public function testGraphicMetadata() {
        var g = sheet.graphics.get(3);
        assertFalse(g == null);

        assertTrue(g.group == null);
        assertTrue(g.sheet == sheet);
        assertEquals(3, g.id);
        assertEquals("state", g.name);
        assertEquals("this is a state", g.note);
        assertEquals("one", g.metadata["key 1"]);
        assertEquals("two", g.metadata["key 2"]);
    }
}
