# Supported types

      ┌────────────────────┬────────────────────┬────────────────────┬────────────────────┬────────────────────┐
      │    Transformer     │   Primitive(0-3)   │    RegExp(0-2)     │    Buffer(0-3)     │    Complex(0-2)    │
      ├────────────────────┼────────────────────┼────────────────────┼────────────────────┼────────────────────┤
      │        bson        │         2          │         2          │         0          │         1          │
      │     json.fine      │         1          │         0          │         0          │         1          │
      │        json        │         1          │         0          │         0          │         1          │
      │        cson        │         1          │         2          │         2          │         1          │
      │         js         │         3          │         2          │         2          │         1          │
      │        cbor        │         3          │         1          │         1          │         1          │
      │        yml         │         3          │         2          │         1          │         2          │
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
*   1 - multilevel maps and arrays
*   2 - recursion in maps
