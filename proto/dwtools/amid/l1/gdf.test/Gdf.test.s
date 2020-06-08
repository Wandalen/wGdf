( function _Gdf_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  // require( 'wTesting' );
  var _ = require( '../../../../dwtools/Tools.s' );
  require( '../gdf/Converter.s' );
  _.include( 'wTesting' );

  var bson = require( './Bson.test.s' ).tests.bson;
  var cbor = require( './Cbor.test.s' ).tests.cbor;
  var yml = require( './Yml.test.s' ).tests.yml;
  var json = require( './Json.test.s' ).tests.json;
  var js = require( './Js.test.s' ).tests.js;
  var cson = require( './Cson.test.s' ).tests.cson;
  var jsonMin = require( './JsonMin.test.s' ).tests.jsonMin;
  var jsonFine = require( './JsonFine.test.s' ).tests.jsonFine;
  var utf8 = require( './Utf8.test.s' ).tests.utf8;
  var base64 = require( './Base64.test.s' ).tests.base64;
  var supportedTypes = require( './SupportedTypes.test.s' ).tests.supportedTypes;
  var registerAndFinit = require( './RegisterAndFinit.test.s' ).tests.registerAndFinit;
}

var _global = _global_;
var _ = _global_.wTools;

_.assert( _testerGlobal_.wTools !== _global_.wTools );
debugger;

// --
// data
// --

/*
qqq :
- please, use lower case for names of routines
- add routines to context of the test
- add static structure supporting

let supporting =
{
  'yaml' :
  {
    complex : 1,
    primitive : 2,
    ...
  }
  ...
}

- compare structure with outcomes of testing, fail if not consistent with expection
- merge OldEncoders.s into GdfFormats.s
- implement other discussed problems

*/

function converterTypesCheck( test, o, o2 )
{
  let self = this;

  let samples = o2.samples;
  let currentLevel = o2.currentLevel;
  let name = o2.name;
  _.assert( o.serialize.supporting, `${o.serialize.ext} is not supporting` );
  let expectedLevel = o.serialize.supporting[ name ];

  let prefix = o.serialize.ext + ' / ' + name + currentLevel;

  test.open( prefix );

  let results = {};

  for( let k in samples )
  {
    test.case = k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    let serialized;
    let deserialized;

    try
    {
      serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ k ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }

    if( !o2.atLeastOne )
    if( expectedLevel >= currentLevel )
    {
      test.will = 'type should be supporting';
      test.is( results[ k ] );
    }
  }

  console.log( prefix + ' / results: ', _.toStr( results, { levels : 99, multiline : 1 } ) )

  o.supporting = 1;

  for( let k in results )
  {
    o.supporting = results[ k ];

    if( o.supporting && o2.atLeastOne )
    break;

    if( !o.supporting && !o2.atLeastOne )
    break;
  }

  if( o.supporting )
  o.result[ name ] = currentLevel;

  if( expectedLevel >= currentLevel )
  {
    test.will = name + currentLevel +' must be supporting';
    test.is( o.supporting );
  }
  else
  {
    test.will = name + currentLevel +' must not be supporting'
    test.is( !o.supporting )
  }

  o.checks[ name + currentLevel ] = results;

  test.close( prefix );

  return o;
}

//

function primitive1( test, o )
{
  let self = this;

  let samples =
  {
    boolean : true,
    number : 23,
    string : 'something',
  }

  let o2 =
  {
    name : 'primitive',
    samples,
    currentLevel : 1
  }

  self.converterTypesCheck( test, o, o2 )
}

//

function primitive2( test, o )
{
  let self = this;

  let samples =
  {
    null : null,
    '+infinity' : +Infinity,
    '-infinity' : -Infinity,
    nan : NaN,
  }

  let o2 =
  {
    name : 'primitive',
    samples,
    currentLevel : 2
  }

  self.converterTypesCheck( test, o, o2 )
}

//

function primitive3( test, o )
{
  let self = this;

  let samples =
  {
    '+0' : +0,
    '-0' : -0,
    'undefined' : undefined,
    date : new Date()
  }

  if( typeof BigInt !== 'undefined' )
  samples.bigInt = BigInt( 23 );

  let o2 =
  {
    name : 'primitive',
    samples,
    currentLevel : 3
  }

  self.converterTypesCheck( test, o, o2 )
}

//

function regExp1( test, o )
{
  let self = this;

  let samples =
  {
    1 : /ab|cd/,
    2 : /a[bc]d/,
    3 : /ab{1,}bc/,
    4 : /\.js$/,
    5 : /.regexp/
  }

  let o2 =
  {
    name : 'regexp',
    samples,
    currentLevel : 1
  }

  self.converterTypesCheck( test, o, o2 )
}

//

