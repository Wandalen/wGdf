( function _RegisterAndFinit_test_s_()
{
'use strict';

if( typeof module !== 'undefined' )
{
  var _ = require( '../../../../dwtools/Tools.s' );
  require( '../gdf/Converter.s' );
}

var _global = _global_;
var _ = _global_.wTools;

_.assert( _testerGlobal_.wTools !== _global_.wTools );

// --
// test
// --

function registerAndFinit( test )
{
  let self = this;

  var converter =
  {
    ext : [ 'ext' ],
    in : [ 'string' ],
    out : [ 'number' ],

    onEncode : function( op )
    {
      _.assert( _.strIs( op.in.data ) );
      op.out.data = Number.parseFloat( op.in.data );
      op.out.format = 'number';
    }
  }

  converter = _.Gdf( converter );

  test.is( _.longHas( _.Gdf.Elements, converter ) );
  test.is( _.longHas( _.Gdf.InMap[ 'string' ], converter ) );
  test.is( _.longHas( _.Gdf.OutMap[ 'number' ], converter ) );
  test.is( _.longHas( _.Gdf.ExtMap[ 'ext' ], converter ) );
  test.is( _.longHas( _.Gdf.InOutMap[ 'string-number' ], converter ) );

  converter.finit();

  test.is( !_.longHas( _.Gdf.Elements, converter ) );
  test.is( !_.longHas( _.Gdf.InMap[ 'string' ], converter ) );
  test.is( !_.longHas( _.Gdf.OutMap[ 'number' ], converter ) );
  test.is( !_.longHas( _.Gdf.ExtMap[ 'ext' ], converter ) );
  test.is( !_.longHas( _.Gdf.InOutMap[ 'string-number' ], converter ) );
}

// --
// declare
// --

var Self =
{

  name : 'Tools.registerAndFinit.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    registerAndFinit
  },

};

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
