if( typeof module !== 'undefined' )
require( 'wgdf' );
let _ = wTools;

/* select encoder */

var serialize = _.gdf.select({ inFormat : 'structure', ext : 'bson' })[ 0 ];

/* select decoder */

var deserialize = _.gdf.select({ inFormat : 'buffer.node', ext : 'bson' })[ 0 ];

/* encode */

var structure = { field : 'value' };
var serialized =  serialize.encode({ data : structure });

console.log( serialized.out.data );

//<Buffer 16 00 00 00 02 66 69 65 6c 64 00 06 00 00 00 76 61 6c 75 65 00 00>

/* decode */

var deserialized = deserialize.encode({ data : serialized.out.data });

console.log( deserialized.out.data );

//{ field: 'value' }
