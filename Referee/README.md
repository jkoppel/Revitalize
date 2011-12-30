##What it is

It's much easier to reverse-engineer a structure when you can find every place its members are used. If you wish to reengineer the binary and modify a structure, finding every use is essential. Referee makes both of these tasks easier by marking accesses of structures in decompiled functions.

##Requirements

 * IDA 6.2 or higher
 * Hex-Rays Decompiler 1.6 or higher

##Installation

Drag the compiled plugin into the IDA "plugins" folder

##Usage

Referee will automatically run whenever a function is decompiled. It is recommended that you decompile the entire binary for maximum information.

##Notes

 * If you annotate a function to remove a struct-member usage, decompiling the function again will remove the corresponding xrefs.

 * Referee only tracks accesses to structure members, not pointer-passing. Writes and references to structure members are also marked as reads.

 * Since there is no easy way to map a decompiled expression back to a corresponding location in the assembly, Referee creates all xrefs from the start of the function.