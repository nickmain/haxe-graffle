package tests;

import graffle.GraffleLoader;
import graffle.model.GraffleDiagram;
import plist.PList;
import plist.PListLoader;
import haxe.unit.TestCase;

class GraffleMetadataTests extends TestCase {

    var plist: PList;
    var diagram: GraffleDiagram;

    override function setup() {
        plist = PListLoader.loadFile("src/tests/graffles/unit-tests.graffle");
        var loader = new GraffleLoader();
        loader.loadFromPList(plist);
        diagram = loader.diagram;
    }

    public function testBasic() {
        assertEquals("A", "A");
        trace(diagram);
    }
}
