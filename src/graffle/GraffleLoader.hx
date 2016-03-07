package graffle;

import graffle.model.GraffleGraphic;
import graffle.model.GraffleTable;
import graffle.model.GraffleShape;
import graffle.model.GraffleGroup;
import graffle.model.GraffleSheet;
import plist.PList;
import plist.PListLoader;
import graffle.model.GraffleDiagram;

/**
 Loads Omnigraffle documents
**/
class GraffleLoader {

    //TODO: handle graffle files that are folders
    //TODO: handle compressed graffle files

    public var diagram = new GraffleDiagram();

    public function new() {}

    /**
      Convenience to load diagram from file
    **/
    public static function diagramFromFile(filePath: String): GraffleDiagram {
        var plist = PListLoader.loadFile(filePath);
        var loader = new GraffleLoader();
        loader.loadFromPList(plist);
        return loader.diagram;
    }

    public function loadFromPList(plist: PList) {
        loadDiagramMetadata(plist);
        loadSheets(plist);
    }

    private function loadSheets(dict: PList) {
        var sheetArray = findArray(dict, ["Sheets"]);
        if(sheetArray == null) {
            // if no sheet array root dict is the single sheet
            sheetArray = [PListDict(dict)];
        }

        for(sheet in sheetArray) switch(sheet) {
            case PListDict(d): loadSheet(d);
            default: throw "wtf?";
        }
    }

    private function loadSheet(dict: PList) {
        var sheet = new GraffleSheet();
        sheet.id = findInt(dict, ["UniqueID"]);
        sheet.title = findString(dict, ["SheetTitle"]);
        sheet.diagram = diagram;

        var graphics = findArray(dict, ["GraphicsList"]);
        loadGraphics(graphics, sheet, null);

        diagram.sheets.push(sheet);
    }

    private function loadGraphics(graphics: Array<PListEntry>, sheet: GraffleSheet, group: GraffleGroup) {
        for(g in graphics) switch(g) {
            case PListDict(d): loadGraphic(d, sheet, group);
            default: throw "wtf?";
        }
    }

    private function loadGraphic(dict: PList, sheet: GraffleSheet, group: GraffleGroup) {
        var type = findString(dict, ["Class"]);
        if(type == null) type = "ShapedGraphic";

        var g: GraffleGraphic = switch(type) {
            case "ShapedGraphic": new GraffleShape();
//            case "LineGraphic": new GraffleLine();
//            case "Group": new GraffleGroup();
//            case "TableGroup": new GraffleTable();
            default: null;
        }
        if(g == null) return;  //just ignore unknown types

        g.name = findString(dict, ["Name"]);
        g.note = findString(dict, ["Notes"]);
        g.id = findInt(dict, ["ID"]);
        g.sheet = sheet;
        g.group = group;

        sheet.graphics.set(g.id, g);

        if( group != null ) {
            group.children.push(g);
        }
        else {
            sheet.topGraphics.push(g); //top-level since it's not in a group
        }

        var props = findDict(dict, ["UserInfo"]);
        if(props != null) for(key in props.keys()) switch(props[key]) {
            case PListString(s): g.metadata.set(key, s);
            default:
        }

        switch(type) {
            case "ShapedGraphic": loadShape(dict, cast g);
//            case "LineGraphic": ...
//            case "Group": ...
//            case "TableGroup": ...
            default:
        }

        //TODO: sub-type loading
    }

    private function loadShape(dict: PList, shape: GraffleShape) {
        shape.text = findString(dict, ["Text", "Text"]);
        shape.dashed = findInt(dict, ["Style", "stroke", "Pattern"]) > 0;
        shape.kind = findString(dict, ["Shape"]);
        if(shape.kind == null) shape.kind = "Rectangle";

        var bounds = findString(dict, ["Bounds"]);
        if(bounds != null) {
            bounds = ~/{/g.replace(bounds, "");
            bounds = ~/}/g.replace(bounds, "");
            var nums = bounds.split(",");
            shape.x = Std.parseFloat(nums[0]);
            shape.y = Std.parseFloat(nums[1]);
            shape.width = Std.parseFloat(nums[2]);
            shape.height = Std.parseFloat(nums[3]);
        }
    }

    private function loadDiagramMetadata(dict: PList) {
        var info = findDict(dict, ["UserInfo"]);
        if(info == null) return;

        loadMetadataArray(info, "kMDItemAuthors", diagram.authors);
        loadMetadataArray(info, "kMDItemKeywords", diagram.keywords);
        loadMetadataArray(info, "kMDItemLanguages", diagram.languages);
        loadMetadataArray(info, "kMDItemOrganizations", diagram.organizations);
        loadMetadataArray(info, "kMDItemProjects", diagram.projects);

        diagram.comments    = loadMetadataValue(info, "kMDItemComments");
        diagram.copyright   = loadMetadataValue(info, "kMDItemCopyright");
        diagram.description = loadMetadataValue(info, "kMDItemDescription");
        diagram.subject     = loadMetadataValue(info, "kMDItemSubject");
        diagram.version     = loadMetadataValue(info, "kMDItemVersion");
    }

    private function loadMetadataValue(dict: PList, key: String): Null<String> {
        var entry = dict[key];
        if(entry == null) return null;
        return switch(entry) {
            case PListString(s): s;
            default: null;
        }
    }

    private function loadMetadataArray(dict: PList, key: String, target: Array<String> ) {
        var entry = dict[key];
        if(entry == null) return;
        switch(entry) {
            case PListArray(array): for(e in array) switch(e) {
                                                        case PListString(s): target.push(s);
                                                        default:
                                                    };
            default:
        }
    }

    // chase a list of keys down through nested dicts to find a string
    private function findString(dict: PList, keys: Array<String>): Null<String> {
        var entry = chaseKeys(dict, keys);
        if(entry == null) return null;
        return switch(entry) {
            case PListString(s): s;
            default: null;
        }
    }

    // chase a list of keys down through nested dicts to find an int (default zero)
    private function findInt(dict: PList, keys: Array<String>): Int {
        var entry = chaseKeys(dict, keys);
        if(entry == null) return 0;
        return switch(entry) {
            case PListInteger(i): i;
            default: 0;
        }
    }

    // chase a list of keys down through nested dicts to find a dict
    private function findDict(dict: PList, keys: Array<String>): Null<PList> {
        var entry = chaseKeys(dict, keys);
        if(entry == null) return null;
        return switch(entry) {
            case PListDict(d): d;
            default: null;
        }
    }

    // chase a list of keys down through nested dicts to find an array
    private function findArray(dict: PList, keys: Array<String>): Null<Array<PListEntry>> {
        var entry = chaseKeys(dict, keys);
        if(entry == null) return null;
        return switch(entry) {
            case PListArray(a): a;
            default: null;
        }
    }

    // chase a list of keys down through nested dicts
    private function chaseKeys(dict: PList, keys: Array<String>): Null<PListEntry> {
        var currDict = dict;
        var value: PListEntry = null;

        for(key in keys) {
            if( currDict == null ) return null;  //ran out of nested dicts
            value = currDict[key];
            if( value == null ) return null;

            currDict = switch(value) {
                case PListDict(d): d;
                default: null;
            }
        }

        return value;
    }
}
