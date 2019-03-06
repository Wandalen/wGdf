( function _Gdf_test_s_( ) {

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

let Supported =
{
  'bson' :
  {
    primitive : 2,
    regexp : 2,
    buffer : 0,
    complex : 1
  },
  'yaml' :
  {
    primitive : 2,
    regexp : 2,
    buffer : 1,
    complex : 2
  },
  'cbor' :
  {
    primitive : 2,
    regexp : 1,
    buffer : 1,
    complex : 1
  },
  'js' :
  {
    primitive : 3,
    regexp : 2,
    buffer : 3,
    complex : 2
  },
  'cson' :
  {
    primitive : 1,
    regexp : 2,
    buffer : 2,
    complex : 1
  },
  'json.fine' :
  {
    primitive : 1,
    regexp : 0,
    buffer : 0,
    complex : 1
  },
  'json.min' :
  {
    primitive : 1,
    regexp : 0,
    buffer : 0,
    complex : 1
  }
}

//

function diagnosticsStructureGenerate( o )
{
  _.assert( arguments.length === 1 )
  _.routineOptions( diagnosticsStructureGenerate, o );
  _.assert( _.numberIs( o.breadth ) );
  _.assert( _.numberIs( o.depth ) );

  let structure = Object.create( null );

  for( let b = 0; b < o.breadth; b++ )
  {
    structure[ b ] = singleLevelMake();
  }

  // var buffer = _.bufferBytesFrom( JSON.stringify( structure ) );
  // console.log( _.strMetricFormatBytes( buffer.byteLength ) )

  return structure;

  /*  */

  function singleLevelMake()
  {
    let singleLevel = Object.create( null );

    if( o.boolean )
    singleLevel[ 'boolean' ] = true;

    if( o.number )
    singleLevel[ 'number' ] = 0;

    if( o.signedNumber )
    {
      singleLevel[ '-0' ] = -0;
      singleLevel[ '+0' ] = +0;
    }

    if( o.string )
    singleLevel[ 'string' ] = 'string';

    if( o.null )
    singleLevel[ 'null' ] = null;

    if( o.infinity )
    {
      singleLevel[ '+infinity' ] = +Infinity;
      singleLevel[ '-infinity' ] = -Infinity;
    }

    if( o.nan )
    singleLevel[ 'nan' ] = NaN;

    if( o.undefined )
    singleLevel[ 'undefined' ] = undefined;

    if( o.date )
    singleLevel[ 'date' ] = new Date();

    if( o.bigInt )
    if( typeof BigInt !== 'undefined' )
    singleLevel[ 'bigInt' ] = BigInt( 1 );

    if( o.regexp )
    {
      singleLevel[ 'regexp1'] = /ab|cd/,
      singleLevel[ 'regexp2'] = /a[bc]d/,
      singleLevel[ 'regexp3'] = /ab{1,}bc/,
      singleLevel[ 'regexp4'] = /\.js$/,
      singleLevel[ 'regexp5'] = /.regexp/
    }

    if( o.regexpComplex )
    {
      singleLevel[ 'complexRegexp0' ] = /^(?:(?!ab|cd).)+$/gm,
      singleLevel[ 'complexRegexp1' ] = /\/\*[\s\S]*?\*\/|\/\/.*/g,
      singleLevel[ 'complexRegexp2' ] = /^[1-9]+[0-9]*$/gm,
      singleLevel[ 'complexRegexp3' ] = /aBc/i,
      singleLevel[ 'complexRegexp4' ] = /^\d+/gm,
      singleLevel[ 'complexRegexp5' ] = /^a.*c$/g,
      singleLevel[ 'complexRegexp6' ] = /[a-z]/m,
      singleLevel[ 'complexRegexp7' ] = /^[A-Za-z0-9]$/
    }

    if( o.bufferNode )
    if( typeof Buffer !== 'undefined' )
    singleLevel[ 'bufferNode'] = Buffer.from([ 99,100,101 ]);

    if( o.bufferRaw )
    singleLevel[ 'bufferRaw'] = new ArrayBuffer([ 99,100,101 ]);

    if( o.bufferBytes )
    singleLevel[ 'bufferBytes'] = new Uint8Array([ 99,100,101 ]);

    if( o.map )
    singleLevel[ 'map' ] = { a : 'string', b : 1, c : true  };

    if( o.mapComplex )
    singleLevel[ 'mapComplex' ] = { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] };

    if( o.array )
    singleLevel[ 'array' ] = [ 'string', 1,  true ];

    if( o.arrayComplex )
    singleLevel[ 'arrayComplex' ] = [ { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] } ]

    if( o.recursion )
    {
      //
    }

    if( !o.depth )
    return singleLevel;

    /**/

    let currentLevel = singleLevel;
    let srcMap = _.mapExtend( null, singleLevel );

    for( let d = 0; d < o.depth; d++ )
    {
      let level = 'level' + d;
      currentLevel[ level ] = _.mapExtend( null, srcMap );
      currentLevel = currentLevel[ level ];
    }

    return singleLevel;
  }

}

