( function _SupportedTypes_test_s_()
{
'use strict';

if( typeof module !== 'undefined' )
{
  var _ = require( '../../../../dwtools/Tools.s' );
  require( '../gdf/Converter.s' );
  _.include( 'wTesting' );
}

var _global = _global_;
var _ = _global_.wTools;

_.assert( _testerGlobal_.wTools !== _global_.wTools );

// --
// contex
// --

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
      serialized = o.serialize.encode( { data : src } );
      // test.identical( serialized.format, o.serializeFormat );

      deserialized = o.deserialize.encode( { data : serialized.data } );
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
    raw : new BufferRaw( [ 99, 100, 101 ] ),
    bytes : new U8x( [ 99, 100, 101 ] ),
  }

  if( typeof BufferNode !== 'undefined' )
  samples.node = BufferNode.from( [ 99, 100, 101 ] );

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
    raw : new BufferRaw( [ 99, 100, 101 ] ),
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
    raw : new BufferRaw( [ 99, 100, 101 ] ),
    bytes : new U8x( [ 99, 100, 101 ] ),
  }

  if( typeof BufferNode !== 'undefined' )
  samples.node = BufferNode.from( [ 99, 100, 101 ] );

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
    array : [ 'a', 23, false ],
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
    map : { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] },
    array : [ { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] } ],
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
    map : { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] },
    array : [ { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] } ],
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

function supportedTypes( test )
{
  var self = this;

  let Converters =
  {
    'bson' :
    {
      serialize : { in : 'structure', out : 'buffer.node', ext : 'bson' },
      deserialize : { in : 'buffer.node', out : 'structure', ext : 'bson' }
    },

    'json.fine' :
    {
      serialize : { in : 'structure', out : 'string', ext : 'json.fine' },
      deserialize : { in : 'string', out : 'structure', ext : 'json', default : 1 }
    },

    'json' :
    {
      serialize : { in : 'structure', out : 'string', ext : 'json', default : 1 },
      deserialize : { in : 'string', out : 'structure', ext : 'json', default : 1 }
    },

    'cson' :
    {
      serialize : { in : 'structure', out : 'string', ext : 'cson' },
      deserialize : { in : 'string', out : 'structure', ext : 'cson' }
    },

    'js' :
    {
      serialize : { in : 'structure', out : 'string', ext : 'js' },
      deserialize : { in : 'string', out : 'structure', ext : 'js' }
    },

    'cbor' :
    {
      serialize : { in : 'structure', out : 'buffer.node', ext : 'cbor' },
      deserialize : { in : 'buffer.node', out : 'structure', ext : 'cbor' }
    },

    'yml' :
    {
      serialize : { in : 'structure', out : 'string', ext : 'yml' },
      deserialize : { in : 'string', out : 'structure', ext : 'yml' }
    },

    // 'msgpack.lite' :
    // {
    //   serialize : { in : 'structure', out : 'buffer.node', ext : 'msgpack.lite' },
    //   deserialize : { in : 'buffer.node', out : 'structure', ext : 'msgpack.lite' }
    // },

    // 'msgpack.wtp' :
    // {
    //   serialize : { in : 'structure', out : 'buffer.node', ext : 'msgpack.wtp' },
    //   deserialize : { in : 'buffer.node', out : 'structure', ext : 'msgpack.wtp' }
    // }
  }

  let data = [];

  for( let c in Converters )
  {
    let converter = Converters[ c ];

    /* */

    test.case = 'select';

    var serialize = _.Gdf.Select( converter.serialize );
    test.identical( serialize.length, 1 );
    serialize = serialize[ 0 ];

    var deserialize = _.Gdf.Select( converter.deserialize );
    test.identical( deserialize.length, 1 );
    deserialize = deserialize[ 0 ];

    let options =
    {
      result :
      {
        primitive : 0,
        regexp : 0,
        buffer : 0,
        structure : 0
      },
      serialize,
      deserialize,
      checks : {}
    }

    self.primitive1( test, options );
    self.primitive2( test, options );
    self.primitive3( test, options );
    self.regExp1( test, options );
    self.regExp2( test, options );
    self.buffer1( test, options );
    self.buffer2( test, options );
    self.buffer3( test, options );
    self.structure1( test, options );
    self.structure2( test, options );
    self.structure3( test, options );

    test.contains( serialize.supporting, options.result );

    let r = options.result;

    data.push( [ serialize.ext, r.primitive, r.regexp, r.buffer, r.structure ] )
  }

  var o =
  {
    data,
    head : [ 'Transformer', 'Primitive(0-3)', 'RegExp(0-2)', 'BufferNode(0-3)', 'Structure(0-3)' ],
    colWidth : 20
  }
  var output = _.strTable( o );
  console.log( output );
}

// --
// declare
// --

var Self =
{

  name : 'Tools.supportedTypes.gdf',
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
    supportedTypes
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )();
