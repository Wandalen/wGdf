( function _Cbor_test_s_()
{
'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  require( '../gdf/entry/Gdf.s' );
  _.include( 'wTesting' );
}

let _global = _global_;
let _ = _global_.wTools;

_.assert( _globals_.testing.wTools !== _global_.wTools );

// --
// test
// --

function cbor( test )
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

  var serialize = _.gdf.selectContext({ inFormat : 'structure', outFormat : 'buffer.node', ext : 'cbor' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.gdf.selectContext({ inFormat : 'buffer.node', outFormat : 'structure', ext : 'cbor' });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* */

  test.open( 'simple' );
  for( let s in SamplesSimple )
  {
    test.case = s;
    let src = SamplesSimple[ s ];

    if( !_.mapIs( src ) )
    src = { [ s ] : src };

    let serialized = serialize.encode({ data : src }).out;
    test.identical( serialized.format, 'buffer.node' );
    test.true( _.bufferNodeIs( serialized.data ) );

    let deserialized = deserialize.encode({ data : serialized.data }).out;
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'simple' );

  test.case = 'all simple together';
  var serialized = serialize.encode({ data : SamplesSimple }).out;
  test.identical( serialized.format, 'buffer.node' );
  test.true( _.bufferNodeIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data }).out;
  test.identical( deserialized.data, SamplesSimple );
  test.identical( deserialized.format, 'structure' );

  /* */

  test.open( 'primitive' );
  for( let s in SamplesPrimitive )
  {
    test.case = s;
    let src = SamplesPrimitive[ s ];

    if( !_.mapIs( src ) )
    src = { [ s ] : src };

    let serialized = serialize.encode({ data : src }).out;
    test.identical( serialized.format, 'buffer.node' );

    let deserialized = deserialize.encode({ data : serialized.data }).out;
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'primitive' );

  test.case = 'all primitive together';
  var serialized = serialize.encode({ data : SamplesPrimitive }).out;
  test.identical( serialized.format, 'buffer.node' );
  test.true( _.bufferNodeIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data }).out;
  test.identical( deserialized.data, SamplesPrimitive );
  test.identical( deserialized.format, 'structure' );

  /* */

  test.open( 'complicated' );
  for( let s in SamplesComplicated )
  {
    test.case = s;
    let src = SamplesComplicated[ s ];

    if( !_.mapIs( src ) )
    src = { [ s ] : src };

    let serialized = serialize.encode({ data : src }).out;
    test.identical( serialized.format, 'buffer.node' );

    let deserialized = deserialize.encode({ data : serialized.data }).out;
    let identical = _.entityIdentical( deserialized.data, src );
    if( _.regexpIs( src[ s ] ) )
    test.true( !identical );
    else
    test.true( identical );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'complicated' );

  test.case = 'all complicated together';
  var serialized = serialize.encode({ data : SamplesComplicated }).out;
  test.identical( serialized.format, 'buffer.node' );
  test.true( _.bufferNodeIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data }).out;
  test.notIdentical( deserialized.data, SamplesComplicated );
  test.identical( deserialized.format, 'structure' );

  /* */

}

// --
// declare
// --

let Self =
{

  name : 'Tools.cbor.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    cbor
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
