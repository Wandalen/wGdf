( function _Gdf_Perfomance_test_s_( ) {

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
// context
// --


function onSuiteBegin()
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

  var o1 = _.mapExtend( { depth : 1, breadth : 1 }, commonTypes );
  self.diagnosticsStructureGenerate( o1 );

  var o2 = _.mapExtend( { depth : 20, breadth : 90 }, commonTypes );
  self.diagnosticsStructureGenerate( o2 );

  var o3 = _.mapExtend( { depth : 150, breadth : 1100 }, commonTypes );
  self.diagnosticsStructureGenerate( o3 );

  let src1kb = o1.structure;
  let src1mb = o2.structure;
  let src100mb = o3.structure;

  self.srcs = { '1kb' : src1kb, '1Mb' : src1mb, '100Mb' : src100mb };
  self.results = { '1kb' : [], '1Mb' : [], '100Mb' : [] };
}

//

function onSuiteEnd()
{
  let self = this;
  let results = self.results;

  for( var i in results )
  {
    var o =
    {
      data : results[ i ],
      head : [ 'Converter', 'Out size', 'Write time', 'Read time' ],
      colWidth : 15
    }
    var output = _.strTable( o );

    console.log( i, '\n' );
    console.log( output );
  }

}

//

function run( serialize, deserialize, test )
{
  let self = this;

  let results = self.results;
  let srcs = self.srcs;

  console.log( '\n',  serialize.ext, ':', '\n' );

  for( var i in srcs )
  {
    let serialized;
    let deserialized;

    let src = srcs[ i ];
    let srcSize = i;
    let result = [ serialize.ext, '-', '-', '-' ];

    results[ i ].push( result );

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

      result[ 1 ] = size;
      result[ 2 ] = spent;

      test.identical( 1,1 );
    }
    catch( err )
    {
      _.errLogOnce( err );

      test.will = 'should not throw error';
      test.identical( 0, 1 );

      result[ 1 ] = 'Err';
      result[ 2 ] = 'Err';
      result[ 3 ] = 'Err';

      continue;
    }

    try
    {
      var t0 = _.timeNow();
      deserialized = deserialize.encode({ data : serialized.data });
      var spent = _.timeSpent( t0 );
      console.log( 'read: ', spent );

      result[ 3 ] = spent;

      test.identical( 1,1 );

    }
    catch( err )
    {
      _.errLogOnce( err );

      test.will = 'should not throw error';
      test.identical( 0, 1 );

      result[ 3 ] = 'Err';
    }


  }
}

//

function entitySize( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.strIs( src ) )
  {
    if( src.length )
    return _.bufferBytesFrom( src ).byteLength;
    return src.length;
  }

  if( _.numberIs( src ) )
  return 8;

  if( !_.definedIs( src ) )
  return 8;

  if( _.boolIs( src ) || _.dateIs( src ) )
  return 8;

  if( _.numberIs( src.byteLength ) )
  return src.byteLength;

  if( _.regexpIs( src ) )
  return entitySize( src.source ) + src.flags.length * 2;

  if( _.longIs( src ) )
  {
    let result = 0;
    for( let i = 0; i < src.length; i++ )
    {
      result += entitySize( src[ i ] );
      if( isNaN( result ) )
      break;
    }
    return result;
  }

  if( _.mapIs( src ) )
  {
    let result = 0;
    for( let k in src )
    {
      result += entitySize( k );
      result += entitySize( src[ k ] );
      if( isNaN( result ) )
      break;
    }
    return result;
  }

  return NaN;
}

//

