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

    public function testFill() {
        var g1: GraffleShape = cast sheet.graphics.get(4);
        var g2: GraffleShape = cast sheet.graphics.get(10);
        var g3: GraffleShape = cast sheet.graphics.get(3);
        var g4: GraffleShape = cast sheet.graphics.get(12);

        assertTrue(compareColors({r: 1.0, g: 1.0, b: 1.0, a: 1.0}, g1.fill));
        assertTrue(compareColors({r: 1.0, g: 1.0, b: 1.0, a: 1.0}, g2.fill));
        assertTrue(g3.fill == null);
        assertTrue(compareColors({r: 0.0, g: 0.501, b: 0.0, a: 0.942}, g4.fill));
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

    public function testLabels() {
        var label1: GraffleShape = cast sheet.graphics.get(17);
        var label2: GraffleShape = cast sheet.graphics.get(18);

        assertEquals(15, label1.label.lineId);
        assertEquals(0.21271513927415048, label1.label.position);

        assertEquals(15, label2.label.lineId);
        assertEquals(0.62957183162255304, label2.label.position);
    }

    public function testConnections() {
        var shapeA: GraffleShape = cast sheet.graphics.get(19);
        var bolt: GraffleShape = cast sheet.graphics.get(8);

        assertEquals(-1, shapeA.headId);
        assertEquals(-1, shapeA.tailId);

        assertEquals("Bolt", bolt.kind);
        assertEquals(19, bolt.headId);
        assertEquals(14, bolt.tailId);
    }

    private function compareColors(a: RGBAColor, b: RGBAColor) {
        if(a == null && b == null) return true;
        if(a == null || b == null) return false;

        return compareFloats(a.r, b.r)
            && compareFloats(a.g, b.g)
            && compareFloats(a.b, b.b)
            && compareFloats(a.a, b.a);
    }

    private function compareFloats(a: Float, b: Float) {
        return a <= (b + 0.001) && a >= (b - 0.001);
    }
}
