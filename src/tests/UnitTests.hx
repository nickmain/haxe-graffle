package tests;

class UnitTests {
    static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new GraffleMetadataTests());
        r.add(new SheetTests());
        r.add(new GraphicTests());
        r.add(new ShapeTests());
        r.run();
    }
}
