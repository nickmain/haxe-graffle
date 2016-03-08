package graffle.model;

enum LinkAction {
    JumpToSheet(sheetIndex: Int); // jump to sheet with given index
    JumpToGraphic(sheetIndex: Int, graphicIndex: Int); // jump to graphic with given index
    OpenURL(url: String);
    OpenFile(path: String);  //path may be relative
}

/**
 Base for all graphic objects
**/
class GraffleGraphic {

    public var group: Null<GraffleGroup>;
    public var sheet: GraffleSheet;
    public var id: Int;

    public var link: Null<LinkAction>;
    public var note: Null<String>;
    public var name: Null<String>;
    public var metadata: Map<String,String> = new Map<String,String>();
}
