module main;

import std.stdio;

import mirRandom;

import jsonExamples;

void main()
{
    writeln("mir.random and mir.random.variable examples");
    // Default arguments are mean=0.0 and stdDev=1.0.
    auto RANDOS = getNormalVarRange();
    foreach (_; 0..5)
    {
        RANDOS.front.writeln;
        RANDOS.popFront();
    }

    writefln("\nJSON examples");
    demoJson();
}
