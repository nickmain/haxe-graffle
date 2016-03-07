package graffle.model;

class GraffleShape extends GraffleGraphic {

    public var kind: Null<String>; // shape "class"
    public var x: Float = 0;
    public var y: Float = 0;
    public var width: Float = 0;
    public var height: Float = 0;
    public var dashed: Bool = false;
    public var text: Null<String>;

    public function new() {}
}
