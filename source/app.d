module app.main;

import std.stdio;

import app.mirRandom;


void main()
{
    // Default arguments are mean=0.0 and stdDev=1.0.
    auto RANDOS = getNormalVarRange();
    foreach (_; 0..5)
    {
        RANDOS.front.writeln;
        RANDOS.popFront();
    }
}
