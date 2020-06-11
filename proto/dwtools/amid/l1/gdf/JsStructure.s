( function _JsStructure_s_()
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
// js
// --

let ProcessBasic;
try
{
  ProcessBasic = _.include( 'wProcess' );
}
catch( err )
{
}

let jsSupported =
{
  primitive : 3,
  regexp : 2,
  buffer : 3,
  structure : 2
}

let readJsStructure = null;
if( ProcessBasic )
readJsStructure =
{

  forConfig : 0,
  ext : [ 'js.structure', 'js', 's', 'ss', 'jstruct', 'jslike' ],
  in : [ 'string' ],
  out : [ 'structure' ],

  supporting : jsSupported,

  // onEncode : function( op )
  // {
  //   op.out.format = 'string';
  // },

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
//   ext : [ 'js', 's', 'ss', 'jstruct', 'jslike' ],
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
//   ext : [ 'js', 's', 'ss', 'jstruct', 'jslike' ],
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

  ext : [ 'js.structure', 'js', 's', 'ss', 'jstruct', 'jslike' ],
  in : [ 'structure' ],
  out : [ 'string' ],

  supporting : jsSupported,

  onEncode : function( op )
  {
    op.out.data = _.toJs( op.in.data );
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

_.Gdf([ readJsStructure, /*readJsNode, readJsSmart, */ writeJsStrcuture ]);

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
