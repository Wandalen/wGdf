( function _EncoderStrategy_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  var _ = require( '../../Tools.s' );
  require( '../l8/GdfConverter.s' );
  _.include( 'wTesting' );

}

var _global = _global_;
var _ = _global_.wTools;

// --
// data
// --

let SamplesPrimitive =
{

  null : null,
  number : 13,
  string : 'something',

}

let SamplesSimple =
{

  map : { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] },
  array : [ { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] } ],

}

let SamplesComplicated =
{

  regexp : /.regexp/g,
  infinity : -Infinity,
  nan : NaN,
  date : new Date(),

}

// --
// test
// --

function trivial( test )
{
  var self = this;

  /* */

  test.case = 'select';
  var src = 'val : 13';
  var converters = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'cson', default : 1 });
  test.identical( converters.length, 1 );

  /* */

  test.case = 'encode with encoder';
  var dst = converters[ 0 ].encode({ data : src, format : 'string' });
  var expected = { data : { val : 13 }, format : 'structure' }
  test.identical( dst, expected );

  /* */

  test.case = 'encode without encoder';
  var dst = converters[ 0 ].encode({ data : src });
  var expected = { data : { val : 13 }, format : 'structure' }
  test.identical( dst, expected );

}

//

function json( test )
{
  var self = this;

  /* json.fine */

  test.case = 'select json.fine';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json', default : 1 });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* */

  test.open( 'simple' );
  for( let s in SamplesSimple )
  {
    test.case = s;
    let src = SamplesSimple[ s ];

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'primitive' );

  /* */

  // test.open( 'complicated' );
  // for( let s in SamplesComplicated )
  // {
  //   test.case = s;
  //   let src = SamplesComplicated[ s ];
  //
  //   var serialized = serialize.encode({ data : src });
  //   test.identical( serialized.format, 'string' );
  //
  //   var deserialized = deserialize.encode({ data : serialized.data });
  //   test.identical( deserialized.data, src );
  //   test.identical( deserialized.format, 'structure' );
  // }
  // test.close( 'complicated' );


  /* json.min */

  test.case = 'select json.min';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json.min', default : 1 });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];
  test.identical( serialize.shortName, 'json.min' );

  /* */

  test.open( 'simple' );
  for( let s in SamplesSimple )
  {
    test.case = s;
    let src = SamplesSimple[ s ];

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'primitive' );

}

//

function cson( test )
{
  var self = this;

  /* */

  test.case = 'select';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'cson' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'cson' });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* */

  test.open( 'simple' );
  for( let s in SamplesSimple )
  {
    test.case = s;
    let src = SamplesSimple[ s ];

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'complicated' );

  /* */

}

//

function js( test )
{
  var self = this;

  /* */

  test.case = 'select';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'js' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'js' });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* */

  test.open( 'simple' );
  for( let s in SamplesSimple )
  {
    test.case = s;
    let src = SamplesSimple[ s ];

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'complicated' );

  /* */

}

//

function bson( test )
{
  var self = this;

  /* */

  test.case = 'select';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'buffer.node', ext : 'bson' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'buffer.node', out : 'structure', ext : 'bson' });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'buffer.node' );
    test.is( _.bufferNodeIs( serialized.data ) );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'simple' );

  test.case = 'all simple together';
  var serialized = serialize.encode({ data : SamplesSimple });
  test.identical( serialized.format, 'buffer.node' );
  test.is( _.bufferNodeIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'buffer.node' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'primitive' );

  test.case = 'all primitive together';
  var serialized = serialize.encode({ data : SamplesPrimitive });
  test.identical( serialized.format, 'buffer.node' );
  test.is( _.bufferNodeIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'buffer.node' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'complicated' );

  test.case = 'all complicated together';
  var serialized = serialize.encode({ data : SamplesComplicated });
  test.identical( serialized.format, 'buffer.node' );
  test.is( _.bufferNodeIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data });
  test.identical( deserialized.data, SamplesComplicated );
  test.identical( deserialized.format, 'structure' );

  /* */

}

//

function yml( test )
{
  var self = this;

  /* */

  test.case = 'select';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'yml' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'yml' });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );
    test.is( _.strIs( serialized.data ) );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'simple' );

  test.case = 'all simple together';
  var serialized = serialize.encode({ data : SamplesSimple });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'primitive' );

  test.case = 'all primitive together';
  var serialized = serialize.encode({ data : SamplesPrimitive });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data });
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

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'complicated' );

  test.case = 'all complicated together';
  var serialized = serialize.encode({ data : SamplesComplicated });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );

  var deserialized = deserialize.encode({ data : serialized.data });
  test.identical( deserialized.data, SamplesComplicated );
  test.identical( deserialized.format, 'structure' );

  /* */

}

// --
// declare
// --

var Self =
{

  name : 'Tools/base/EncoderStrategy',
  silencing : 1,

  tests :
  {
    trivial,
    json,
    cson,
    js,
    bson,
    yml
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
