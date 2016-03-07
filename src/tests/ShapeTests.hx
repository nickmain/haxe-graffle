package tests;

import graffle.model.GraffleShape;
import graffle.model.GraffleSheet;
import graffle.GraffleLoader;
import graffle.model.GraffleDiagram;
import haxe.unit.TestCase;

class ShapeTests extends TestCase {
    var diagram: GraffleDiagram;
    var sheet: GraffleSheet;

    override function setup() {
        diagram = GraffleLoader.diagramFromFile("src/tests/graffles/unit-tests.graffle");
        sheet = diagram.sheets[0];
    }

    public function testBounds() {
        var g1: GraffleShape = cast sheet.graphics.get(4);
        assertEquals(50.0, g1.x);
        assertEquals(50.0, g1.y);
        assertEquals(80.0, g1.width);
        assertEquals(80.0, g1.height);
    }

    public function testKind() {
        var g1: GraffleShape = cast sheet.graphics.get(4);
        var g2: GraffleShape = cast sheet.graphics.get(10);
        var g3: GraffleShape = cast sheet.graphics.get(3);

        assertEquals("Rectangle", g1.kind );
        assertEquals("Rectangle", g2.kind );
        assertEquals("NoteShape", g3.kind );
    }

    public function testDashed() {
        var g1: GraffleShape = cast sheet.graphics.get(4);
        var g2: GraffleShape = cast sheet.graphics.get(10);
        var g3: GraffleShape = cast sheet.graphics.get(3);
        var g4: GraffleShape = cast sheet.graphics.get(12);

        assertTrue(g2.dashed);
        assertFalse(g1.dashed);
        assertFalse(g3.dashed);
        assertFalse(g4.dashed); // no border
    }

    public function testText() {
        var g1: GraffleShape = cast sheet.graphics.get(4);
        var g2: GraffleShape = cast sheet.graphics.get(10);
        var g3: GraffleShape = cast sheet.graphics.get(3);
        var g4: GraffleShape = cast sheet.graphics.get(12);

        assertEquals("Don't Move This", g1.text );
        assertEquals("Dashed", g2.text );
        assertEquals("Hello World", g3.text );
        assertTrue( g4.text == null );
    }
}