diagnosticsStructureGenerate.defaults =
{
  depth : null,
  breadth : null,
  size : null,

  /**/

  boolean : null,
  number : null,
  signedNumber : null,
  string : null,
  null : null,
  infinity : null,
  nan : null,
  undefined : null,
  date : null,
  bigInt : null,

  /**/

  regexp : null,
  regexpComplex : null,

  /**/

  bufferNode : null,
  bufferRaw : null,
  bufferBytes : null,

  /**/

  array : null,
  arrayComplex : null,
  map : null,
  mapComplex : null

}


//

/*
qqq :
- please, use lower case for names of routines
- add routines to context of the test
- add static structure supported

let supported =
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

function primitive1( test, o )
{
  let samples =
  {
    boolean : true,
    number : 23,
    string : 'something',
  }

  let results = {};

  for( let k in samples )
  {
    test.case = test.name + '.Primitive1: ' + k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ k ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }
  }

  console.log( test.name + '.Primitive1: ', _.toStr( results, { levels : 1 } ) )

  for( let k in results )
  if( !results[ k ] )
  return;

  o.result.primitive += 1;
}

//

function primitive2( test, o )
{
  let samples =
  {
    null : null,
    '+infinity' : +Infinity,
    '-infinity' : -Infinity,
    nan : NaN,
  }

  let results = {};

  for( let k in samples )
  {
    test.case = test.name + '.Primitive2: ' + k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );
      results[ k ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }
  }

  console.log( test.name + '.Primitive2: ', _.toStr( results, { levels : 1 } ))

  for( let k in results )
  if( !results[ k ] )
  return;

  o.result.primitive += 1;
}

//

function primitive3( test, o )
{
  let samples =
  {
    '+0' : +0,
    '-0' : -0,
    'undefined' : undefined,
    date : new Date()
  }

  if( typeof BigInt !== 'undefined' )
  samples.bigInt = BigInt( 23 );

  let results = {};

  for( let k in samples )
  {
    test.case = test.name + '.Primitive3: ' + k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );
      results[ k ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }
  }

  console.log( test.name + '.Primitive3: ', _.toStr( results, { levels : 1 } ))

  for( let k in results )
  if( !results[ k ] )
  return;

  o.result.primitive += 1;
}

//

function regExp1( test, o )
{
  let samples =
  {
    1 : /ab|cd/,
    2 : /a[bc]d/,
    3 : /ab{1,}bc/,
    4 : /\.js$/,
    5 : /.regexp/
  }

  let results = {};

  for( let k in samples )
  {
    test.case = test.name + '.RegExp1: ' + samples[ k ].toString();
    let src = {};
    src[ k ] = samples[ k ];

    results[ samples[ k ].toString() ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ samples[ k ].toString() ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }
  }

  console.log( test.name + '.RegExp1: ', _.toStr( results, { levels : 1 } ))

  for( let k in results )
  if( !results[ k ] )
  return;

  o.result.regexp += 1;
}

//

function regExp2( test, o )
{
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

  let results = {};

  for( let k in samples )
  {
    test.case = test.name + '.RegExp2: ' + samples[ k ].toString();
    let src = {};
    src[ k ] = samples[ k ];

    results[ samples[ k ].toString() ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ samples[ k ].toString() ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }
  }

  console.log( test.name + '.RegExp2: ', _.toStr( results, { levels : 1 } ))

  for( let k in results )
  if( !results[ k ] )
  return;

  o.result.regexp += 1;
}

//

function buffer1( test, o )
{
  let samples =
  {
    raw : new ArrayBuffer([ 99,100,101 ]),
    bytes : new Uint8Array([ 99,100,101 ]),
  }

  if( typeof Buffer !== 'undefined' )
  samples.node = Buffer.from([ 99,100,101 ]);

  let results = {};
  let positive = 0;

  for( let k in samples )
  {
    test.case = test.name + '.Buffer1: ' + k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ k ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }

    if( results[ k ] )
    positive += 1;
  }

  // test.will = 'at least one buffer is supported';
  // test.is( positive );

  console.log( test.name + '.Buffer1: ', _.toStr( results, { levels : 1 } ))

  if( positive )
  o.result.buffer += 1;
}

//

function buffer2( test, o )
{
  let samples =
  {
    raw : new ArrayBuffer([ 99,100,101 ]),
  }

  let results = {};
  let positive = 0;

  for( let k in samples )
  {
    test.case = test.name + '.Buffer1: ' + k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ k ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }

    if( results[ k ] )
    positive += 1;
  }

  // test.will = 'at least one buffer is supported';
  // test.is( positive > 0 );
  // test.will = 'buffer raw must be supported';
  // test.is( results.raw );

  console.log( test.name + '.Buffer2: ', _.toStr( results, { levels : 1 } ))

  if( results.raw )
  o.result.buffer += 1;
}

//

function buffer3( test, o )
{
  let samples =
  {
    raw : new ArrayBuffer([ 99,100,101 ]),
    bytes : new Uint8Array([ 99,100,101 ]),
  }

  if( typeof Buffer !== 'undefined' )
  samples.node = Buffer.from([ 99,100,101 ]);

  let results = {};
  let positive = 0;

  for( let k in samples )
  {
    test.case = test.name + '.Buffer3: ' + k;
    let src = {};
    src[ k ] = samples[ k ];

    results[ k ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ k ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }

    if( results[ k ] )
    positive += 1;
  }

  let allSupported = positive === _.mapOwnKeys( samples );
  // test.will = 'all buffers must be supported';
  // test.is( allSupported );

  console.log( test.name + '.Buffer3: ', _.toStr( results, { levels : 1 } ))

  if( allSupported )
  o.result.buffer += 1;
}

//

function complex1( test, o )
{
  let withArray =
  {
    array : [ 'a', 23,  false ],
  }

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
    mapWithArray : withArray,
    mapWithNestedArrays : withNestedArray,
    mapWithNestedMaps : withNestedMap,
    mapWithArrayAndMap : withArrayAndMap
  }

  let results = {};

  for( let k in samples )
  {
    test.case = test.name + '.Complex1: ' + k;
    let src = samples[ k ];

    results[ k ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ k ] = _.entityIdentical( deserialized.data, src );

    }
    catch( err )
    {
      _.errLogOnce( err );
    }
  }

  console.log( test.name + '.Complex1: ', _.toStr( results, { levels : 1 } ))

  for( let k in results )
  if( !results[ k ] )
  return;

  o.result.complex += 1;
}

//

function complex2( test, o )
{
  let recursion =
  {
    map : { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] },
    array : [ { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] } ],
  }
  recursion.self = recursion;

  let samples =
  {
    recursion : recursion,
  }

  let results = {};

  for( let k in samples )
  {
    test.case = test.name + '.Complex2: ' + k;
    let src = samples[ k ];

    results[ k ] = false;

    try
    {
      let serialized = o.serialize.encode({ data : src });
      // test.identical( serialized.format, o.serializeFormat );

      let deserialized = o.deserialize.encode({ data : serialized.data });
      // test.identical( deserialized.format, o.deserializeFormat );

      results[ k ] = _.entityIdentical( deserialized.data, src );
    }
    catch( err )
    {
      _.errLogOnce( err );
    }

  }

  console.log( test.name + '.Complex2: ', _.toStr( results, { levels : 1 } ))

  for( let k in results )
  if( !results[ k ] )
  return;

  o.result.complex += 1;
}

// --
// test
// --

//

function trivial( test )
{
  var self = this;

  /* */

  test.case = 'select';
  var src = 'val : 13';
  var converters = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'cson', default : 1 });
  test.identical( converters.length, 1 );

  /* */

  test.case = 'encode with converter';
  var dst = converters[ 0 ].encode({ data : src, format : 'string' });
  var expected = { data : { val : 13 }, format : 'structure' }
  test.identical( dst, expected );

  /* */

  test.case = 'encode without converter';
  var dst = converters[ 0 ].encode({ data : src });
  var expected = { data : { val : 13 }, format : 'structure' }
  test.identical( dst, expected );

}

