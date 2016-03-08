package graffle.model;

class GraffleGroup extends GraffleGraphic {

    public var background: Null<GraffleShape>;  // if a subgraph
    public var children: Array<GraffleGraphic> = [];
    public var isTable: Bool = false;

    public function new() {}
}
