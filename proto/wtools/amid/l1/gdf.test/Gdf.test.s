( function _Gdf_test_s_( )
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
  let context = this;

  let samples = o2.samples;
  let currentLevel = o2.currentLevel;
  let name = o2.name;
  _.assert( _.aux.is( o.serializer.encoder.feature ), `${o.serializer.ext} is not feature` );
  // _.assert( o.serializer.encoder.feature, `${o.serializer.ext} is not feature` );
  let expectedLevel = o.serializer.encoder.feature[ name ];

  let prefix = o.serializer.ext + ' / ' + name + currentLevel;

  test.open( prefix );

  let results = {};

  for( let k in samples )
  {
    test.case = k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    let serialized, deserialized;

    try
    {
      serialized = o.serializer.encode({ data : src });
      deserialized = o.deserializer.encode({ data : serialized.out.data });
      results[ k ] = _.entityIdentical( deserialized.out.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }

    if( !o2.atLeastOne )
    if( expectedLevel >= currentLevel )
    {
      test.will = 'type should be feature';
      test.true( results[ k ] );
    }
  }

  console.log( prefix + ' / results: ', _.entity.exportString( results, { levels : 99, multiline : 1 }) )

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
    test.true( o.feature );
  }
  else
  {
    test.will = name + currentLevel +' must not be feature'
    test.true( !o.feature )
  }

  o.checks[ name + currentLevel ] = results;

  test.close( prefix );

  return o;
}

//

function primitive1( test, o )
{
  let context = this;

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

  context.converterTypesCheck( test, o, o2 )
}

//

function primitive2( test, o )
{
  let context = this;

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

  context.converterTypesCheck( test, o, o2 )
}

//

function primitive3( test, o )
{
  let context = this;

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

  context.converterTypesCheck( test, o, o2 )
}

//

function regExp1( test, o )
{
  let context = this;

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

  context.converterTypesCheck( test, o, o2 )
}

//

function regExp2( test, o )
{
  let context = this;

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

  context.converterTypesCheck( test, o, o2 )
}

//

function buffer1( test, o )
{
  let context = this;

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

  context.converterTypesCheck( test, o, o2 );
}

//

function buffer2( test, o )
{
  let context = this;

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

  context.converterTypesCheck( test, o, o2 );
}

//

function buffer3( test, o )
{
  let context = this;

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

  context.converterTypesCheck( test, o, o2 );
}

//

function structure1( test, o )
{
  let context = this;

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

  /* */

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

  context.converterTypesCheck( test, o, o2 );
}

//

function structure2( test, o )
{
  let context = this;

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

  /* */

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

  context.converterTypesCheck( test, o, o2 );
}

//

function structure3( test, o )
{
  let context = this;

  let recursion =
  {
    map : { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] },
    array : [ { a : '1', dir : { b : 2 }, c : [ 1, 2, 3 ] } ],
  }
  recursion.context = recursion;

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

  context.converterTypesCheck( test, o, o2 );
}

// --
// test
// --