//

function json( test )
{
  var self = this;

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  //

  test.case = 'number';
  var data = '1.12345';
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, 1.12345 );

  test.case = 'string';
  var data = '"1.12345"';
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, '1.12345' );

  test.case = 'null';
  var data = 'null';
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, null );

  test.case = 'array';
  var data = '[0, 1, 2]';
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, [ 0,1,2 ] );

  test.case = 'map';
  var data = '{"0": 0, "1": 1, "2": 2}';
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, { 0 : 0, 1 : 1, 2 : 2 } );

  test.case = 'date as string';
  var data = '2019-02-06T14:50:01.641Z"'
  test.shouldThrowErrorSync( () => deserialize.encode({ data : data }) );

  test.case = 'date as map field';
  var data = '{ "date" : "2019-02-06T14:50:01.641Z" }'
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, { date : '2019-02-06T14:50:01.641Z' } );

  test.case = 'map';
  var data = '{ "a" : "1", "dir" : { "b" : 2 }, "c" : [ 1,2,3 ] }';
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] } );

  test.case = 'regexp';
  var data = '/.regexp/g';
  test.shouldThrowErrorSync( () => deserialize.encode({ data : data }) );

  test.case = 'buffer';
  var data = '( new Uint16Array([ 1,2,3 ]) )';
  test.shouldThrowErrorSync( () => deserialize.encode({ data : data }) );

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
  var data = _.toStr( src, { jsonLike : 1 } )
  var deserialized = deserialize.encode({ data : data });
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
  var data = _.toStr( src, { jsonLike : 1 } )
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, src );

  test.case = 'array'
  var src =
  [ 0,
    [ 1,
      [ 2,
        [ 3 ]
      ]
    ]
  ]
  var data = _.toStr( src, { jsonLike : 1 } )
  var deserialized = deserialize.encode({ data : data });
  test.identical( deserialized.data, src );

  test.case = 'complicated map with unsupported type';
  var data = _.toStr( SamplesComplicated, { jsonLike : 1 } );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : data }) );

  test.case = 'complicated map, written by json.fine'
  var src =
  {
    string : 'string',
    number : 1,
    array : [ 1, 'string' ],
    date : new Date( Date.UTC( 2018,1,1 ) ),
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
    date : new Date( Date.UTC( 2018,1,1 ) ).toJSON(),
    map : { string : 'string', number : 1, array : [ 'string', 1 ] }
  }
  test.identical( deserialized.data, expected );

  test.case = 'complicated map, written by json.min'
  var src =
  {
    string : 'string',
    number : 1,
    array : [ 1, 'string' ],
    date : new Date( Date.UTC( 2018,1,1 ) ),
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
    date : new Date( Date.UTC( 2018,1,1 ) ).toJSON(),
    map : { string : 'string', number : 1, array : [ 'string', 1 ] }
  }
  test.identical( deserialized.data, expected );
}

