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

    public function testComments() {
        assertEquals("These are some comments", diagram.comments);
    }

    public function testSubject() {
        assertEquals("hello world", diagram.subject);
    }

    public function testCopyright() {
        assertEquals("copywrong", diagram.copyright);
    }

    public function testVersion() {
        assertEquals("1.0 Golden Master", diagram.version);
    }

    public function testDescription() {
        assertEquals("test diagram", diagram.description);
    }

    public function testAuthors() {
        assertEquals("foo author", diagram.authors[0]);
        assertEquals("bar author", diagram.authors[1]);
    }

    public function testOrganizations() {
        assertEquals("orgalorg", diagram.organizations[0]);
        assertEquals(1, diagram.organizations.length);
    }

    public function testLanguages() {
        assertEquals("english", diagram.languages[0]);
        assertEquals(1, diagram.languages.length);
    }

    public function testKeywords() {
        assertEquals("foo", diagram.keywords[0]);
        assertEquals("bar", diagram.keywords[1]);
        assertEquals("baz", diagram.keywords[2]);
    }

    public function testProjects() {
        assertEquals("haxe-graffle", diagram.projects[0]);
        assertEquals(1, diagram.projects.length);
    }
}
