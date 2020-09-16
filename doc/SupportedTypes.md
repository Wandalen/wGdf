# Levels of Support of Types

      ┌────────────────────┬────────────────────┬────────────────────┬────────────────────┬────────────────────┐
      │    Transformer     │   Primitive(0-3)   │    RegExp(0-2)     │    Buffer(0-3)     │   Structure(0-3)   │
      ├────────────────────┼────────────────────┼────────────────────┼────────────────────┼────────────────────┤
      │        bson        │         2          │         2          │         0          │         2          │
      │     json.fine      │         1          │         0          │         0          │         2          │
      │        json        │         1          │         0          │         0          │         2          │
      │        cson        │         1          │         2          │         3          │         2          │
      │         js         │         3          │         2          │         3          │         2          │
      │        cbor        │         3          │         1          │         1          │         2          │
      │        yml         │         2          │         2          │         1          │         3          │
      │    msgpack.lite    │         2          │         2          │         3          │         2          │
      └────────────────────┴────────────────────┴────────────────────┴────────────────────┴────────────────────┘

Primitive:
*   1 - boolean,number,string
*   2 - null,Infinity,NaN
*   3 - +0,-0,undefined,Date,BigInt

RegExp:
*   1 - simple regexps without flags
*   2 - complex regexps with flags

Buffer: ArrayBuffer, TypedBuffer, NodeBuffer
*   1 - at least one type of buffer
*   2 - at least ArrayBuffer
*   3 - all types of buffer

Complex:
*   1 - simple maps and arrays
*   2 - multilevel maps and arrays
*   3 - recursion in maps
