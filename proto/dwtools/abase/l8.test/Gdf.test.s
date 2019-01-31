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
  var encoders = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'cson', default : 1 });
  test.identical( encoders.length, 1 );

  /* */

  test.case = 'encode with encoder';
  var dst = encoders[ 0 ].encode({ data : src, encoding : 'string' });
  var expected = { data : { val : 13 }, encoding : 'structure' }
  test.identical( dst, expected );

  /* */

  test.case = 'encode without encoder';
  var dst = encoders[ 0 ].encode({ data : src });
  var expected = { data : { val : 13 }, encoding : 'structure' }
  test.identical( dst, expected );

}

//

function json( test )
{
  var self = this;

  /* */

  test.case = 'select';

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
    test.identical( serialized.encoding, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.encoding, 'structure' );
  }
  test.close( 'simple' );

  /* */

  test.open( 'primitive' );
  for( let s in SamplesPrimitive )
  {
    test.case = s;
    let src = SamplesPrimitive[ s ];

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.encoding, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.encoding, 'structure' );
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
  //   test.identical( serialized.encoding, 'string' );
  //
  //   var deserialized = deserialize.encode({ data : serialized.data });
  //   test.identical( deserialized.data, src );
  //   test.identical( deserialized.encoding, 'structure' );
  // }
  // test.close( 'complicated' );

  /* */

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
    test.identical( serialized.encoding, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.encoding, 'structure' );
  }
  test.close( 'simple' );

  /* */

  test.open( 'primitive' );
  for( let s in SamplesPrimitive )
  {
    test.case = s;
    let src = SamplesPrimitive[ s ];

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.encoding, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.encoding, 'structure' );
  }
  test.close( 'primitive' );

  /* */

  test.open( 'complicated' );
  for( let s in SamplesComplicated )
  {
    test.case = s;
    let src = SamplesComplicated[ s ];

    var serialized = serialize.encode({ data : src });
    test.identical( serialized.encoding, 'string' );

    var deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.encoding, 'structure' );
  }
  test.close( 'complicated' );

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
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
