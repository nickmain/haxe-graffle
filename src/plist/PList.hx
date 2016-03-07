package plist;

enum PListEntry {
    PListDict(map: Map<String,PListEntry>);
    PListArray(array: Array<PListEntry>);
    PListReal(value: Float);
    PListInteger(value: Int);
    PListString(value: String);
    PListBoolean(value: Bool);
}

typedef PList = Map<String,PListEntry>;