function diagnosticsStructureGenerate( o )
{
  _.assert( arguments.length === 1 )
  _.routineOptions( diagnosticsStructureGenerate, o );
  _.assert( _.numberIs( o.breadth ) );
  _.assert( _.numberIs( o.depth ) );

  /*  */

  o.structure = Object.create( null );

  for( let b = 0; b < o.breadth; b++ )
  {
    o.structure[ b ] = singleLevelMake();
  }

  o.size = entitySize( o.structure );

  console.log( 'entitySize:', _.strMetricFormatBytes( o.size ) );

  return o;

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
    singleLevel[ 'string' ] = _.strDup( 'a', o.stringSize || o.fieldSize );

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

    let bufferSrc = _.arrayFillTimes( [], o.bufferSize || o.fieldSize, 0 );

    if( o.bufferNode )
    if( typeof Buffer !== 'undefined' )
    singleLevel[ 'bufferNode'] = Buffer.from( bufferSrc );

    if( o.bufferRaw )
    singleLevel[ 'bufferRaw'] = new ArrayBuffer( bufferSrc );

    if( o.bufferBytes )
    singleLevel[ 'bufferBytes'] = new Uint8Array( bufferSrc );

    if( o.map )
    singleLevel[ 'map' ] = { a : 'string', b : 1, c : true  };

    if( o.mapComplex )
    singleLevel[ 'mapComplex' ] = { a : '1', dir : { b : 2 }, c : [ 1,2,3 ] };

    if( o.array )
    singleLevel[ 'array' ] = _.arrayFillTimes( [], o.arraySize || o.fieldSize, 0 )

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

  regexp : null,
  regexpComplex : null,

  bufferNode : null,
  bufferRaw : null,
  bufferBytes : null,

  array : null,
  arrayComplex : null,
  map : null,
  mapComplex : null,

  /* */

  stringSize : null,
  bufferSize : null,
  regexpSize : null,
  arraySize : null,
  mapSize : null,

  fieldSize : 50

}

//

function jsonFine( test )
{
  let self = this;

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json.fine' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  deserialize = deserialize[ 0 ];

  self.run( serialize, deserialize, test );
}

jsonFine.timeOut = 5 * 60000;

//

function jsonMin( test )
{
  let self = this;

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'json', default : 1 });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json', default : 1 });
  deserialize = deserialize[ 0 ];

  self.run( serialize, deserialize, test );
}

jsonMin.timeOut = 5 * 60000;

//

function cson( test )
{
  let self = this;

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'cson' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'cson' });
  deserialize = deserialize[ 0 ];

  self.run( serialize, deserialize, test );
}

cson.timeOut = 5 * 60000;

//

function js( test )
{
  let self = this;

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'js' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'js' });
  deserialize = deserialize[ 0 ];

  self.run( serialize, deserialize, test );
}

js.timeOut = 5 * 60000;

//

function bson( test )
{
  let self = this;

  var serialize = _.Gdf.Select({ in : 'structure', out : 'buffer.node', ext : 'bson' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'buffer.node', out : 'structure', ext : 'bson' });
  deserialize = deserialize[ 0 ];

  self.run( serialize, deserialize, test );
}

bson.timeOut = 5 * 60000;

//

function cbor( test )
{
  let self = this;

  var serialize = _.Gdf.Select({ in : 'structure', out : 'buffer.node', ext : 'cbor' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'buffer.node', out : 'structure', ext : 'cbor' });
  deserialize = deserialize[ 0 ];

  self.run( serialize, deserialize, test );
}

cbor.timeOut = 5 * 60000;

//

function yml( test )
{
  let self = this;

  var serialize = _.Gdf.Select({ in : 'structure', out : 'string', ext : 'yml' });
  serialize = serialize[ 0 ];

  var deserialize = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'yml' });
  deserialize = deserialize[ 0 ];

  self.run( serialize, deserialize, test );
}

yml.timeOut = 5 * 60000;


// --
// declare
// --

var Self =
{

  name : 'Tools/base/EncoderStrategyPerfomance',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    diagnosticsStructureGenerate,
    entitySize,

    run,

    srcs : null,
    results : null,
  },

  tests :
  {
    jsonFine,
    jsonMin,
    cson,
    js,
    bson,
    cbor,
    yml

  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
