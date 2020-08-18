( function _Bson_s_()
{

'use strict';

let _global = _global_;
let _ = _global_.wTools;
let Self = _global_.wTools;

// --
// bson
// --

let Bson, BsonPath;
try
{
  BsonPath = require.resolve( 'bson' );
}
catch( err )
{
}

let bsonSupported =
{
  primitive : 2,
  regexp : 2,
  buffer : 0,
  structure : 2
}

let readBson = null;
if( BsonPath )
readBson =
{

  ext : [ 'bson' ],
  inFormat : [ 'buffer.node' ],
  outFormat : [ 'structure' ],

  feature : bsonSupported,

  onEncode : function( op )
  {
    if( !Bson )
    {
      Bson = require( BsonPath );
      Bson.setInternalBufferSize( 1 << 30 );
    }
    _.assert( _.bufferAnyIs( op.in.data ), 'Expects buffer' );
    op.in.data = _.bufferNodeFrom( op.in.data );
    op.out.data = Bson.deserialize( op.in.data );
    op.out.format = 'structure';
  },

}

let writeBson = null;
if( BsonPath )
writeBson =
{

  ext : [ 'bson' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'buffer.node' ],

  feature : bsonSupported,

  onEncode : function( op )
  {

    if( !Bson )
    {
      Bson = require( BsonPath );
      Bson.setInternalBufferSize( 1 << 30 );
    }

    _.assert( _.mapIs( op.in.data ) );
    op.out.data = Bson.serialize( op.in.data );
    op.out.format = 'buffer.node';
  },

}

// --
// declare
// --

var Extension =
{

}

Self = _.encode = _.encode || Object.create( null );
_.mapExtend( _.encode, Extension );

// --
// register
// --

_.Gdf([ readBson, writeBson ]);

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
