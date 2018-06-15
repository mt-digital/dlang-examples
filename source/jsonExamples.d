module jsonExamples;

import std.stdio;
import std.json;

void demoJson() 
{
    auto jsonText = "{\"hello\": \"world\", \"yomama\": [\"sofat\", \"she\", \"walked\", \"...\"]}";
    writeln("Here's the JSON text: ", jsonText);

    JSONValue j = parseJSON(jsonText);
    j["yomama"] = "is great.";

    writeln("Check yo mama now: ", j);
}
