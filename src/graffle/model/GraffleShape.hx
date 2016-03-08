package graffle.model;

import graffle.model.GraffleLine.LineLabel;

typedef RGBAColor = {r: Float, g: Float, b: Float, a: Float};

class GraffleShape extends GraffleGraphic {

    public var kind: Null<String>; // shape "class"
    public var x: Float = 0;
    public var y: Float = 0;
    public var width: Float = 0;
    public var height: Float = 0;
    public var dashed: Bool = false;
    public var text: Null<String>;
    public var fill: Null<RGBAColor>;
    public var label: Null<LineLabel>;

    public var headId: Int; //connected shape or line id, -1 for none
    public var tailId: Int; //connected shape or line id, -1 for none

    public function new() {}
}
