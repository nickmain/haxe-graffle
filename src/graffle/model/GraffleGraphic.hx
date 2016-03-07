package graffle.model;

/**
 Base for all graphic objects
**/
class GraffleGraphic {

    public var group: Null<GraffleGroup>;
    public var sheet: GraffleSheet;
    public var id: Int;

    public var note: Null<String>;
    public var name: Null<String>;
    public var metadata: Map<String,String> = new Map<String,String>();
}
