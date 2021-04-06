( function _Yml_test_s_()
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

function yml( test )
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

  var serialize = _.gdf.selectContext({ inFormat : 'structure', outFormat : 'string', ext : 'yml' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.gdf.selectContext({ inFormat : 'string', outFormat : 'structure', ext : 'yml' });
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
    test.identical( serialized.format, 'string.utf8' );
    test.true( _.strIs( serialized.data ) );

    let deserialized = deserialize.encode({ data : serialized.data }).out;
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'simple' );

  test.case = 'all simple together';
  var serialized = serialize.encode({ data : SamplesSimple }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );

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
    test.identical( serialized.format, 'string.utf8' );

    let deserialized = deserialize.encode({ data : serialized.data }).out;
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'primitive' );

  test.case = 'all primitive together';
  var serialized = serialize.encode({ data : SamplesPrimitive }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );

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
    test.identical( serialized.format, 'string.utf8' );

    let deserialized = deserialize.encode({ data : serialized.data }).out;
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'complicated' );

  test.case = 'all complicated together';
  var serialized = serialize.encode({ data : SamplesComplicated }).out;
  test.identical( serialized.format, 'string.utf8' );
  test.true( _.strIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data }).out;
  test.identical( deserialized.data, SamplesComplicated );
  test.identical( deserialized.format, 'structure' );

  /* */

}

//

// function deserializeUnsafeTags( test )
// {
//   const context = this;
//
//   let deserializer = _.gdf.selectContext({ inFormat : 'string', outFormat : 'structure', ext : 'yml' });
//   test.identical( deserializer.length, 1 );
//   deserializer = deserializer[ 0 ];
//
//   /* */
//
//   test.case = 'regexp in string';
//   var data = '!!js/regexp \'/\\.two$/\'';
//   var got = deserializer.encode({ data }).out;
//   test.identical( got.data, /\.two$/ );
//
//   test.case = 'undefined in string';
//   var data = '!!js/undefined \'\'';
//   var got = deserializer.encode({ data }).out;
//   test.identical( got.data, undefined );
//
//   test.case = 'function in string';
//   var data = '!!js/function \'function () { return true }\'';
//   var got = deserializer.encode({ data }).out;
//   test.true( _.routineIs( got.data ) );
//
//   test.case = 'array of tags';
//   var data =
// `
// - !!js/regexp '/\\.two$/'
// - !!js/undefined ''
// - !!js/function 'function () { return true }'
// `;
//   var got = deserializer.encode({ data }).out;
//   test.true( _.arrayIs( got.data ) );
//   test.identical( got.data[ 0 ], /\.two$/ );
//   test.identical( got.data[ 1 ], undefined );
//   test.true( _.routineIs( got.data[ 2 ] ) );
// }

// --
// declare
// --

const Proto =
{

  name : 'Tools.yml.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    yml,
    // deserializeUnsafeTags, /* qqq xxx : uncomment when js-yaml will be updated to v4.0.0 or higher */
  },

};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
