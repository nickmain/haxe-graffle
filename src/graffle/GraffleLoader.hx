package graffle;

import graffle.model.GraffleLine.LineLabel;
import graffle.model.GraffleGraphic;
import graffle.model.GraffleLine;
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

    private var labels: Array<LineLabel> = []; //for wiring up labels

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
        wireUpLabels(sheet);

        diagram.sheets.push(sheet);
    }

    private function loadGraphics(graphics: Array<PListEntry>, sheet: GraffleSheet, group: GraffleGroup) {
        for(g in graphics) switch(g) {
            case PListDict(d): loadGraphic(d, sheet, group);
            default: throw "wtf?";
        }
    }

    private function wireUpLabels(sheet: GraffleSheet) {
        for(label in labels) {
            var line: GraffleLine = cast sheet.graphics.get(label.lineId);
            line.labels.push(label);
        }
        labels = [];
    }

    private function loadGraphic(dict: PList, sheet: GraffleSheet, group: GraffleGroup) {
        var type = findString(dict, ["Class"]);
        if(type == null) type = "ShapedGraphic";

        var g: GraffleGraphic = switch(type) {
            case "ShapedGraphic": new GraffleShape();
            case "LineGraphic": new GraffleLine();
            case "Group" | "TableGroup": new GraffleGroup();
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
            case "LineGraphic": loadLine(dict, cast g);
            case "Group": loadGroup(dict, cast g, sheet);
            case "TableGroup": {
                var group: GraffleGroup = cast g;
                loadGroup(dict, group, sheet);
                group.isTable = true;
            }
            default:
        }
    }

    private function loadGroup(dict: PList, group: GraffleGroup, sheet: GraffleSheet) {
        var graphics = findArray(dict, ["Graphics"]);
        loadGraphics(graphics, sheet, group);

        var isSubgraph = findBool(dict, ["isSubgraph"]);
        if(isSubgraph) {
            group.background = cast group.children.pop();
        }
    }

    private function loadLine(dict: PList, line: GraffleLine) {
        line.dashed = findInt(dict, ["Style", "stroke", "Pattern"]) > 0;
        line.headArrow = findString(dict, ["Style", "stroke", "HeadArrow"]);
        line.tailArrow = findString(dict, ["Style", "stroke", "TailArrow"]);
        line.headId = findInt(dict, ["Head", "ID"], -1);
        line.tailId = findInt(dict, ["Tail", "ID"], -1);
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

        var fill = findDict(dict, ["Style", "fill", "Color"]);
        if(fill != null) {
            shape.fill = {
                r: findFloat(fill, ["r"], 0.0),
                g: findFloat(fill, ["g"], 0.0),
                b: findFloat(fill, ["b"], 0.0),
                a: findFloat(fill, ["a"], 1.0)
            };
        }
        else {
            if(findString(dict, ["Style", "fill", "Draws"]) != "NO") {
                // default fill
                shape.fill = { r: 1.0, g: 1.0, b: 1.0, a: 1.0 };
            }
        }

        var labelLine = findDict(dict, ["Line"]);
        if(labelLine != null) {
            var label = {
                lineId: findInt(labelLine, ["ID"]),
                shape: shape,
                position: findFloat(labelLine, ["Position"])
            };

            shape.label = label;
            labels.push(label);
        }

        // connector shapes
        shape.headId = findInt(dict, ["Head", "ID"], -1);
        shape.tailId = findInt(dict, ["Tail", "ID"], -1);
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
    private function findInt(dict: PList, keys: Array<String>, defaultValue: Int = 0): Int {
        var entry = chaseKeys(dict, keys);
        if(entry == null) return defaultValue;
        return switch(entry) {
            case PListInteger(i): i;
            default: defaultValue;
        }
    }

    // chase a list of keys down through nested dicts to find a float (default zero)
    private function findFloat(dict: PList, keys: Array<String>, defaultValue: Float = 0.0): Float {
        var entry = chaseKeys(dict, keys);
        if(entry == null) return defaultValue;
        return switch(entry) {
            case PListReal(f): f;
            default: defaultValue;
        }
    }

    // chase a list of keys down through nested dicts to find a float (default zero)
    private function findBool(dict: PList, keys: Array<String>, defaultValue: Bool = false): Bool {
        var entry = chaseKeys(dict, keys);
        if(entry == null) return defaultValue;
        return switch(entry) {
            case PListBoolean(b): b;
            default: defaultValue;
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
