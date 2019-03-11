# Perfomance

The test used three structures of different size: 1kb, 1Mb, 100Mb. Each structure consists of JSON-compatible data types, nested maps and arrays.
Depth and breadth of the structure increase with size.

### 1Kb

    ┌───────────────┬───────────────┬───────────────┬───────────────┐
    │   Converter   │   Out size    │  Write time   │   Read time   │
    ├───────────────┼───────────────┼───────────────┼───────────────┤
    │     bson      │    1.4 kb     │    0.001s     │    0.003s     │
    │   json.fine   │    1.2 kb     │    0.005s     │    0.000s     │
    │     json      │    714.0 b    │    0.000s     │    0.000s     │
    │     cson      │    1.4 kb     │    0.026s     │    0.017s     │
    │      js       │    1.2 kb     │    0.002s     │    0.001s     │
    │     cbor      │    458.0 b    │    0.005s     │    0.002s     │
    │      yml      │    972.0 b    │    0.001s     │    0.002s     │
    │  msgpack.lite │    460.0 b    │    0.001s     │    0.001s     │
    │  msgpack.wtp  │    460.0 b    │    0.029s     │    0.001s     │
    └───────────────┴───────────────┴───────────────┴───────────────┘

### 1Mb

    ┌───────────────┬───────────────┬───────────────┬───────────────┐
    │   Converter   │   Out size    │  Write time   │   Read time   │
    ├───────────────┼───────────────┼───────────────┼───────────────┤
    │     bson      │    1.3 Mb     │    0.065s     │    0.066s     │
    │   json.fine   │    1.9 Mb     │    0.960s     │    0.010s     │
    │     json      │   663.1 kb    │    0.009s     │    0.008s     │
    │     cson      │    4.0 Mb     │    4.228s     │    8.747s     │
    │      js       │    1.9 Mb     │    0.597s     │    0.045s     │
    │     cbor      │   426.9 kb    │    0.143s     │    0.141s     │
    │      yml      │   765.4 kb    │    0.064s     │    0.051s     │
    │  msgpack.lite │   428.7 kb    │    0.025s     │    0.032s     │
    │  msgpack.wtp  │   428.7 kb    │    0.039s     │    0.025s     │
    └───────────────┴───────────────┴───────────────┴───────────────┘

### 100Mb

    ┌───────────────┬───────────────┬───────────────┬───────────────┐
    │   Converter   │   Out size    │  Write time   │   Read time   │
    ├───────────────┼───────────────┼───────────────┼───────────────┤
    │     bson      │   110.3 Mb    │    5.375s     │    2.521s     │
    │   json.fine   │   643.2 Mb    │    88.777s    │    1.363s     │
    │     json      │    57.1 Mb    │    0.713s     │    0.783s     |
    |     cson      │    Timeout    │    Timeout    │    Timeout    │
    │      js       │   643.2 Mb    │    53.193s    │    7.302s     │
    │     cbor      │   36.8 Mb     │    9.278s     │    10.639s    │
    │      yml      │   270.4 Mb    │    48.830s    │    2.417s     │
    │  msgpack.lite │    36.9 Mb    │    1.137s     │    2.122s     │
    │  msgpack.wtp  │    36.9 Mb    │    0.520s     │    1.126s     │
    └───────────────┴───────────────┴───────────────┴───────────────┘

> "Out size" - size of the encoded data.

> "Write time" - encoding time.

> "Read time" - decoding time.