package graffle;

/**
 Loads Omnigraffle documents
**/
import plist.PList;
import graffle.model.GraffleDiagram;
class GraffleLoader {

    //TODO: handle graffle files that are folders
    //TODO: handle compressed graffle files

    public var diagram = new GraffleDiagram();

    public function new() {}

    public function loadFromPList(plist: PList) {
        loadDiagramMetadata(plist);
    }

    private function loadDiagramMetadata(dict: PList) {
        var userInfo = dict["UserInfo"];
        if(userInfo == null) return;
        switch(userInfo) {
            case PListDict(info): {
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

            default:
        }
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
}
