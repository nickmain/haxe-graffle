package tests;

import tests.UnitTests;
import hxcpp.StaticStd;
import hxcpp.StaticRegexp;
import hxcpp.StaticZlib;
import hxcpp.StaticMysql;
import hxcpp.StaticSqlite;

class UnitTestsCPP {

    static function main() {
        UnitTests.graffle1 = "/Users/maind077/Developer/github/haxe-graffle/src/tests/graffles/unit-tests.graffle";
        UnitTests.graffle2 = "/Users/maind077/Developer/github/haxe-graffle/src/tests/graffles/unit-tests-2.graffle";

        UnitTests.runTests();

        cpp.vm.Gc.run(true);
    }
}
