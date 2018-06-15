module jsonExamples;

import std.algorithm: map;
import std.conv;
import std.container.slist;
import std.range;
import std.stdio;
import std.json;

import mir.random: randIndex;
import mir.random.variable: normalVar, uniformVar;
import mir.random.algorithm: range;

import vibe.d;

void demoJson() 
{
    auto jsonText = "{\"hello\": \"world\", \"yomama\": [\"sofat\", \"she\", \"walked\", \"...\"]}";
    writeln("Here's the JSON text: ", jsonText);

    JSONValue j = parseJSON(jsonText);
    j["yomama"] = "is great.";

    writeln("Check yo mama now: ", j);

    writefln("\nNow to create new JSON and print it out:");

    JSONValue jj = ["metadata": "", "data": ""];
    
    Metadata metadata;
    metadata.policy = Policy.TWO;
    metadata.policyParameters = defaultPolicyParams();
    jj.object["metadata"] = metadata.toJSON();
    writeln(jj.toString);

    .writeln;
    auto fakeData = makeFakeData();
    fakeData.writeln;

    "\nNow serializing a struct using vibe.d".writefln;
    fakeData.serializeToJsonString.writeln; 
}


alias JSONValue JV;

const size_t N_ITER = 1e4.to!size_t;
struct TimeseriesData
{
    Metadata metadata;
    /* SList!TimestepData data; */
    TimestepData[] data;
}


double[string] defaultPolicyParams() { return ["beta": 0.0, "rho": 0.0]; }
struct Metadata
{
    double baseRate = 1.0;
    Policy policy;
    double[string] policyParameters;

    JSONValue toJSON() 
    {
        // Seems this is how to initialize? Vals can't be different types in D.
        JSONValue jj = ["baseRate": 0.0, "policy": 0.0];
        jj.object["baseRate"] = baseRate;
        jj.object["policy"] = policy.to!string;
        jj.object["policyParameters"] = policyParameters;
        return jj;
    }
}


const size_t N = 100;
struct TimestepData 
{
    size_t t;
    double[N] falsePositiveRate;
    size_t[N] nPublications;
    double[N] funds;
}

private TimeseriesData makeFakeData()
{
    // A single timestep's data used in foreach.
    TimestepData data;
    // Singly-linked list of single-timestep data to be TimeseriesData.data
    TimestepData[] allData;
    allData.length = 2;
    // Metadata on parameters for full timeseries data.
    Metadata md;
    // The full timeseries data that will include metadata.
    TimeseriesData tsData;

    auto uniformVarRange = uniformVar(0.0, 1.0).range;
    auto normalVarRange = normalVar(0.0, 1.0).range;
    /* auto randIndexRange = randIndex(10U).range; */
    foreach (t; 0..2)  // N_ITER)
    {
        data.t = t;
        data.falsePositiveRate = uniformVarRange.take(N).array;
        data.nPublications = iota(N).map!(_ => randIndex(10UL)).array;
        data.funds = 
            normalVarRange
                .take(N)
                .map!(epsilon => (3*epsilon) + 30)
                .array;

        allData[t] = data;
    }

    tsData.metadata = md;

    // insertFront has been putting later data points first: reverse order
    /* allData.reverse(); */
    tsData.data = allData;

    return tsData;
}


enum Policy {ONE, TWO, THREE};
