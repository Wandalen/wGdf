( function _Coffee_s_()
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
// coffee
// --

/* xxx qqq : implement delayed including */

let Coffee, CoffeePath;
try
{
  CoffeePath = require.resolve( 'coffeescript' );
}
catch( err )
{
}

let csonSupported =
{
  primitive : 1,
  regexp : 2,
  buffer : 3,
  structure : 2
}

let readCoffee = null;
if( CoffeePath )
readCoffee =
{

  ext : [ 'coffee', 'cson' ],
  in : [ 'string' ],
  out : [ 'structure' ],

  supporting : csonSupported,

  onEncode : function( op )
  {
    let o = Object.create( null );

    if( !Coffee )
    Coffee = require( CoffeePath );

    if( op.envMap.filePath )
    o.filename = _.fileProvider.path.nativize( op.envMap.filePath )

    op.out.data = Coffee.eval( op.in.data, o );
    op.out.format = 'structure';
  },

}

//

let Js2coffee, Js2coffeePath;
try
{
  Js2coffeePath = require.resolve( 'js2coffee' );
}
catch( err )
{
}

let writeCoffee = null;
if( Js2coffeePath )
writeCoffee =
{

  ext : [ 'coffee', 'cson' ],
  in : [ 'structure' ],
  out : [ 'string' ],

  supporting : csonSupported,

  onEncode : function( op )
  {

    if( !Js2coffee )
    Js2coffee = require( Js2coffeePath );

    let data = _.toStr( op.in.data, { jsLike : 1, keyWrapper : '' } );
    if( _.mapIs( op.in.data ) )
    data = '(' + data + ')';
    op.out.data = Js2coffee( data );
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

_.Gdf([ readCoffee, writeCoffee ]);

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
