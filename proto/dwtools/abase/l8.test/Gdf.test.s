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

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  test.identical( deserialize.length, 1 );
  deserialize = deserialize[ 0 ];

  /* json.fine */

  test.case = 'select json.fine';

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json', default : 1 });
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
  test.identical( got[ 0 ].shortName, 'json.fine' );

  test.case = 'shortName';

  var got = _.Gdf.Select({ shortName : 'json.fine', out : 'string' });
  test.is( got.length === 1 );
  test.identical( got[ 0 ].shortName, 'json.fine' );

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

  var encoder = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'yml' });
  test.identical( encoder.length, 1 );
  encoder = encoder[ 0 ].encoder;
  test.identical( encoder.inOut, [ 'structure-string' ] )

  test.is( _.arrayHas( _.Gdf.Elements, encoder ) );
  test.is( _.arrayHas( _.Gdf.InMap[ 'structure' ], encoder ) );
  test.is( _.arrayHas( _.Gdf.OutMap[ 'string' ], encoder ) );
  test.is( _.arrayHas( _.Gdf.ExtMap[ 'yml' ], encoder ) );
  test.is( _.arrayHas( _.Gdf.InOutMap[ 'structure-string' ], encoder ) );

  encoder.finit();

  test.is( !_.arrayHas( _.Gdf.Elements, encoder ) );
  test.is( !_.arrayHas( _.Gdf.InMap[ 'structure' ], encoder ) );
  test.is( !_.arrayHas( _.Gdf.OutMap[ 'string' ], encoder ) );
  test.is( !_.arrayHas( _.Gdf.ExtMap[ 'yml' ], encoder ) );
  test.is( !_.arrayHas( _.Gdf.InOutMap[ 'structure-string' ], encoder ) );
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
    yml,

    base64,
    utf8,

    select,
    register,
    finit
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
