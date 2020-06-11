( function _JsonMin_test_s_()
{
'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../dwtools/Tools.s' );
  require( '../gdf/Converter.s' );
  _.include( 'wTesting' );
}

var _global = _global_;
let _ = _global_.wTools;

_.assert( _testerGlobal_.wTools !== _global_.wTools );

// --
// test
// --

function jsonMin( test )
{
  let self = this;

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

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* json.min */

  test.case = 'select json.min';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json', default : 1 });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];
  test.identical( serialize.shortName, 'json.min' );

  /* */

  test.open( 'simple' );
  for( let s in SamplesSimple )
  {
    test.case = s;
    let src = SamplesSimple[ s ];

    let serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    let deserialized = deserialize.encode({ data : serialized.data });
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

    let serialized = serialize.encode({ data : src });
    test.identical( serialized.format, 'string' );

    let deserialized = deserialize.encode({ data : serialized.data });
    test.identical( deserialized.data, src );
    test.identical( deserialized.format, 'structure' );
  }
  test.close( 'primitive' );

  /* */

  test.open( 'complicated' );

  test.case = 'all complicated together';
  var serialized = serialize.encode({ data : SamplesComplicated });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  var deserialized = deserialize.encode({ data : serialized.data });
  var expected =
  {
    'regexp' : {},
    'infinity' : null,
    'nan' : null,
    'date' : SamplesComplicated.date.toJSON()
  }
  test.identical( deserialized.data, expected );
  test.identical( deserialized.format, 'structure' );

  test.case = 'typed array';
  var src = { typed :  new U16x( [ 1, 2, 3 ] ) }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  var deserialized = deserialize.encode({ data : serialized.data });
  var expected =
  {
    typed : { '0' : 1, '1' : 2, '2' : 3 }
  }
  test.identical( deserialized.data, expected );

  test.case = 'regexp';
  var src = { regexp :  /.regexp/g }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  var deserialized = deserialize.encode({ data : serialized.data });
  var expected =
  {
    regexp : {}
  }
  test.identical( deserialized.data, expected );

  test.case = 'infinity';
  var src = { infinity : -Infinity }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  var deserialized = deserialize.encode({ data : serialized.data });
  var expected =
  {
    infinity : null
  }
  test.identical( deserialized.data, expected );

  test.case = 'NaN';
  var src = { nan : NaN }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  var deserialized = deserialize.encode({ data : serialized.data });
  var expected =
  {
    nan : null
  }
  test.identical( deserialized.data, expected );

  test.case = 'date';
  var src = { date : new Date() }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  var deserialized = deserialize.encode({ data : serialized.data })
  var expected = { date : src.date.toJSON() }
  test.identical( deserialized.data, expected );

  test.close( 'complicated' );

}

// --
// declare
// --

var Self =
{

  name : 'Tools.jsonMin.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    jsonMin
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