function regExp2( test, o )
{
  let self = this;

  let samples =
  {
    0 : /^(?:(?!ab|cd).)+$/gm,
    1 : /\/\*[\s\S]*?\*\/|\/\/.*/g,
    2 : /^[1-9]+[0-9]*$/gm,
    3 : /aBc/i,
    4 : /^\d+/gm,
    5 : /^a.*c$/g,
    6 : /[a-z]/m,
    7 : /^[A-Za-z0-9]$/
  }

  let o2 =
  {
    name : 'regexp',
    samples,
    currentLevel : 2
  }

  self.converterTypesCheck( test, o, o2 )
}

//

function buffer1( test, o )
{
  let self = this;

  let samples =
  {
    raw : new BufferRaw([ 99,100,101 ]),
    bytes : new U8x([ 99,100,101 ]),
  }

  if( typeof BufferNode !== 'undefined' )
  samples.node = BufferNode.from([ 99,100,101 ]);

  let o2 =
  {
    name : 'buffer',
    samples,
    currentLevel : 1,
    atLeastOne : 1
  }

  self.converterTypesCheck( test, o, o2 );
}

//

function buffer2( test, o )
{
  let self = this;

  let samples =
  {
    raw : new BufferRaw([ 99,100,101 ]),
  }

  let o2 =
  {
    name : 'buffer',
    samples,
    currentLevel : 2,
  }

  self.converterTypesCheck( test, o, o2 );
}

//

function buffer3( test, o )
{
  let self = this;

  let samples =
  {
    raw : new BufferRaw([ 99,100,101 ]),
    bytes : new U8x([ 99,100,101 ]),
  }

  if( typeof BufferNode !== 'undefined' )
  samples.node = BufferNode.from([ 99,100,101 ]);

  let o2 =
  {
    name : 'buffer',
    samples,
    currentLevel : 3,
  }

  self.converterTypesCheck( test, o, o2 );
}

//

function structure1( test, o )
{
  let self = this;

  let array =
  {
    array : [ 'a', 23,  false ],
  }

  let map =
  {
    boolean : true,
    number : 23,
    string : 'a'
  }

  //

  let samples =
  {
    array,
    map,
  }

  let o2 =
  {
    name : 'structure',
    samples,
    currentLevel : 1,
  }

  self.converterTypesCheck( test, o, o2 );
}

//

function structure2( test, o )
{
  let self = this;

  let withNestedArray =
  {
    array : [ [ 'a', 23 ], [ [ {}, false ] ] ],
  }

  let withNestedMap =
  {
    map : { a : '1', dir : { b : 2 }, c : { a : { b : 1 } } }
  }

  let withArrayAndMap =
  {
    map : { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] },
    array : [ { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] } ],
  }

  //

  let samples =
  {
    mapWithNestedArrays : withNestedArray,
    mapWithNestedMaps : withNestedMap,
    mapWithArrayAndMap : withArrayAndMap
  }

  let o2 =
  {
    name : 'structure',
    samples,
    currentLevel : 2,
  }

  self.converterTypesCheck( test, o, o2 );
}

//

function structure3( test, o )
{
  let self = this;

  let recursion =
  {
    map : { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] },
    array : [ { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] } ],
  }
  recursion.self = recursion;

  let samples =
  {
    recursion,
  }

  let o2 =
  {
    name : 'structure',
    samples,
    currentLevel : 3,
  }

  self.converterTypesCheck( test, o, o2 );
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

//

function select( test )
{
  let self = this;

  test.case = 'all'
  var got = _.Gdf.Select({});
  test.is( got.length === _.Gdf.Elements.length );

  test.case = 'in'
  var got = _.Gdf.Select({ in : 'structure' });
  test.ge( got.length, 1 );

  test.case = 'out'
  var got = _.Gdf.Select({ out : 'string' });
  test.ge( got.length, 1 );

  test.case = 'not existing'

  var got = _.Gdf.Select({ in : 'not existing'});
  test.is( !got.length );

  var got = _.Gdf.Select({ out : 'not existing'});
  test.is( !got.length );

  var got = _.Gdf.Select({ ext : 'not existing' });
  test.is( !got.length );

  test.case = 'default';

  var got = _.Gdf.Select({ in : 'structure', out : 'string' });
  test.is( got.length > 1 );
  var got = _.Gdf.Select({ in : 'structure', out : 'string', default : 1 });
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
  test.shouldThrowErrorSync( () => _.Gdf.Select({ ext : [ 'json.fine', 'json' ] }) );

}

// --
// declare
// --

var Self =
{

  name : 'Tools.base.gdf',
  silencing : 1,

  context :
  {
    converterTypesCheck,

    primitive1,
    primitive2,
    primitive3,
    regExp1,
    regExp2,
    buffer1,
    buffer2,
    buffer3,
    structure1,
    structure2,
    structure3,
  },

  tests :
  {

    trivial,
    select,
    registerAndFinit,

    //

    jsonFine,
    jsonMin,
    json,
    cson,
    js,
    bson,
    cbor,
    yml,

    base64,
    utf8,

    //

    supportedTypes,

  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
