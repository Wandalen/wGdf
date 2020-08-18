
# module::Gdf  [![status](https://github.com/Wandalen/wGdf/workflows/publish/badge.svg)](https://github.com/Wandalen/wGdf/actions?query=workflow%3Apublish) [![stable](https://img.shields.io/badge/stability-stable-green.svg)](https://github.com/emersion/stability-badges#stable)

Standardized abstract interface and collection of strategies to convert complex data structures from one generic data format ( GDF ) to another generic data format. You may use the module to serialize complex data structure to string or deserialize string back to the original data structure. Generic data format ( GDF ) is a format of data structure designed with taking into account none unique feature of data so that it is applicable to any kind of data.

## Try out from the repository
```
git clone https://github.com/Wandalen/wGdf
cd wGdf
npm install
node sample/Sample.s
```

## To add to your project
```
npm add 'wgdf@alpha'
```

## Usage:

##### Example #1
```javascript
/* How to convert data using bson format */

/* select encoder */

var serialize = _.gdf.select({ in : 'structure', ext : 'bson' });
serialize = serialize[ 0 ];

/* select decoder */

var deserialize = _.gdf.select({ in : 'buffer.node', ext : 'bson' });
deserialize = deserialize[ 0 ];

/* encode */

var structure = { field : 'value' };
var serialized =  serialize.encode({ data : structure });

console.log( serialized.data );

//<Buffer 16 00 00 00 02 66 69 65 6c 64 00 06 00 00 00 76 61 6c 75 65 00 00>

/* decode */

var deserialized = deserialize.encode({ data : serialized.data });

console.log( deserialized.data );

//{ field: 'value' }
```

## Benchmarks

### 1Mb Structure:

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

 [ More details about converters perfomance. ]( doc/Perfomance.md )

## Level of Support of Types

Information about level of support of each data type by each converter an be found [here.]( doc/SupportedTypes.md )