//

function jsonFine( test )
{
  var self = this;

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* json.fine */

  test.case = 'select json.fine';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json.fine' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];
  test.identical( serialize.shortName, 'json.fine' );

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

  test.case = 'all complicated together';
  var serialized = serialize.encode({ data : SamplesComplicated });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) );

  test.case = 'typed array';
  var src = { typed :  new Uint16Array([ 1,2,3 ]) }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) );

  test.case = 'regexp';
  var src = { regexp :  /.regexp/g }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) );

  test.case = 'infinity';
  var src = { infinity : -Infinity }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) );

  test.case = 'NaN';
  var src = { nan : NaN }
  var serialized = serialize.encode({ data : src });
  test.identical( serialized.format, 'string' );
  test.is( _.strIs( serialized.data ) );
  test.shouldThrowErrorSync( () => deserialize.encode({ data : serialized.data }) );

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

//

function jsonMin( test )
{
  let self = this;

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
  var src = { typed :  new Uint16Array([ 1,2,3 ]) }
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

function cbor( test )
{
  var self = this;

  /* */

  test.case = 'select';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'buffer.node', ext : 'cbor' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'buffer.node', out : 'structure', ext : 'cbor' });
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

//

function base64( test )
{
  var self = this;

  var src = 'Lorem Ipsum is simply dummy text.';
  var buffer = _.bufferBytesFrom( src );

  test.case = 'buffer.bytes <-> string/base64';

  var serialize = _.Gdf.Select({ in : 'buffer.bytes', out : 'string/base64', ext : 'base64' });
  test.identical( serialize.length, 1 );
  let base64FromBuffer = serialize[ 0 ];

  var serialize = _.Gdf.Select({ out : 'buffer.bytes', in : 'string/base64', ext : 'base64' });
  test.identical( serialize.length, 1 );
  let base64ToBuffer = serialize[ 0 ];

  var converted = base64FromBuffer.encode({ data : buffer });
  test.identical( converted.format, 'string/base64' );
  test.is( _.strIs( converted.data ) );

  var converted = base64ToBuffer.encode({ data : converted.data });
  test.identical( converted.format, 'buffer.bytes' );
  test.is( _.bufferBytesIs( converted.data ) );
  test.identical( converted.data, buffer );

  test.case = 'string/utf8 <-> string/base64';

  var utf8 = _.encode.utf8FromBuffer( buffer );

  var serialize = _.Gdf.Select({ in : 'string/utf8', out : 'string/base64', ext : 'base64', default : 1 });
  test.identical( serialize.length, 1 );
  let base64FromUtf8 = serialize[ 0 ];

  var serialize = _.Gdf.Select({ out : 'string/utf8', in : 'string/base64', ext : 'utf8', default : 1 });
  test.identical( serialize.length, 1 );
  let base64ToUtf8 = serialize[ 0 ];

  var converted = base64FromUtf8.encode({ data : utf8 });
  test.identical( converted.format, 'string/base64' );
  test.is( _.strIs( converted.data ) );

  var converted = base64ToUtf8.encode({ data : converted.data });
  test.identical( converted.format, 'string/utf8' );
  test.is( _.strIs( converted.data ) );
  test.identical( converted.data, utf8 );

}

