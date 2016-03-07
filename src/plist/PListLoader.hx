package plist;

import plist.PList;
using  StringTools;

class PListLoader {

    public static function loadFile(filePath: String): PList {
        var fileText = sys.io.File.getContent(filePath);
        var xml = Xml.parse(fileText);
        return loadXml(xml, 'file: $filePath');
    }

    public static function loadXml(xml: Xml, context: String = "<unknown>"): PList {
        var plist = new PList();

        var elem = xml.firstElement();
        if( elem.nodeName != "plist") throw 'xml does not start with <plist> in $context';
        elem = elem.firstElement();
        if( elem.nodeName != "dict") throw 'plist content is not a <dict> in $context';

        loadDict(elem, plist, context);
        return plist;
    }

    private static function loadDict(elem: Xml, dict: Map<String,PListEntry>, context: String) {
        var elems = elem.elements();

        while(elems.hasNext()) {
            var keyElem = elems.next();
            if( keyElem.nodeName != "key") throw 'expected <key> but found <${keyElem.nodeName}> in $context';

            var key = keyElem.firstChild().nodeValue;

            if( ! elems.hasNext()) throw 'expected value for key $key in $context';
            var valueElem = elems.next();
            dict[key] = readValue(valueElem, context);
        }
    }

    private static function readValue(elem: Xml, context: String): PListEntry {
        return switch(elem.nodeName) {
            case "dict": readDict(elem, context);
            case "integer": PListInteger(Std.parseInt(elem.firstChild().nodeValue));
            case "real": PListReal(Std.parseFloat(elem.firstChild().nodeValue));
            case "string": PListString(unRTF(elem.firstChild().nodeValue));
            case "array": readArray(elem, context);
            case "false": PListBoolean(false);
            case "true": PListBoolean(true);
            default: PListString('Unknown PLIST value type ${elem.nodeName}');
        }
    }

    private static function readArray(elem: Xml, context: String): PListEntry {
        var array = new Array<PListEntry>();
        for(e in elem.elements()) {
            array.push(readValue(e, context));
        }
        return PListArray(array);
    }

    private static function readDict(elem: Xml, context: String): PListEntry {
        var dict = new Map<String,PListEntry>();
        loadDict(elem, dict, context);
        return PListDict(dict);
    }

    // convert RTF text to plain
    private static function unRTF(text: String): String {
        if( text == null ) return null;
        if(! text.startsWith("{\\rtf")) return text;

        text = ~/{\\fonttbl.*}/g.replace(text, ""); //font tables are a problem - just nuke them

        var s = "";
        var state = 1; //1=gathering text, 2=first backslash, 3=skip control-code, 4=skip whitespace

        for(i in 0...text.length) {
            var c = text.charAt(i);

            switch(state) {
                case 1: switch(c) {
                            case "\\": state = 2;
                            case "{" | "}": state = 1; // skip
                            case " " | "\n": state = 4;
                            default: s += c;  //gather text
                        }
                case 2: switch(c) {
                            case "\\": { s += "\\"; state = 1; } // escaped backslash
                            case "{" | "}": { s += c; state = 1; } // escaped brace
                            case " " | "\n": state = 4;
                            default: state = 3;  //start of control-code
                        }
                case 3: switch(c) {
                            case " " | "\n" | "{" | "}": state = 4;
                            default: state = 3;  //still skipping control code
                        }
                case 4: switch(c) {
                            case " " | "\n" | "{" | "}": state = 4;
                            case "\\": state = 2;
                            default: { s += " " + c; state = 1; } //first text char
                        }

                default:
            }
        }

        return s.trim();
    }
}
