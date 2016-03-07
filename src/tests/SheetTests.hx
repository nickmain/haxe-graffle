package tests;

import haxe.unit.TestCase;
import graffle.GraffleLoader;
import graffle.model.GraffleDiagram;

class SheetTests extends TestCase {

    public function testSingleSheet() {
        var diagram = GraffleLoader.diagramFromFile("src/tests/graffles/unit-tests.graffle");

        assertEquals(1, diagram.sheets.length);
        assertEquals("First Sheet", diagram.sheets[0].title);
        assertTrue(diagram == diagram.sheets[0].diagram);
    }

    public function testMultipleSheets() {
        var diagram = GraffleLoader.diagramFromFile("src/tests/graffles/unit-tests-2.graffle");

        assertEquals(2, diagram.sheets.length);
        assertEquals("First Sheet", diagram.sheets[0].title);
        assertEquals("Second Sheet", diagram.sheets[1].title);

        assertTrue(diagram == diagram.sheets[0].diagram);
        assertTrue(diagram == diagram.sheets[1].diagram);
    }
}