//

function utf8( test )
{
  var self = this;

  var src = 'Lorem Ipsum is simply dummy text.';
  var buffer = _.bufferBytesFrom( src );

  test.case = 'buffer.bytes <-> string/utf8';

  var serialize = _.Gdf.Select({ in : 'buffer.bytes', out : 'string/utf8', ext : 'utf8' });
  test.identical( serialize.length, 1 );
  let utf8FromBuffer = serialize[ 0 ];

  var serialize = _.Gdf.Select({ out : 'buffer.bytes', in : 'string/utf8', ext : 'bytes' });
  test.identical( serialize.length, 1 );
  let utf8ToBuffer = serialize[ 0 ];

  var converted = utf8FromBuffer.encode({ data : buffer });
  test.identical( converted.format, 'string/utf8' );
  test.is( _.strIs( converted.data ) );

  var converted = utf8ToBuffer.encode({ data : converted.data });
  test.identical( converted.format, 'buffer.bytes' );
  test.is( _.bufferBytesIs( converted.data ) );
  test.identical( converted.data, buffer );
}

//

function jsonFineSupportedTypes( test )
{
  var self = this;

  /* json.fine */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json.fine' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];
  test.identical( serialize.shortName, 'json.fine' );

  /* json */

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  let result =
  {
    primitive : 0,
    regexp : 0,
    buffer : 0,
    complex : 0
  }

  let options =
  {
    result : result,
    serialize : serialize,
    deserialize : deserialize,
  }

  self.primitive1( test, options );
  self.primitive2( test, options );
  self.primitive3( test, options );
  self.regExp1( test, options );
  self.regExp2( test, options );
  self.buffer1( test, options );
  self.buffer2( test, options );
  self.buffer3( test, options );
  self.complex1( test, options );
  self.complex2( test, options );

  test.identical( result, self.Supported[ 'json.fine' ] );



}

