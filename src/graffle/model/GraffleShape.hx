package graffle.model;

class GraffleShape extends GraffleGraphic {

    public var kind: Null<String>; // shape "class"
    public var x: Float;
    public var y: Float;
    public var width: Float;
    public var height: Float;
    public var dashed: Bool = false;

    public function new() {}
}
