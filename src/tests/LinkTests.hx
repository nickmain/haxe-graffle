package tests;

import graffle.model.GraffleGraphic;
import graffle.model.GraffleSheet;
import graffle.GraffleLoader;
import graffle.model.GraffleDiagram;
import haxe.unit.TestCase;

class LinkTests extends TestCase {
    var diagram: GraffleDiagram;
    var sheet1: GraffleSheet;
    var sheet2: GraffleSheet;

    override function setup() {
        diagram = GraffleLoader.diagramFromFile("src/tests/graffles/unit-tests-2.graffle");
        sheet1 = diagram.sheets[0];
        sheet2 = diagram.sheets[1];
    }

    public function testSheetLink() {
        var link = sheet1.graphics.get(5);

        assertFalse(link.link == null);
        assertTrue(switch(link.link) {
            case JumpToSheet(1): true;
            default: false;
        });
    }

    public function testGraphicLink() {
        var link = sheet2.graphics.get(3);

        assertFalse(link.link == null);
        assertTrue(switch(link.link) {
            case JumpToGraphic(0,i): sheet1.topGraphics[i].id == 4;
            default: false;
        });
    }

    public function testFileLink() {
        var link = sheet2.graphics.get(5);

        assertFalse(link.link == null);
        assertTrue(switch(link.link) {
            case OpenFile("../../../README.md"): true;
            default: false;
        });
    }

    public function testUrlLink() {
        var link = sheet2.graphics.get(4);

        assertFalse(link.link == null);
        assertTrue(switch(link.link) {
            case OpenURL("http://www.cnn.com"): true;
            default: false;
        });
    }
}