//

function jsonMinSupportedTypes( test )
{
  var self = this;

  /* json.min */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json', default : 1 });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];
  test.identical( serialize.shortName, 'json.min' );

  /* json */

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  let result =
  {
    primitive : 0,
    regexp : 0,
    buffer : 0,
    complex : 0
  }

  let options =
  {
    result : result,
    serialize : serialize,
    deserialize : deserialize,
  }

  self.primitive1( test, options );
  self.primitive2( test, options );
  self.primitive3( test, options );
  self.regExp1( test, options );
  self.regExp2( test, options );
  self.buffer1( test, options );
  self.buffer2( test, options );
  self.buffer3( test, options );
  self.complex1( test, options );
  self.complex2( test, options );

  test.identical( result, self.Supported[ 'json.min' ] );

}

//

function csonSupportedTypes( test )
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

  let result =
  {
    primitive : 0,
    regexp : 0,
    buffer : 0,
    complex : 0
  }

  let options =
  {
    result : result,
    serialize : serialize,
    deserialize : deserialize,
  }

  self.primitive1( test, options );
  self.primitive2( test, options );
  self.primitive3( test, options );
  self.regExp1( test, options );
  self.regExp2( test, options );
  self.buffer1( test, options );
  self.buffer2( test, options );
  self.buffer3( test, options );
  self.complex1( test, options );
  self.complex2( test, options );

  test.identical( result, self.Supported[ 'cson' ] );

}

//

function jsSupportedTypes( test )
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

  let result =
  {
    primitive : 0,
    regexp : 0,
    buffer : 0,
    complex : 0
  }

  let options =
  {
    result : result,
    serialize : serialize,
    deserialize : deserialize,
  }

  self.primitive1( test, options );
  self.primitive2( test, options );
  self.primitive3( test, options );
  self.regExp1( test, options );
  self.regExp2( test, options );
  self.buffer1( test, options );
  self.buffer2( test, options );
  self.buffer3( test, options );
  self.complex1( test, options );
  self.complex2( test, options );

  test.identical( result, self.Supported[ 'js' ] );

}

//

function bsonSupportedTypes( test )
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

  let result =
  {
    primitive : 0,
    regexp : 0,
    buffer : 0,
    complex : 0
  }

  let options =
  {
    result : result,
    serialize : serialize,
    deserialize : deserialize,
  }

  self.primitive1( test, options );
  self.primitive2( test, options );
  self.primitive3( test, options );
  self.regExp1( test, options );
  self.regExp2( test, options );
  self.buffer1( test, options );
  self.buffer2( test, options );
  self.buffer3( test, options );
  self.complex1( test, options );
  self.complex2( test, options );

  test.identical( result, self.Supported[ 'bson' ] );

}

//

function cborSupportedTypes( test )
{
  var self = this;

  /* */

  test.case = 'select';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'buffer.node', ext : 'cbor' });
  test.identical( serialize.length, 1 );
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'buffer.node', out : 'structure', ext : 'cbor' });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  let result =
  {
    primitive : 0,
    regexp : 0,
    buffer : 0,
    complex : 0
  }

  let options =
  {
    result : result,
    serialize : serialize,
    deserialize : deserialize,
  }

  self.primitive1( test, options );
  self.primitive2( test, options );
  self.primitive3( test, options );
  self.regExp1( test, options );
  self.regExp2( test, options );
  self.buffer1( test, options );
  self.buffer2( test, options );
  self.buffer3( test, options );
  self.complex1( test, options );
  self.complex2( test, options );

  test.identical( result, self.Supported[ 'cbor' ] );

}

//

function ymlSupportedTypes( test )
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

  let result =
  {
    primitive : 0,
    regexp : 0,
    buffer : 0,
    complex : 0
  }

  let options =
  {
    result : result,
    serialize : serialize,
    deserialize : deserialize,
  }

  self.primitive1( test, options );
  self.primitive2( test, options );
  self.primitive3( test, options );
  self.regExp1( test, options );
  self.regExp2( test, options );
  self.buffer1( test, options );
  self.buffer2( test, options );
  self.buffer3( test, options );
  self.complex1( test, options );
  self.complex2( test, options );

  test.identical( result, self.Supported[ 'yaml' ] );

}

