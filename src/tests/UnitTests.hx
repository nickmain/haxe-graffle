package tests;

class UnitTests {
    static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new GraffleMetadataTests());
        r.add(new SheetTests());
        r.add(new GraphicTests());
        r.add(new ShapeTests());
        r.add(new LineTests());
        r.add(new GroupTests());
        r.add(new LinkTests());

        //TODO: overlap tests
        r.run();
    }
}
