module app.mirRandom;

import mir.random;
import mir.random.variable;
import mir.random.algorithm: range;


auto getNormalVarRange(double mean=0.0, double stdDev=1.0)
{
    return normalVar(mean, stdDev).range;
}
