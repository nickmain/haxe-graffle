package tests;

import graffle.model.GraffleGroup;
import graffle.model.GraffleSheet;
import graffle.GraffleLoader;
import graffle.model.GraffleDiagram;
import haxe.unit.TestCase;

class GroupTests extends TestCase {
    var diagram: GraffleDiagram;
    var sheet: GraffleSheet;

    override function setup() {
        diagram = GraffleLoader.diagramFromFile("src/tests/graffles/unit-tests.graffle");
        sheet = diagram.sheets[0];
    }

    public function testGroup() {
        var group: GraffleGroup = cast sheet.graphics.get(22);

        assertTrue(group.background == null); //since not a subgraph
        assertEquals(2, group.children.length);
        assertEquals(group, group.children[0].group);
        assertEquals(group, group.children[1].group);
    }

    public function testSubgraph() {
        var subgraph: GraffleGroup = cast sheet.graphics.get(29);

        assertEquals(2, subgraph.children.length);
        assertEquals(subgraph, subgraph.children[0].group);
        assertEquals(subgraph, subgraph.children[1].group);
        assertEquals("Subgraph", subgraph.background.text);
    }

    public function testTable() {
        var table: GraffleGroup = cast sheet.graphics.get(34);

        assertEquals(6, table.children.length);
        assertTrue(table.isTable);
    }
}