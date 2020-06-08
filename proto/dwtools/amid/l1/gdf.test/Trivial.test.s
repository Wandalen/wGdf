( function _Trivial_test_s_()
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

function trivial( test )
{
  var self = this;

  /* */

  test.case = 'select';
  var src = 'val : 13';
  debugger;
  var converters = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'cson', default : 1 });
  debugger;
  test.identical( converters.length, 1 );

  /* */

  test.case = 'encode with format';
  var dst = converters[ 0 ].encode({ data : src, format : 'string' });
  var expected = { data : { val : 13 }, format : 'structure' }
  test.identical( dst, expected );

  /* */

  test.case = 'encode without format';
  var dst = converters[ 0 ].encode({ data : src });
  var expected = { data : { val : 13 }, format : 'structure' }
  test.identical( dst, expected );

}

// --
// declare
// --

var Self =
{

  name : 'Tools.trivial.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    trivial
  },

};

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
