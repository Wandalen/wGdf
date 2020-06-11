( function _Json_s_()
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
// json
// --

let jsonSupported =
{
  primitive : 1,
  regexp : 0,
  buffer : 0,
  structure : 2
}

let readJson =
{

  ext : [ 'json' ],
  in : [ 'string' ],
  out : [ 'structure' ],

  supporting : jsonSupported,

  onEncode : function( op )
  {

    /*

qqq : could throw different errors
cover them all please

SyntaxError: Unexpected end of JSON input
    at JSON.parse (<anonymous>:null:null)
    at wGenericDataFormatConverter.onEncode (C:\pro\web\Dave\git\trunk\builder\include\dwtools\abase\l8\GdfFormats.s:59:26)
    at wGenericDataFormatConverter.encode_body (C:\pro\web\Dave\git\trunk\builder\include\dwtools\abase\l8\Converter.s:238:13)
    at Proxy.encode_body (C:\pro\web\Dave\git\trunk\builder\include\dwtools\abase\l8\GdfCurrent.s:59:45)

*/
    try
    {
      op.out.data = JSON.parse( op.in.data );
    }
    catch( err )
    {
      let src = op.in.data;
      let position = /at position (\d+)/.exec( err.message );
      if( position )
      position = Number( position[ 1 ] );
      let first = 0;
      if( _.numberDefined( position ) && position >= 0 )
      {
        let nearest = _.strLinesNearest( src, position );
        first = _.strLinesCount( src.substring( 0, nearest.spans[ 0 ] ) );
        src = nearest.splits.join( '' );
      }
      let err2 = _.err( 'Error parsing JSON\n', err, '\n', _.strLinesNumber( src, first ) );
      throw err2;
    }

    // op.out.data = _.jsonParse( op.in.data );
    op.out.format = 'structure';

  },

}

let writeJsonMin =
{
  default : 1,
  ext : [ 'json.min', 'json' ],
  shortName : 'json.min',
  in : [ 'structure' ],
  out : [ 'string' ],

  supporting : jsonSupported,

  onEncode : function( op )
  {
    op.out.data = JSON.stringify( op.in.data );
    op.out.format = 'string';
  }

}

let writeJsonFine =
{

  shortName : 'json.fine',
  ext : [ 'json.fine', 'json' ],
  in : [ 'structure' ],
  out : [ 'string' ],

  supporting : jsonSupported,

  onEncode : function( op )
  {
    op.out.data = _.cloneData({ src : op.in.data });
    op.out.data = _.toJson( op.out.data, { cloning : 0 } );
    op.out.format = 'string';
  }

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

_.Gdf( [ readJson, writeJsonMin, writeJsonFine ] );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
