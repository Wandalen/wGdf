( function _Json_test_s_()
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

function json( test )
{
  var self = this;

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

  //

  test.case = 'number';
  var data = '1.12345';
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, 1.12345 );

  test.case = 'string';
  var data = '"1.12345"';
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, '1.12345' );

  test.case = 'null';
  var data = 'null';
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, null );

  test.case = 'array';
  var data = '[0, 1, 2]';
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, [ 0, 1, 2 ] );

  test.case = 'map';
  var data = '{"0": 0, "1": 1, "2": 2}';
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, { 0 : 0, 1 : 1, 2 : 2 });

  test.case = 'date as string';
  var data = '2019-02-06T14:50:01.641Z"'
  test.shouldThrowErrorSync( () => deserialize.encode({ data }) );

  test.case = 'date as map field';
  var data = '{ "date" : "2019-02-06T14:50:01.641Z" }'
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, { date : '2019-02-06T14:50:01.641Z' });

  test.case = 'map';
  var data = '{ "a" : "1", "dir" : { "b" : 2 }, "c" : [ 1,2,3 ] }';
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] });

  test.case = 'regexp';
  var data = '/.regexp/g';
  test.shouldThrowErrorSync( () => deserialize.encode({ data }) );

  test.case = 'buffer';
  var data = '( new U16x([ 1,2,3 ]) )';
  test.shouldThrowErrorSync( () => deserialize.encode({ data }) );

  test.case = 'map';
  var src =
  {
    a :
    {
      1 : 1,
      b :
      {
        2 : 2,
        c :
        {
          3 : 3
        }
      }
    }
  }
  var data = _.toStr( src, { jsonLike : 1 })
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, src );

  test.case = 'map';
  var src =
  {
    a :
    {
      1 : 1,
      b :
      {
        2 : 2,
        c :
        {
          3 : 3
        }
      }
    }
  }
  var data = _.toStr( src, { jsonLike : 1 })
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, src );

  test.case = 'array'
  var src =
  [
    0,
    [
      1,
      [
        2,
        [ 3 ]
      ]
    ]
  ]
  var data = _.toStr( src, { jsonLike : 1 })
  var deserialized = deserialize.encode({ data });
  test.identical( deserialized.data, src );

  test.case = 'complicated map with unsupported type';
  var data = _.toStr( SamplesComplicated, { jsonLike : 1 });
  test.shouldThrowErrorSync( () => deserialize.encode({ data }) );

  test.case = 'complicated map, written by json.fine'
  var src =
  {
    string : 'string',
    number : 1,
    array : [ 1, 'string' ],
    date : new Date( Date.UTC( 2018, 1, 1 ) ),
    map : { string : 'string', number : 1, array : [ 'string', 1 ] }
  }
  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json.fine' });
  serialize = serialize[ 0 ];
  var serialized = serialize.encode({ data : src });
  var deserialized = deserialize.encode({ data : serialized.data });
  var expected =
  {
    string : 'string',
    number : 1,
    array : [ 1, 'string' ],
    date : new Date( Date.UTC( 2018, 1, 1 ) ).toJSON(),
    map : { string : 'string', number : 1, array : [ 'string', 1 ] }
  }
  test.identical( deserialized.data, expected );

  test.case = 'complicated map, written by json.min'
  var src =
  {
    string : 'string',
    number : 1,
    array : [ 1, 'string' ],
    date : new Date( Date.UTC( 2018, 1, 1 ) ),
    map : { string : 'string', number : 1, array : [ 'string', 1 ] }
  }
  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json.min' });
  serialize = serialize[ 0 ];
  var serialized = serialize.encode({ data : src });
  var deserialized = deserialize.encode({ data : serialized.data });
  var expected =
  {
    string : 'string',
    number : 1,
    array : [ 1, 'string' ],
    date : new Date( Date.UTC( 2018, 1, 1 ) ).toJSON(),
    map : { string : 'string', number : 1, array : [ 'string', 1 ] }
  }
  test.identical( deserialized.data, expected );
}

// --
// declare
// --

var Self =
{

  name : 'Tools.json.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    json
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
