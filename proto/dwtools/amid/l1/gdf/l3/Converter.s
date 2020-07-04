(function _Converter_s_()
{

'use strict';

// if( typeof module !== 'undefined' )
// {
//
//   let _ = require( '../../../../dwtools/Tools.s' );
//
//   _.include( 'wCopyable' );
//   _.include( 'wRoutineBasic' );
//
// }

/**
 * @classdesc Class to operate the GDF converter.
 * @class wGenericDataFormatConverter
 * @namespace Tools
 * @module Tools/mid/Gdf
 */

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = wGenericDataFormatConverter;
function wGenericDataFormatConverter( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Gdf';

// --
// routine
// --

function finit()
{
  let converter = this;
  converter.unform();
  return _.Copyable.prototype.finit.apply( converter, arguments );
}

//

function init( o )
{
  let converter = this;

  _.assert( arguments.length === 1 );

  _.workpiece.initFields( converter );
  Object.preventExtensions( converter );

  if( o )
  converter.copy( o );

  converter.form();
  return converter;
}

//

function unform()
{
  let converter = this;

  _.arrayRemoveOnceStrictly( _.gdf.convertersArray, converter );

  converter.in.forEach( ( e, k ) =>
  {
    _.arrayRemoveOnceStrictly( _.gdf.inMap[ e ], converter );
  });

  converter.out.forEach( ( e, k ) =>
  {
    _.arrayRemoveOnceStrictly( _.gdf.outMap[ e ], converter );
  });

  converter.ext.forEach( ( e, k ) =>
  {
    _.arrayRemoveOnceStrictly( _.gdf.extMap[ e ], converter );
  });

  converter.inOut.forEach( ( e, k ) =>
  {
    _.arrayRemoveOnceStrictly( _.gdf.inOutMap[ e ], converter );
  });

}

//

/**
 * @summary Registers current converter.
 * @description
 * Checks descriptor of current converter and it into maps: InMap, OutMap, ExtMap, InOutMap.
 * Generates name for converter if its not specified explicitly.
 * @method form
 * @class wGenericDataFormatConverter
 * @namespace Tools
 * @module Tools/mid/Gdf
 */

function form()
{
  let converter = this;

  _.assert( converter.inOut === null );

  converter.in = _.arrayAs( converter.in );
  converter.out = _.arrayAs( converter.out );
  converter.ext = _.arrayAs( converter.ext );

  if( converter.name === null )
  converter.name = ( converter.ext[ 0 ] ? converter.ext[ 0 ] + '-' : '' ) + converter.in[ 0 ] + '->' + converter.out[ 0 ];

  /* - */

  _.arrayAppendOnceStrictly( _.gdf.convertersArray, converter );

  converter.in.forEach( ( e, k ) =>
  {
    _.gdf.inMap[ e ] = _.arrayAppend( _.gdf.inMap[ e ] || null, converter );
  });

  converter.out.forEach( ( e, k ) =>
  {
    _.gdf.outMap[ e ] = _.arrayAppend( _.gdf.outMap[ e ] || null, converter );
  });

  converter.ext.forEach( ( e, k ) =>
  {
    _.gdf.extMap[ e ] = _.arrayAppend( _.gdf.extMap[ e ] || null, converter );
  });

  let inOut = _.eachSample([ converter.in, converter.out ]);
  converter.inOut = [];
  inOut.forEach( ( inOut ) =>
  {
    let key = inOut.join( '-' );
    converter.inOut.push( key );
    _.gdf.inOutMap[ key ] = _.arrayAppend( _.gdf.inOutMap[ key ] || null, converter );
  });

  /* - */

  _.assert( _.strIs( converter.name ) );
  _.assert( _.strsAreAll( converter.in ) );
  _.assert( _.strsAreAll( converter.out ) );
  _.assert( _.strsAreAll( converter.ext ) );

  _.assert( converter.in.length >= 1 );
  _.assert( converter.out.length >= 1 );
  _.assert( converter.ext.length >= 0 );

  _.assert( _.routineIs( converter._encode ) );

}

//

/**
 * @summary Encodes source data from one specific format to another.
 * @description
 * Possible in/out formats are determined by converter.
 * Use {@link module:Tools/mid/Gdf.gdf.select select} routine to find converter for your needs.
 * @param {Object} o Options map
 *
 * @param {*} o.data Source data.
 * @param {String} o.format Format of source `o.data`.
 * @param {Object} o.secondary Map with enviroment variables that will be used by converter.
 *
 * @example
 * //returns converters that accept string as input
 * let converters = _.gdf.select({ in : 'string', out : 'structure', ext : 'cson', default : 1 });
 * let src = 'val : 13';
 * let dst = converters[ 0 ]._encode({ data : src, format : 'string' });
 * console.log( dst.data ); //{ val : 13 }
 *
 * @returns {Object} Returns map with properties: `data` - result of encoding and `format` : format of the result.
 * @method _encode
 * @class wGenericDataFormatConverter
 * @namespace Tools
 * @module Tools/mid/Gdf
 */

function encode_pre( routine, args )
{
  let converter = this;
  let o = args[ 0 ];

  _.assert( arguments.length === 2 );
  _.routineOptions( routine, o );

  return o;
}

//

function _encode( o )
{
  let converter = this;

  _.assertRoutineOptions( _encode, arguments );

  /* */

  let op = Object.create( null );

  op.secondary = o.secondary || Object.create( null );

  op.in = Object.create( null );
  op.in.data = o.data;
  op.in.format = o.format || converter.in;
  if( _.arrayIs( op.in.format ) )
  op.in.format = op.in.format.length === 1 ? op.in.format[ 0 ] : undefined;

  op.out = Object.create( null );
  op.out.data = undefined;
  op.out.format = undefined;

  /* */

  try
  {

    _.assert( _.objectIs( op.secondary ) )
    _.assert( _.strIs( op.in.format ), 'Not clear which input format is' );
    _.assert( _.longHas( converter.in, op.in.format ), () => 'Unknown format ' + op.in.format );

    converter.onEncode( op );

    op.out.format = op.out.format || converter.out;
    if( _.arrayIs( op.out.format ) )
    op.out.format = op.out.format.length === 1 ? op.out.format[ 0 ] : undefined;

    _.assert( _.strIs( op.out.format ), 'Output should have format' );
    _.assert( _.longHas( converter.out, op.out.format ), () => 'Strange output format ' + o.out.format );

  }
  catch( err )
  {
    let outFormat = op.out.format || converter.out;
    // op.out.format = undefined; /* qqq : ? */
    // let fileStr = op.secondary && op.secondary.filePath ? '\n  ' + op.secondary.filePath : '';
    throw _.err
    (
       err
      ,`\nFailed to convert from "${op.in.format}" to "${outFormat}" by converter ${converter.name}`
      // ,`\nFailed to convert from "${op.in.format}" to "${outFormat}" by converter ${converter.name}${fileStr}`
    );
  }

  /* */

  return op.out;
}

_encode.defaults =
{
  data : null,
  format : null,
  filePath : null,
  ext : null,
  secondary : null,
}

function encode_body( o )
{
  let converter = this;

  _.assert( arguments.length === 1 );

  if( !o.filePath )
  if( o.secondary && _.strIs( o.secondary.filePath ) )
  o.filePath = o.secondary.filePath;

  if( !o.ext )
  if( o.filePath )
  o.filePath = _.path.ext( o.filePath );
  if( o.ext )
  o.ext = o.ext.toLowerCase()

  return converter._encode( o );
}

encode_body.defaults =
{
  ... _encode.defaults,
}

let encode = _.routineFromPreAndBody( encode_pre, encode_body );

//

function supportsInput( o )
{
  let converter = this;

  o = _.routineOptions( supportsInput, arguments );

  if( !o.ext )
  if( o.filePath )
  o.filePath = _.path.ext( o.filePath );
  if( o.ext )
  o.ext = o.ext.toLowerCase()

  _.assert( o.format === null, 'not implemented' );
  _.assert( _.strIs( o.ext ), 'not implemented' );

  if( _.longHas( converter.ext, o.ext ) )
  return true;

  return converter._supportsInput( o );
}

supportsInput.defaults =
{
  format : null,
  ext : null,
  filePath : null,
  data : null,
}

//

function _supportsInput( o )
{
  let converter = this;
  return false;
}

_supportsInput.defaults =
{
  ... supportsInput.defaults,
}

//

function supportsOutput( o )
{
  let converter = this;

  o = _.routineOptions( supportsOutput, arguments );

  if( !o.ext )
  if( o.filePath )
  o.filePath = _.path.ext( o.filePath );
  if( o.ext )
  o.ext = o.ext.toLowerCase()

  _.assert( o.format === null, 'not implemented' );
  _.assert( _.strIs( o.ext ), 'not implemented' );

  if( _.longHas( converter.ext, o.ext ) )
  return true;

  return converter._supportsOutput( o );
}

supportsOutput.defaults =
{
  format : null,
  ext : null,
  filePath : null,
  data : null,
}

//

function _supportsOutput( o )
{
  let converter = this;
  return false;
}

_supportsOutput.defaults =
{
  ... supportsOutput.defaults,
}

//

/**
 * @summary Fields of wGenericDataFormatConverter class.
 * @typedef {Object} Composes
 * @property {String} name=null Name of the converter
 * @property {String} shortName=null Short name of the converter
 * @property {Array} ext=null Supported extensions
 * @property {Array} in=null Input format
 * @property {Array} out=null Output format
 * @property {Array} inOut=null All combinations of in-out formats
 * @property {Object} supporting=null Map with supporting types of data
 * @property {Boolean} default=0 Is converter default for this in-out combination
 * @property {Boolean} forConfig=1 Can be used for configs
 *
 * @class wGenericDataFormatConverter
 * @namespace Tools
 * @module Tools/mid/Gdf
 */

// --
// relations
// --

let Composes =
{

  name : null,
  shortName : null,

  ext : null,
  in : null,
  out : null,
  inOut : null,

  supporting : null,

  onEncode : null,
  default : 0,
  forConfig : 1,

}

let Aggregates =
{
}

let Restricts =
{
}

let Statics =
{
}

let Forbids =
{

  Select : 'Select',
  Elements : 'Elements',
  InMap : 'InMap',
  OutMap : 'OutMap',
  ExtMap : 'ExtMap',
  InOutMap : 'InOutMap',

}

// --
// declare
// --

let Proto =
{

  finit,
  init,
  unform,
  form,
  _encode,
  encode,

  supportsInput,
  _supportsInput,
  supportsOutput,
  _supportsOutput,

  // relations

  Composes,
  Aggregates,
  Restricts,
  Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

// --
// export
// --

_.Gdf = Self;
_.gdf.Converter = Self;
if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
