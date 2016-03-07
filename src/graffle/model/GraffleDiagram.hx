package graffle.model;

/**
  Root of an Omnigraffle diagram
**/
class GraffleDiagram {

    public var authors: Array<String> = [];
    public var keywords: Array<String> = [];
    public var languages: Array<String> = [];
    public var organizations: Array<String> = [];
    public var projects: Array<String> = [];

    public var comments: Null<String>;
    public var copyright: Null<String>;
    public var description: Null<String>;
    public var subject: Null<String>;
    public var version: Null<String>;

    public var sheets: Array<GraffleSheet> = [];

    public function new() {}
}
