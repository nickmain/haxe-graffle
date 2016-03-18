package tests;

class UnitTests {

    public static var graffle1 = "src/tests/graffles/unit-tests.graffle";
    public static var graffle2 = "src/tests/graffles/unit-tests-2.graffle";

    static function main() {
        runTests();
    }

    public static function runTests() {
        var r = new haxe.unit.TestRunner();
        r.add(new GraffleMetadataTests());
        r.add(new SheetTests());
        r.add(new GraphicTests());
        r.add(new ShapeTests());
        r.add(new LineTests());
        r.add(new GroupTests());
        r.add(new LinkTests());
        r.add(new MacroTests());

        //TODO: images tests
        //TODO: overlap tests

        try r.run()
        catch(e: Dynamic) trace("Oops: " + e);
    }
}
