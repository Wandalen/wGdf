( function _Gdf_test_s_( )
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

_.assert( _testerGlobal_.wTools !== _global_.wTools );

// --
// data
// --

/*
qqq :
- please, use lower case for names of routines
- add routines to context of the test
- add static structure feature

let feature =
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

// --
// context
// --

function converterTypesCheck( test, o, o2 )
{
  let self = this;

  let samples = o2.samples;
  let currentLevel = o2.currentLevel;
  let name = o2.name;
  _.assert( o.serialize.feature, `${o.serialize.ext} is not feature` );
  let expectedLevel = o.serialize.feature[ name ];

  let prefix = o.serialize.ext + ' / ' + name + currentLevel;

  test.open( prefix );

  let results = {};

  for( let k in samples )
  {
    test.case = k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    let serialized,
      deserialized;

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
      test.will = 'type should be feature';
      test.is( results[ k ] );
    }
  }

  console.log( prefix + ' / results: ', _.toStr( results, { levels : 99, multiline : 1 }) )

  o.feature = 1;

  for( let k in results )
  {
    o.feature = results[ k ];

    if( o.feature && o2.atLeastOne )
    break;

    if( !o.feature && !o2.atLeastOne )
    break;
  }

  if( o.feature )
  o.result[ name ] = currentLevel;

  if( expectedLevel >= currentLevel )
  {
    test.will = name + currentLevel +' must be feature';
    test.is( o.feature );
  }
  else
  {
    test.will = name + currentLevel +' must not be feature'
    test.is( !o.feature )
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
    'null' : null,
    '+infinity' : +Infinity,
    '-infinity' : -Infinity,
    'nan' : NaN,
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
    undefined,
    'date' : new Date()
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

    // 'msgpack.lite' : /* qqq : switch it on */
    // {
    //   serialize : { in : 'structure', out : 'buffer.node', ext : 'msgpack.lite' },
    //   deserialize : { in : 'buffer.node', out : 'structure', ext : 'msgpack.lite' }
    // },

  }

  let data = [];

  for( let c in Converters )
  {
    let converter = Converters[ c ];

    /* */

    test.case = 'select';

    var serialize = _.gdf.select( converter.serialize );
    test.identical( serialize.length, 1 );
    serialize = serialize[ 0 ];

    var deserialize = _.gdf.select( converter.deserialize );
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

    test.contains( serialize.feature, options.result );

    let r = options.result;

    data.push( [ serialize.ext, r.primitive, r.regexp, r.buffer, r.structure ] )
  }

  var o =
  {
    data,
    topHead : [ 'Transformer', 'Primitive(0-3)', 'RegExp(0-2)', 'BufferNode(0-3)', 'Structure(0-3)' ],
    dim : onTableDim( data ),
    style : 'doubleBorder',
    colSplits : 1,
    rowSplits : 1,
    onCellGet,
  }
  // var output = _.strTable_old( o );
  // console.log( data );
  var output = _.strTable( o );
  console.log( output.result );

  /* */

  function onTableDim( table )
  {
    let result = [ table.length, table[ 0 ].length ];
    // console.log( 'onTableDim', result );
    return result;
  }

  /* */

  function onCellGet( i2d, o )
  {
    let row = o.data[ i2d[ 0 ] ];
    let result = row[ i2d[ 1 ] ];
    // console.log( 'i2d', i2d, result );
    _.assert( result !== undefined );
    return String( result );
  }

}

supportedTypes.timeOut = 20000;

//

function trivial( test )
{
  var self = this;

  /* */

  test.case = 'select';
  var src = 'val : 13';
  var converters = _.gdf.select({ in : 'string', out : 'structure', ext : 'cson', default : 1 });
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
  var got = _.gdf.select({});
  test.is( got.length === _.gdf.convertersArray.length );

  test.case = 'in'
  var got = _.gdf.select({ in : 'structure' });
  test.ge( got.length, 1 );

  test.case = 'out'
  var got = _.gdf.select({ out : 'string' });
  test.ge( got.length, 1 );

  test.case = 'not existing'

  var got = _.gdf.select({ in : 'not existing' });
  test.is( !got.length );

  var got = _.gdf.select({ out : 'not existing' });
  test.is( !got.length );

  var got = _.gdf.select({ ext : 'not existing' });
  test.is( !got.length );

  test.case = 'default';

  var got = _.gdf.select({ in : 'structure', out : 'string' });
  test.is( got.length > 1 );
  var got = _.gdf.select({ in : 'structure', out : 'string', default : 1 });
  test.is( got.length === 1 );
  test.identical( got[ 0 ].shortName, 'json.min' );

  // test.case = 'shortName';

  // var got = _.gdf.select({ shortName : 'json.fine', out : 'string' });
  // test.is( got.length === 1 );
  // test.identical( got[ 0 ].shortName, 'json.fine' );

  if( !Config.debug )
  return;

  test.case = 'not feature value'

  test.shouldThrowErrorSync( () => _.gdf.select() );
  test.shouldThrowErrorSync( () => _.gdf.select({ ext : [ 'json.fine', 'json' ] }) );

}

//

function registerAndFinit( test )
{
  let self = this;

  var converter =
  {
    ext : [ 'ext' ],
    in : [ 'string' ],
    out : [ 'number' ],
    feature : {},
    onEncode : function( op )
    {
      _.assert( _.strIs( op.in.data ) );
      op.out.data = Number.parseFloat( op.in.data );
      op.out.format = 'number';
    }
  }

  converter = _.Gdf( converter );

  test.is( _.longHas( _.gdf.convertersArray, converter ) );
  test.is( _.longHas( _.gdf.inMap[ 'string' ], converter ) );
  test.is( _.longHas( _.gdf.outMap[ 'number' ], converter ) );
  test.is( _.longHas( _.gdf.extMap[ 'ext' ], converter ) );
  test.is( _.longHas( _.gdf.inOutMap[ 'string-number' ], converter ) );

  converter.finit();

  test.is( !_.longHas( _.gdf.convertersArray, converter ) );
  test.is( !_.longHas( _.gdf.inMap[ 'string' ], converter ) );
  test.is( !_.longHas( _.gdf.outMap[ 'number' ], converter ) );
  test.is( !_.longHas( _.gdf.extMap[ 'ext' ], converter ) );
  test.is( !_.longHas( _.gdf.inOutMap[ 'string-number' ], converter ) );
}

// --
// declare
// --

let Self =
{

  name : 'Tools.gdf',
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

    supportedTypes,

    trivial,
    select,
    registerAndFinit,

  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
