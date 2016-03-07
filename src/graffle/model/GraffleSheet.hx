package graffle.model;

/**
 A page in the diagram - aka "canvas" or "sheet"
**/
class GraffleSheet {

    public var title: String;
    public var id: Int;
    public var diagram: GraffleDiagram;

    public var graphics: Map<Int,GraffleGraphic> = new Map<Int,GraffleGraphic>(); //all by id
    public var topGraphics: Array<GraffleGraphic> = []; //top level graphics

    public function new() {}
}