//

function perfomance( test )
{
  let self = this;

  let commonTypes =
  {
    string : 1,
    number : 1,
    map : 1,
    array : 1,
    boolean : 1,
    null : 1,

    mapComplex : 1,
    arrayComplex : 1
  }

  let src1kb = self.diagnosticsStructureGenerate( _.mapExtend( { depth : 5, breadth : 1 }, commonTypes ));
  let src1mb = self.diagnosticsStructureGenerate( _.mapExtend( { depth : 50, breadth : 100 }, commonTypes ));
  let src10mb = self.diagnosticsStructureGenerate( _.mapExtend( { depth : 100, breadth : 450 }, commonTypes ));

  let readResults = [];
  let writeResults = [];

  /* bson */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'buffer.node', ext : 'bson' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'buffer.node', out : 'structure', ext : 'bson' });
  deserialize = deserialize[ 0 ];

  run( [ src1kb, src1mb, src10mb ] , [ '1kb', '1Mb', '10Mb' ] );

  /* yaml */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'yml' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'yml' });
  deserialize = deserialize[ 0 ];

  run( [ src1kb, src1mb, src10mb ] , [ '1kb', '1Mb', '10Mb' ] );

  /* cson */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'cson' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'cson' });
  deserialize = deserialize[ 0 ];

  run( [ src1kb, src1mb ] , [ '1kb', '1Mb' ] );

  /* cbor */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'buffer.node', ext : 'cbor' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'buffer.node', out : 'structure', ext : 'cbor' });
  deserialize = deserialize[ 0 ];

  run( [ src1kb, src1mb ] , [ '1kb', '1Mb' ] );

  /* js */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'js' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'js' });
  deserialize = deserialize[ 0 ];

  run( [ src1kb, src1mb, src10mb ] , [ '1kb', '1Mb', '10Mb' ] );

  /* json.fine */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json.fine' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  deserialize = deserialize[ 0 ];

  run( [ src1kb, src1mb, src10mb ] , [ '1kb', '1Mb', '10Mb' ] );

  /* json.min */

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json', default : 1 });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  deserialize = deserialize[ 0 ];

  run( [ src1kb, src1mb, src10mb ] , [ '1kb', '1Mb', '10Mb' ] );

  /* write results */

  var o =
  {
    data : writeResults,
    head : [ 'Write Transformer', '1kb - Time', '1kb - Out size', '1mb - Time', '1mb - Out size', '10mb - Time', '10mb - Out size' ],
    colWidths :
    {
      0 : 30,
    },
    colWidth : 15
  }
  var output = _.strTable( o );
  console.log( output );

  /* read results */

  var o =
  {
    data : readResults,
    head : [ 'Read Transformer', '1kb - Time', '1Mb - Time', '10Mb - Time' ],
    colWidths :
    {
      0 : 30,
    },
    colWidth : 15
  }
  var output = _.strTable( o );
  console.log( output );

  test.identical( 1,1 )

  /*  */

  function run( srcs, srcSizes )
  {
    let serialized;
    let deserialized;
    let src;
    let srcSize;

    console.log( '\n',  serialize.ext, ':', '\n' );

    let write = [ serialize.ext ];
    let read = [ serialize.ext ];

    readResults.push( read );
    writeResults.push( write );

    for( var i = 0; i < srcs.length; i++ )
    {
      src = srcs[ i ];
      srcSize = srcSizes[ i ];

      console.log( '\nSrc: ', srcSize );

      try
      {
        var t0 = _.timeNow();
        serialized = serialize.encode({ data : src });
        var spent = _.timeSpent( t0 );
        console.log( 'write: ', spent );

        let buffer = _.bufferBytesFrom( serialized.data );
        let size = _.strMetricFormatBytes( buffer.byteLength );

        console.log( serialize.ext, 'serialized size:', size );

        write.push( spent, size );
      }
      catch( err )
      {
        console.log( err )
        write.push( 'Err', 'Err' );
      }

      try
      {
        var t0 = _.timeNow();
        deserialized = deserialize.encode({ data : serialized.data });
        var spent = _.timeSpent( t0 );
        console.log( 'read: ', spent );

        read.push( spent );
      }
      catch( err )
      {
        console.log( err )
        read.push( 'Err' );
      }

    }
  }
}

