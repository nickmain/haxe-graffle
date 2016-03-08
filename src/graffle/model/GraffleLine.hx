package graffle.model;

typedef LineLabel = {lineId: Int, shape: GraffleShape, position: Float}

class GraffleLine extends GraffleGraphic {

    public var headId: Int; //shape or line id, -1 for none
    public var tailId: Int; //shape or line id, -1 for none
    public var headArrow: Null<String>;
    public var tailArrow: Null<String>;
    public var dashed: Bool = false;
    public var labels: Array<LineLabel> = []; //not sorted by position

    public function new() {}
}
