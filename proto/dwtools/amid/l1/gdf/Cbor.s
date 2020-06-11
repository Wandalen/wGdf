( function _Cbor_s_()
{

'use strict';

/**
 * @file EncoderStrategyStandanrd.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../../dwtools/Tools.s' );

}

let _global = _global_;
let _ = _global_.wTools;
let Self = _global_.wTools;

// --
// cbor
// --

let Cbor, CborPath;
try
{
  CborPath = require.resolve( 'cbor' );
}
catch( err )
{
}

let cborSupported =
{
  primitive : 3,
  regexp : 1,
  buffer : 1,
  structure : 2
}

let readCbor = null;
if( CborPath )
readCbor =
{

  ext : [ 'cbor' ],
  in : [ 'buffer.node' ],
  out : [ 'structure' ],

  supporting : cborSupported,

  onEncode : function( op )
  {

    if( !Cbor )
    Cbor = require( CborPath );

    _.assert( _.bufferNodeIs( op.in.data ) );
    op.out.data = Cbor.decodeFirstSync( op.in.data, { bigint : true } );
    op.out.format = 'structure';
  },

}

let writeCbor = null;
if( CborPath )
writeCbor =
{

  ext : [ 'cbor' ],
  in : [ 'structure' ],
  out : [ 'buffer.node' ],

  supporting : cborSupported,

  onEncode : function( op )
  {

    if( !Cbor )
    Cbor = require( CborPath );

    _.assert( _.mapIs( op.in.data ) );

    let encoder = new Cbor.Encoder({ highWaterMark : 1 << 30 });
    encoder.write( op.in.data );
    op.out.data = encoder.read();

    _.assert( _.bufferNodeIs( op.out.data ) );

    op.out.format = 'buffer.node';
  },

}

// --
// declare
// --

var Extend =
{

}

Self = _.encode = _.encode || Object.create( null );
_.mapExtend( _.encode, Extend );

// --
// register
// --

_.Gdf([ readCbor, writeCbor ]);

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