perfomance.experimental = 1;

//

function select( test )
{
  let self = this;

  test.case = 'all'
  var got = _.Gdf.Select({});
  test.is( got.length === _.Gdf.Elements.length );

  test.case = 'in'
  var got = _.Gdf.Select({ in : 'structure' });
  test.is( got.length );

  test.case = 'out'
  var got = _.Gdf.Select({ out : 'string' });
  test.is( got.length );

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

  test.case = 'not supported value'

  test.shouldThrowErrorSync( () => _.Gdf.Select() );
  test.shouldThrowErrorSync( () => _.Gdf.Select({ ext : [ 'json.fine', 'json' ] }) );

}

//

function register( test )
{
  let self = this;

  var converter =
  {
    ext : [ 'ext' ],
    in : [ 'string' ],
    out : [ 'number' ],

    onEncode : function( op )
    {
      _.assert( _.strIs( op.in.data ) );
      op.out.data = Number.parseFloat( op.in.data );
      op.out.format = 'number';
    }
  }

  converter = _.Gdf( converter );

  test.is( _.arrayHas( _.Gdf.Elements, converter ) );
  test.is( _.arrayHas( _.Gdf.InMap[ 'string' ], converter ) );
  test.is( _.arrayHas( _.Gdf.OutMap[ 'number' ], converter ) );
  test.is( _.arrayHas( _.Gdf.ExtMap[ 'ext' ], converter ) );
  test.is( _.arrayHas( _.Gdf.InOutMap[ 'string-number' ], converter ) );

  converter.finit();

  test.is( !_.arrayHas( _.Gdf.Elements, converter ) );
  test.is( !_.arrayHas( _.Gdf.InMap[ 'string' ], converter ) );
  test.is( !_.arrayHas( _.Gdf.OutMap[ 'number' ], converter ) );
  test.is( !_.arrayHas( _.Gdf.ExtMap[ 'ext' ], converter ) );
  test.is( !_.arrayHas( _.Gdf.InOutMap[ 'string-number' ], converter ) );
}

//

function finit( test )
{
  let self = this;

  var converter = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'yml' });
  test.identical( converter.length, 1 );
  converter = converter[ 0 ].converter;
  test.identical( converter.inOut, [ 'structure-string' ] )

  test.is( _.arrayHas( _.Gdf.Elements, converter ) );
  test.is( _.arrayHas( _.Gdf.InMap[ 'structure' ], converter ) );
  test.is( _.arrayHas( _.Gdf.OutMap[ 'string' ], converter ) );
  test.is( _.arrayHas( _.Gdf.ExtMap[ 'yml' ], converter ) );
  test.is( _.arrayHas( _.Gdf.InOutMap[ 'structure-string' ], converter ) );

  converter.finit();

  test.is( !_.arrayHas( _.Gdf.Elements, converter ) );
  test.is( !_.arrayHas( _.Gdf.InMap[ 'structure' ], converter ) );
  test.is( !_.arrayHas( _.Gdf.OutMap[ 'string' ], converter ) );
  test.is( !_.arrayHas( _.Gdf.ExtMap[ 'yml' ], converter ) );
  test.is( !_.arrayHas( _.Gdf.InOutMap[ 'structure-string' ], converter ) );
}

// --
// declare
// --

var Self =
{

  name : 'Tools/base/EncoderStrategy',
  silencing : 1,

  context :
  {
    primitive1,
    primitive2,
    primitive3,
    regExp1,
    regExp2,
    buffer1,
    buffer2,
    buffer3,
    complex1,
    complex2,

    Supported,

    diagnosticsStructureGenerate
  },

  tests :
  {
    trivial,
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

    jsonFineSupportedTypes,
    jsonMinSupportedTypes,
    csonSupportedTypes,
    jsSupportedTypes,
    bsonSupportedTypes,
    cborSupportedTypes,
    ymlSupportedTypes,

    //

    perfomance,

    //

    select,
    register,
    finit
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
