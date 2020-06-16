( function _Namespace_s_( )
{

'use strict';

let _ = _global_.wTools;
let Self = _.gdf = _.gdf || Object.create( null );

// --
// implement
// --

/**
 * Searches for converters.
 * Finds converters that match the specified selector.
 * Converter is selected if all fields of selector are equal with appropriate properties of the converter.
 *
 * @param {Object} selector a map with one or several rules that should be met by the converter
 *
 * Possible selector properties are :
 * @param {String} [selector.in] Input format of the converter
 * @param {String} [selector.out] Output format of the converter
 * @param {String} [selector.ext] File extension of the converter
 * @param {Boolean|Number} [selector.default] Selects default converter for provided in,out and ext
 *
 * @example
 * //returns converters that accept string as input
 * let converters = _.gdf.select({ in : 'string' });
 * console.log( converters )
 *
 * @example
 * //returns converters that accept string and return structure( object )
 * let converters = _.gdf.select({ in : 'string', out : 'structure' });
 * console.log( converters )
 *
 * * @example
 * //returns default json converter that encodes structure to string
 * let converters = _.gdf.select({ in : 'structure', out : 'string', ext : 'json', default : 1 });
 * console.log( converters[ 0 ] )
 *
 * @returns {Array} Returns array with selected converters or empty array if nothing found.
 * @throws {Error} If more than one argument is provided
 * @throws {Error} If selector is not an Object
 * @throws {Error} If selector has unknown field
 * @method Select
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 * @static
 */

function select( selector )
{
  _.assert( arguments.length === 1 );

  let result = _.filter( _.gdf.convertersArray, select );

  if( result.length > 1 )
  if( selector.default !== undefined )
  {
    result = result.filter( ( e ) => selector.default === e.default );
  }

  result = result.map( ( e ) => _.mapExtend( null, selector, { encoder : e } ) );
  result = _.gdf.Current( result );

  return result;

  /* */

  function select( converter )
  {
    for( let s in selector )
    {
      let sfield = selector[ s ];
      let cfield = converter[ s ];
      if( s === 'default' )
      continue;
      if( _.arrayIs( cfield ) )
      {
        _.assert( _.strIs( sfield ) );
        if( !_.longHas( cfield, sfield ) )
        return undefined;
      }
      else _.assert( 0, 'Unknown selector field ' + s );
    }
    return converter;
  }

}

// --
// declare
// --

/**
 * @summary Contains descriptors of registered converters.
 * @property {Object} convertersArray
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

/**
 * @summary Contains descriptors of registered converters mapped by inptut format.
 * @property {Object} inMap
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

/**
 * @summary Contains descriptors of registered converters mapped by out format.
 * @property {Object} outMap
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

/**
 * @summary Contains descriptors of registered converters mapped by extension.
 * @property {Object} extMap
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

/**
 * @summary Contains descriptors of registered converters mapped by in/out format.
 * @property {Object} inOutMap
 * @static
 * @class wGenericDataFormatConverter
 * @namespace Tools.gdf
 * @module Tools/mid/Gdf
 */

let convertersArray = [];
let inMap = Object.create( null );
let outMap = Object.create( null );
let extMap = Object.create( null );
let inOutMap = Object.create( null );

let Extension =
{

  // routine

  select,

  // field

  convertersArray,
  inMap,
  outMap,
  extMap,
  inOutMap,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();
