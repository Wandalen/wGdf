( function _JsonFine_test_s_()
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

function jsonFine( test )
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

  // var deserialize = _.gdf.selectContext({ inFormat : 'string', outFormat : 'structure', ext : 'json', default : 1 });
  var deserialize = _.gdf.selectContext({ inFormat : 'string', outFormat : 'structure', ext : 'json' });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* json.fine */

  test.case = 'select json.fine';

  var serialize = _.gdf.selectContext({ inFormat : 'structure', outFormat : 'string', ext : 'json.fine' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];
  test.identical( serialize.shortName, 'json.fine' );

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

  test.case = 'all complicated together';
  var serialized = serialize.encode({ data : SamplesComplicated }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) ).out;

  test.case = 'typed array';
  var src = { typed :  new U16x( [ 1, 2, 3 ] ) }
  var serialized = serialize.encode({ data : src }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) ).out;

  test.case = 'regexp';
  var src = { regexp :  /.regexp/g }
  var serialized = serialize.encode({ data : src }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) ).out;

  test.case = 'infinity';
  var src = { infinity : -Infinity }
  var serialized = serialize.encode({ data : src }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) ).out;

  test.case = 'NaN';
  var src = { nan : NaN }
  var serialized = serialize.encode({ data : src }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) ).out;

  test.case = 'date';
  var src = { date : new Date() }
  var serialized = serialize.encode({ data : src }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );
  var deserialized = deserialize.encode({ data : serialized.data }).out;
  var expected = { date : src.date.toJSON() }
  test.identical( deserialized.data, expected );

  test.close( 'complicated' );

}

// --
// declare
// --

const Proto =
{

  name : 'Tools.jsonFine.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    jsonFine
  },

};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