function supportedTypes( test )
{
  let context = this;

  let Converters =
  {

    'bson' :
    {
      serializer : { inFormat : 'structure', outFormat : 'buffer.node', ext : 'bson' },
      deserializer : { inFormat : 'buffer.node', outFormat : 'structure', ext : 'bson' }
    },

    'json.fine' :
    {
      serializer : { inFormat : 'structure', outFormat : 'string', ext : 'json.fine' },
      deserializer : { inFormat : 'string', outFormat : 'structure', ext : 'json' }
    },

    'json' :
    {
      serializer : { inFormat : 'structure', outFormat : 'string', ext : 'json' },
      deserializer : { inFormat : 'string', outFormat : 'structure', ext : 'json' }
    },

    'cson' :
    {
      serializer : { inFormat : 'structure', outFormat : 'string', ext : 'cson' },
      deserializer : { inFormat : 'string', outFormat : 'structure', ext : 'cson' }
    },

    'js' :
    {
      serializer : { inFormat : 'structure', outFormat : 'string', ext : 'js' },
      deserializer : { inFormat : 'string', outFormat : 'structure', ext : 'js' }
    },

    'cbor' :
    {
      serializer : { inFormat : 'structure', outFormat : 'buffer.node', ext : 'cbor' },
      deserializer : { inFormat : 'buffer.node', outFormat : 'structure', ext : 'cbor' }
    },

    'yml' :
    {
      serializer : { inFormat : 'structure', outFormat : 'string', ext : 'yml' },
      deserializer : { inFormat : 'string', outFormat : 'structure', ext : 'yml' }
    },

    'msgpack.lite' : /* qqq : switch it on */
    {
      serializer : { inFormat : 'structure', outFormat : 'buffer.node', ext : 'msgpack.lite' },
      deserializer : { inFormat : 'buffer.node', outFormat : 'structure', ext : 'msgpack.lite' }
    },

  }

  let data = [];

  for( let c in Converters )
  {
    let converter = Converters[ c ];

    /* */

    test.case = 'select';

    var serializer = _.gdf.selectContext( converter.serializer );
    test.identical( serializer.length, 1 );
    serializer = serializer[ 0 ];

    var deserializer = _.gdf.selectContext( converter.deserializer );
    test.identical( deserializer.length, 1 );
    deserializer = deserializer[ 0 ];

    let options =
    {
      result :
      {
        primitive : 0,
        regexp : 0,
        buffer : 0,
        structure : 0
      },
      serializer,
      deserializer,
      checks : {}
    }

    context.primitive1( test, options );
    context.primitive2( test, options );
    context.primitive3( test, options );
    context.regExp1( test, options );
    context.regExp2( test, options );
    context.buffer1( test, options );
    context.buffer2( test, options );
    context.buffer3( test, options );
    context.structure1( test, options );
    context.structure2( test, options );
    context.structure3( test, options );

    test.contains( serializer.encoder.feature, options.result );

    let r = options.result;

    data.push( [ serializer.ext, r.primitive, r.regexp, r.buffer, r.structure ] )
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

supportedTypes.timeOut = 40000;

//

function trivial( test )
{
  let context = this;

  /* */

  test.case = 'select';
  var src = 'val : 13';
  var converters = _.gdf.selectContext({ inFormat : 'string', outFormat : 'structure', ext : 'cson' });
  test.identical( converters.length, 1 );

  /* */

  test.case = 'encode with format';
  var dst = converters[ 0 ].encode({ data : src, format : 'string' });
  var expected =
  {
    'params' : {},
    'err' : null,
    'sync' : true,
    'in' : { 'data' : 'val : 13', 'format' : 'string', 'filePath' : null, 'ext' : null },
    'out' :
    {
      'data' : { 'val' : 13 },
      'format' : 'structure',
    },
  }
  test.identical( dst, expected );

  /* */

  test.case = 'encode without format';
  var dst = converters[ 0 ].encode({ data : src });
  var expected =
  {
    'params' : {},
    'err' : null,
    'sync' : true,
    'in' : { 'data' : 'val : 13', 'format' : 'string', 'filePath' : null, 'ext' : null },
    'out' :
    {
      'data' : { 'val' : 13 },
      'format' : 'structure'
    }
  }
  test.identical( dst, expected );

  /* */

}

//

function select( test )
{
  let context = this;

  /* */

  test.case = 'all';
  var got = _.gdf.selectContext({});
  test.ge( got.length, 1 );
  test.le( got.length, _.gdf.encodersArray.length );

  /* */

  test.case = 'all single : 1';
  var got = _.gdf.selectContext({ single : 1 });
  test.ge( got.length, 1 );
  test.le( got.length, _.gdf.encodersArray.length );

  /* */

  test.case = 'all single : 0';
  var got = _.gdf.selectContext({ single : 0 });
  test.true( got.length === _.gdf.encodersArray.length );

  /* */

  test.case = 'inFormat';
  var got = _.gdf.selectContext({ inFormat : 'structure' });
  test.ge( got.length, 1 );

  /* */

  test.case = 'outFormat';
  var got = _.gdf.selectContext({ outFormat : 'string' });
  test.ge( got.length, 1 );

  /* */

  test.case = 'not existing'

  var got = _.gdf.selectContext({ inFormat : 'not existing' });
  test.true( !got.length );

  var got = _.gdf.selectContext({ outFormat : 'not existing' });
  test.true( !got.length );

  var got = _.gdf.selectContext({ ext : 'not existing' });
  test.true( !got.length );

  test.case = 'default';

  var got = _.gdf.selectContext({ inFormat : 'structure', outFormat : 'string' });
  test.true( got.length === 1 );
  var got = _.gdf.selectContext({ inFormat : 'structure', outFormat : 'string', single : 0 });
  test.true( got.length > 1 );
  var got = _.gdf.selectContext({ inFormat : 'structure', outFormat : 'string', single : 1 });
  test.true( got.length === 1 );
  test.identical( got[ 0 ].shortName, 'json.min' );

  if( !Config.debug )
  return;

  test.case = 'not feature value'

  test.shouldThrowErrorSync( () => _.gdf.selectContext() );
  test.shouldThrowErrorSync( () => _.gdf.selectContext({ ext : [ 'json.fine', 'json' ] }) );

}

//

function selectWithFeature( test )
{
  let context = this;

  /* */

  test.case = 'json.fine';
  var encoders = _.gdf.select
  ({
    inFormat : 'structure',
    outFormat : 'string',
    ext : 'json',
    feature : { fine : 1 },
  });
  var exp = [ _.gdf.extMap[ 'json.fine' ][ 0 ] ];
  test.identical( encoders, exp );

  var got = encoders[ 0 ].encode({ data : { a : 1 } }).out.data;
  var exp = '{ "a" : 1 }';
  test.identical( got, exp );

  /* */

  test.case = 'json.min';
  var encoders = _.gdf.select
  ({
    inFormat : 'structure',
    outFormat : 'string',
    ext : 'json',
    feature : { min : 1 },
  });
  var exp = [ _.gdf.extMap[ 'json.min' ][ 0 ] ];
  test.identical( encoders, exp );

  var got = encoders[ 0 ].encode({ data : { a : 1 } }).out.data;
  var exp = '{"a":1}';
  test.identical( got, exp );

  /* */

}

//

function registerAndFinit( test )
{
  let context = this;

  var converter =
  {
    ext : [ 'ext', 'ext.ext2' ],
    inFormat : [ 'string.utf8', 'buffer.utf8', 'testformat1.testformat2' ],
    outFormat : [ 'number.f32', 'number.f64' ],
    feature : {},
    onEncode : function( op )
    {
      _.assert( _.strIs( op.in.data ) );
      op.out.data = Number.parseFloat( op.in.data );
      op.out.format = 'number';
    }
  }

  converter = _.Gdf( converter );

  test.description = 'init';
  test.identical( converter.name, 'ext:string.utf8->number.f32' );
  test.identical( _.longCountElement( _.gdf.encodersArray, converter ), 1 );
  test.identical( _.longCountElement( _.gdf.inMap[ 'string' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.inMap[ 'buffer' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.inMap[ 'utf8' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.inMap[ 'testformat1' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.inMap[ 'testformat2' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.outMap[ 'number' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.outMap[ 'f32' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.outMap[ 'f64' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.extMap[ 'ext' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.extMap[ 'ext.ext2' ], converter ), 1 );
  test.identical( _.longCountElement( _.gdf.extMap[ 'ext2' ] || [], converter ), 0 );
  test.identical( _.longCountElement( _.gdf.inOutMap[ 'string.utf8->number.f32' ], converter ), 1 );

  /* */

  test.description = 'select outFormat';
  var got = _.gdf.selectContext({ outFormat : 'number' });
  test.true( got[ 0 ].encoder === _.gdf.inOutMap[ 'string.utf8->number.f32' ][ 0 ] );
  var got = _.gdf.selectContext({ outFormat : 'f32' });
  test.true( got[ 0 ].encoder === _.gdf.inOutMap[ 'string.utf8->number.f32' ][ 0 ] );
  var got = _.gdf.selectContext({ outFormat : 'f64' });
  test.true( got[ 0 ].encoder === _.gdf.inOutMap[ 'string.utf8->number.f32' ][ 0 ] );

  /* */

  test.description = 'select inFormat';
  var got = _.gdf.selectContext({ inFormat : 'testformat1' });
  test.true( got[ 0 ].encoder === _.gdf.inOutMap[ 'string.utf8->number.f32' ][ 0 ] );
  var got = _.gdf.selectContext({ inFormat : 'testformat2' });
  test.true( got[ 0 ].encoder === _.gdf.inOutMap[ 'string.utf8->number.f32' ][ 0 ] );

  /* */

  test.description = 'finit';
  converter.finit();

  test.identical( _.longCountElement( _.gdf.encodersArray, converter ), 0 );
  test.identical( _.longCountElement( _.gdf.inMap[ 'string' ], converter ), 0 );
  test.identical( _.longCountElement( _.gdf.inMap[ 'buffer' ], converter ), 0 );
  test.identical( _.longCountElement( _.gdf.inMap[ 'utf8' ], converter ), 0 );
  test.identical( _.longCountElement( _.gdf.outMap[ 'number' ], converter ), 0 );
  test.identical( _.longCountElement( _.gdf.outMap[ 'f32' ], converter ), 0 );
  test.identical( _.longCountElement( _.gdf.outMap[ 'f64' ], converter ), 0 );
  test.identical( _.longCountElement( _.gdf.extMap[ 'ext' ], converter ), 0 );
  test.identical( _.longCountElement( _.gdf.inOutMap[ 'string.utf8->number.f32' ], converter ), 0 );

}

// --
// declare
// --

const Proto =
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
    selectWithFeature,
    select,
    registerAndFinit,

  },

};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
