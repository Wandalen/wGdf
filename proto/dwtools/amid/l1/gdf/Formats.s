(function _Formats_s_()
{

'use strict';

/**
 * @file EncoderStrategyStandanrd.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../../dwtools/Tools.s' );
  require( './Bson.s' );
  require( './Cbor.s' );
  require( './Coffee.s' );
  require( './JsStructure.s' );
  require( './Json.s' );
  require( './MsgpackLiteWtp.s' );
  require( './Yml.s' );
  require( './Base64.s' );
}

/*
qqq : make it working
qqq : use algorithms from wGraphBasic to find shortest path
qqq : introduce field cost
let encoder = _.Gdf.Select
({
  in : 'buffer.raw',
  out : 'structure',
  ext : 'yml',
})[ 0 ];
let structure = encoder.encode( bufferRaw );
*/

let _global = _global_;
let _ = _global_.wTools;
let Self = _global_.wTools;

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


// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
