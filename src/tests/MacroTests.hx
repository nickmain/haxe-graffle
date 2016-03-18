package tests;

import haxe.unit.TestCase;

import haxe.macro.Expr;
import haxe.macro.Context;
import graffle.GraffleLoader;
import graffle.model.GraffleDiagram;
import graffle.model.GraffleShape;

class MacroTests extends TestCase {

    macro static function getSubject(e:Expr) {
        var diagram = GraffleLoader.diagramFromFile(UnitTests.graffle1);
        return macro $v{diagram.subject};
    }

    macro static function getExpr(e:Expr) {
        var diagram = GraffleLoader.diagramFromFile(UnitTests.graffle1);
        var code = cast(diagram.sheets[0].graphics[41], GraffleShape).text;
        return Context.parse(code, e.pos);
    }

    public function testSanity() {
        assertEquals("hello world", getSubject(whatever));

        assertEquals(7, getExpr(whatever));
    }

}

