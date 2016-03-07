package tests;

class UnitTests {
    static function main() {
        var r = new haxe.unit.TestRunner();
        r.add(new GraffleMetadataTests());
        // add other TestCases here

        // finally, run the tests
        r.run();
    }
}
