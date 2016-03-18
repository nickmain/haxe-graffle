package tests;

import graffle.model.GraffleLine;
import graffle.model.GraffleSheet;
import graffle.GraffleLoader;
import graffle.model.GraffleDiagram;
import haxe.unit.TestCase;

class LineTests extends TestCase {
    var diagram: GraffleDiagram;
    var sheet: GraffleSheet;

    override function setup() {
        diagram = GraffleLoader.diagramFromFile(UnitTests.graffle1);
        sheet = diagram.sheets[0];
    }

    public function testLabels() {
        var solidLine: GraffleLine = cast sheet.graphics.get(15);
        var dashedLine: GraffleLine = cast sheet.graphics.get(16);

        assertEquals(0, dashedLine.labels.length);
        assertEquals(2, solidLine.labels.length);
    }

    public function testDashed() {
        var solidLine: GraffleLine = cast sheet.graphics.get(15);
        var dashedLine: GraffleLine = cast sheet.graphics.get(16);

        assertTrue(dashedLine.dashed);
        assertFalse(solidLine.dashed);
    }

    public function testArrows() {
        var solidLine: GraffleLine = cast sheet.graphics.get(15);
        var dashedLine: GraffleLine = cast sheet.graphics.get(16);

        assertEquals("StickArrow", dashedLine.headArrow);
        assertEquals("DoubleStickArrow", dashedLine.tailArrow);
        assertEquals("FilledArrow", solidLine.headArrow);
        assertEquals("0", solidLine.tailArrow);
    }

    public function testConnections() {
        var solidLine: GraffleLine = cast sheet.graphics.get(15);
        var dashedLine: GraffleLine = cast sheet.graphics.get(16);

        assertEquals(-1, dashedLine.headId);
        assertEquals(17, dashedLine.tailId);
        assertEquals(13, solidLine.headId);
        assertEquals(14, solidLine.tailId);
    }
}
