(function _EncoderStrategyStandanrd_s_() {

'use strict';

/**
 * @file EncoderStrategyStandanrd.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

}

let _global = _global_;
let _ = _global_.wTools;
let Self = _global_.wTools;

// --
// json
// --

let readJson =
{

  ext : [ 'json' ],
  in : [ 'string' ],
  out : [ 'structure' ],

  onEncode : function( op )
  {

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
      if( !isNaN( position ) )
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

  ext : [ 'json.min', 'json' ],
  shortName : 'json.min',
  in : [ 'structure' ],
  out : [ 'string' ],

  onEncode : function( op )
  {
    op.out.data = JSON.stringify( op.in.data );
    op.out.format = 'string';
  }

}

let writeJsonFine =
{

  default : 1,
  shortName : 'json.fine',
  ext : [ 'json.fine', 'json' ],
  in : [ 'structure' ],
  out : [ 'string' ],

  onEncode : function( op )
  {
    op.out.data = _.cloneData({ src : op.in.data });
    op.out.data = _.toJson( op.out.data, { cloning : 0 } );
    op.out.format = 'string';
  }

}

// --
// js
// --

let ExternalFundamentals;
try
{
  ExternalFundamentals = _.include( 'wExternalFundamentals' );
}
catch( err )
{
}

let readJsStructure = null;
if( ExternalFundamentals )
readJsStructure =
{

  forConfig : 0,
  ext : [ 'js.structure', 'js','s','ss','jstruct', 'jslike' ],
  in : [ 'string' ],
  out : [ 'structure' ],

  onEncode : function( op )
  {
    op.out.format = 'string';
  },

  onEncode : function( op )
  {
    op.out.data = _.exec({ code : op.in.data, filePath : op.envMap.filePath, prependingReturn : 1 });
    op.out.format = 'structure';
  },

}

//

// let readJsNode =
// {
//
//   forConfig : 0,
//   ext : [ 'js','s','ss','jstruct', 'jslike' ],
//   in : [ 'string' ],
//   out : [ 'structure' ],
//
//   onEncode : function( op )
//   {
//     op.out.data = require( _.fileProvider.path.nativize( op.envMap.filePath ) );
//     op.out.format = 'structure';
//   },
//
// }
//
// //
//
// let readJsSmart =
// {
//
//   ext : [ 'js','s','ss','jstruct', 'jslike' ],
//   in : [ 'string' ],
//   out : [ 'structure' ],
//
//   onEncode : function( op )
//   {
//
//     // qqq
//     // if( typeof process !== 'undefined' && typeof require !== 'undefined' )
//     // if( _.FileProvider.HardDrive && op.envMap.provider instanceof _.FileProvider.HardDrive )
//     // {
//     //   op.out.data = require( _.fileProvider.path.nativize( op.envMap.filePath ) );
//     //   op.out.format = 'structure';
//     //   return;
//     // }
//
//     op.out.data = _.exec
//     ({
//       code : op.in.data,
//       filePath : op.envMap.filePath,
//       prependingReturn : 1,
//     });
//
//     op.out.format = 'structure';
//
//   },
//
// }

//

let writeJsStrcuture =
{

  ext : [ 'js.structure','js','s','ss','jstruct', 'jslike' ],
  in : [ 'structure' ],
  out : [ 'string' ],

  onEncode : function( op )
  {
    op.out.data = _.toJs( op.in.data );
    op.out.format = 'string';
  }

}

// --
// coffee
// --

let Coffee;
try
{
  Coffee = require( 'coffee-script' );
}
catch( err )
{
}

let readCoffee = null;
if( Coffee )
readCoffee =
{

  ext : [ 'coffee', 'cson' ],
  in : [ 'string' ],
  out : [ 'structure' ],

  onEncode : function( op )
  {
    // _.assert( _.strIs( op.in.data ), 'Expects string' );
    // _.assert( op.in.format === 'string', 'Expects string' );
    // _.assert( _.strIs( op.envMap.filePath ) || op.envMap.filePath === null );
    op.out.data = Coffee.eval( op.in.data, { filename : op.envMap.filePath } );
    op.out.format = 'structure';
  },

}

//

let Js2coffee;
try
{
  Js2coffee = require( 'js2coffee' );
}
catch( err )
{
}

let writeCoffee = null;
if( Js2coffee )
writeCoffee =
{

  ext : [ 'coffee', 'cson' ],
  in : [ 'structure' ],
  out : [ 'string' ],

  onEncode : function( op )
  {
    let data = _.toStr( op.in.data, { jsLike : 1, keyWrapper : '' } );
    if( _.mapIs( op.in.data ) )
    data = '(' + data + ')';
    op.out.data = Js2coffee( data );
  },

}

// --
// yaml
// --

let Yaml;
try
{
  Yaml = require( 'js-yaml' );
}
catch( err )
{
}

let readYml = null;
if( Yaml )
readYml =
{

  ext : [ 'yaml','yml' ],
  in : [ 'string' ],
  out : [ 'structure' ],

  onEncode : function( op )
  {
    op.out.data = Yaml.load( op.in.data, { filename : op.envMap.filePath } );
    op.out.format = 'structure';
  },

}

let writeYml = null;
if( Yaml )
writeYml =
{

  ext : [ 'yaml','yml' ],
  in : [ 'structure' ],
  out : [ 'string' ],

  onEncode : function( op )
  {
    op.out.data = Yaml.dump( op.in.data );
    op.out.format = 'string';
  },

}

// --
// bson
// --

let Bson;
try
{
  Bson = require( 'bson' );
}
catch( err )
{
}

let readBson = null;
if( Bson )
readBson =
{

  ext : [ 'bson' ],
  in : [ 'buffer.node' ],
  out : [ 'structure' ],

  onEncode : function( op )
  {
    _.assert( _.bufferNodeIs( op.in.data ) );
    op.out.data = Bson.deserialize( op.in.data );
    op.out.format = 'structure';
  },

}

let writeBson = null;
if( Bson )
writeBson =
{

  ext : [ 'bson' ],
  in : [ 'structure' ],
  out : [ 'buffer.node' ],

  onEncode : function( op )
  {
    _.assert( _.mapIs( op.in.data ) );
    op.out.data = Bson.serialize( op.in.data );
    op.out.format = 'buffer.node';
  },

}

// --
// register
// --

_.Gdf([ readJson, writeJsonMin, writeJsonFine ]);
_.Gdf([ readJsStructure, /*readJsNode, readJsSmart,*/ writeJsStrcuture ]);
_.Gdf([ readYml, writeYml ]);
_.Gdf([ readCoffee, writeCoffee ]);
_.Gdf([ readBson, writeBson ]);

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
