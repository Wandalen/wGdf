( function _Select_test_s_()
{
'use strict';

if( typeof module !== 'undefined' )
{
  var _ = require( '../../../../dwtools/Tools.s' );
  require( '../gdf/Converter.s' );
  _.include( 'wTesting' );
}

var _global = _global_;
var _ = _global_.wTools;

_.assert( _testerGlobal_.wTools !== _global_.wTools );

// --
// test
// --

function select( test )
{
  let self = this;

  test.case = 'all'
  var got = _.Gdf.Select( {} );
  test.is( got.length === _.Gdf.Elements.length );

  test.case = 'in'
  var got = _.Gdf.Select( { in : 'structure' } );
  test.ge( got.length, 1 );

  test.case = 'out'
  var got = _.Gdf.Select( { out : 'string' } );
  test.ge( got.length, 1 );

  test.case = 'not existing'

  var got = _.Gdf.Select( { in : 'not existing' } );
  test.is( !got.length );

  var got = _.Gdf.Select( { out : 'not existing' } );
  test.is( !got.length );

  var got = _.Gdf.Select( { ext : 'not existing' } );
  test.is( !got.length );

  test.case = 'default';

  var got = _.Gdf.Select( { in : 'structure', out : 'string' } );
  test.is( got.length > 1 );
  var got = _.Gdf.Select( { in : 'structure', out : 'string', default : 1 } );
  test.is( got.length === 1 );
  test.identical( got[ 0 ].shortName, 'json.min' );

  // test.case = 'shortName';

  // var got = _.Gdf.Select({ shortName : 'json.fine', out : 'string' });
  // test.is( got.length === 1 );
  // test.identical( got[ 0 ].shortName, 'json.fine' );

  if( !Config.debug )
  return;

  test.case = 'not supporting value'

  test.shouldThrowErrorSync( () => _.Gdf.Select() );
  test.shouldThrowErrorSync( () => _.Gdf.Select( { ext : [ 'json.fine', 'json' ] } ) );

}

// --
// declare
// --

var Self =
{

  name : 'Tools.select.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    select
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )();
