if( typeof module !== 'undefined' )
require( 'wgdf' );
var _ = wTools;

/* select encoder */

var serialize = _.Gdf.Select({ in : 'structure', ext : 'bson' });
serialize = serialize[ 0 ];

/* select decoder */

var deserialize = _.Gdf.Select({ in : 'buffer.node', ext : 'bson' });
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

