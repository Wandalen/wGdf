( function _Cson_test_s_()
{
'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../gdf/entry/Gdf.s' );
  _.include( 'wTesting' );
}

const _global = _global_;
const _ = _global_.wTools;

_.assert( _globals_.testing.wTools !== _global_.wTools );

// --
// test
// --

function cson( test )
{
  let context = this;

  let SamplesPrimitive =
  {
    null : null,
    number : 13,
    string : 'something',
  }

  let SamplesSimple =
  {
    map : { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] },
    array : [ { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] } ],
  }

  let SamplesComplicated =
  {
    regexp : /.regexp/g,
    infinity : -Infinity,
    nan : NaN,
    date : new Date(),
  }

  /* */

  test.case = 'select';

  var serialize = _.gdf.selectContext({ inFormat : 'structure', outFormat : 'string', ext : 'cson' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.gdf.selectContext({ inFormat : 'string', outFormat : 'structure', ext : 'cson' });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* */

  test.open( 'simple' );
  for( let s in SamplesSimple )
  {
    test.case = s;
    let src = SamplesSimple[ s ];

    let serialized = serialize.encode({ data : src }).out;
    test.identical( serialized.format, 'string.utf8' );

    let deserialized = deserialize.encode({ data : serialized.data }).out;
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'simple' );

  /* */

  test.open( 'primitive' );
  for( let s in SamplesPrimitive )
  {
    test.case = s;
    let src = SamplesPrimitive[ s ];

    let serialized = serialize.encode({ data : src }).out;
    test.identical( serialized.format, 'string.utf8' );

    let deserialized = deserialize.encode({ data : serialized.data }).out;
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'primitive' );

  /* */

  test.open( 'complicated' );
  for( let s in SamplesComplicated )
  {
    test.case = s;
    let src = SamplesComplicated[ s ];

    var serialized = serialize.encode({ data : src }).out;
    test.identical( serialized.format, 'string.utf8' );

    var deserialized = deserialize.encode({ data : serialized.data }).out;
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'complicated' );

  /* */

}

// --
// declare
// --

const Proto =
{

  name : 'Tools.cson.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    cson
  },

};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
