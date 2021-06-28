( function _GdfPerfomance_test_s_( )
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../gdf/entry/Gdf.s' );
  _.include( 'wTesting' );
  _.include( 'wFiles' );

}

const _global = _global_;
const _ = _global_.wTools;

// --
// context
// --

// function onSuiteBegin()
// {
//   let context = this;
//   context.suiteTempPath = path.tempOpen( path.join( __dirname, '../..'  ), 'ConsequenceExternal' );
//   context.assetsOriginalPath = path.join( __dirname, '_asset' );
// }
//
// //
//
// function onSuiteEnd()
// {
//   let context = this;
//   _.assert( _.strHas( context.suiteTempPath, '/ConsequenceExternal-' ) )
//   path.tempClose( context.suiteTempPath );
// }

function onSuiteBegin()
{
  let context = this;
  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'wGdf' );
  context.results = Object.create( null );
}

//

function onSuiteEnd()
{
  let context = this;
  let results = context.results;

  _.path.tempClose( context.suiteTempPath );
  // _.fileProvider.filesDelete( context.suiteTempPath );

  let data = {};

  for( var converter in results )
  {
    let resultsOfConverter = results[ converter ];
    for( var size in resultsOfConverter )
    {
      if( !data[ size ] )
      data[ size ] = [];
      data[ size ].push( resultsOfConverter[ size ] )
    }
  }

  for( let i in data )
  {
    // console.log( data[ i ] );
    var o =
    {
      data : data[ i ],
      // leftHead : [ 'Converter', 'Out size', 'Write time', 'Read time' ],
      dim : onTableDim( data[ i ] ),
      onCellGet,
      colWidth : 15,
      colSplits : 1,
      rowSplits : 1,
      style : 'doubleBorder',
    }
    var output = _.strTable( o );
    console.log( i, '\n' );
    console.log( output.result );
  }

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

  // for( let i in data )
  // {
  //   var o =
  //   {
  //     data : data[ i ],
  //     head : [ 'Converter', 'Out size', 'Write time', 'Read time' ],
  //     colWidth : 15
  //   }
  //   var output = _.strTable_old( o );
  //   console.log( i, '\n' );
  //   console.log( output );
  // }

}

//

function testApp()
{
  // const _ = require( 'Tools' );
  const _ = require( toolsPath );
  _.include( 'wGdf' );
  // require( '../../../abase/l8/Converter.s' );


  let commonTypes =
  {
    stringComplexity : 1,
    numberComplexity : 1,
    mapComplexity : 1,
    arrayComplexity : 1,
    booleanComplexity : 1,
    nullComplexity : 1,
    // mapComplex : 1,
    // arrayComplex : 1
  }

  // var o1 = _.props.extend( { depth : 1, breadth : 1 }, commonTypes );
  // var o2 = _.props.extend( { depth : 20, breadth : 90 }, commonTypes );
  // var o3 = _.props.extend( { depth : 150, breadth : 1100 }, commonTypes );

  var o1 = _.props.extend( { depth : 1 }, commonTypes );
  var o2 = _.props.extend( { depth : 1 }, commonTypes );
  var o3 = _.props.extend( { depth : 1 }, commonTypes );

  // var o1 = _.props.extend( { depth : 1 }, commonTypes );
  // var o2 = _.props.extend( { depth : 20 }, commonTypes );
  // var o3 = _.props.extend( { depth : 150 }, commonTypes );

  _.diagnosticStructureGenerate( o1 );
  _.diagnosticStructureGenerate( o2 );
  _.diagnosticStructureGenerate( o3 );

  let srcs =
  {
    '1Kb' : o1.result,
    '1Mb' : o2.result,
    '100Mb' : o3.result
  };

  let results = {};

  process.on( 'message', ( o ) =>
  {
    run( o );
  })

  /*  */

  function run( o )
  {
    var serialize = _.gdf.selectContext( o.serialize );
    serialize = serialize[ 0 ];

    var deserialize = _.gdf.selectContext( o.deserialize );
    deserialize = deserialize[ 0 ];

    _.assert( serialize );
    _.assert( deserialize );

    console.log( '\n', '-> ', serialize.ext, ' <-', '\n' );

    for( var i in srcs )
    {
      let serialized,
        deserialized;

      let src = srcs[ i ];
      let srcSize = i;
      let result = results[ i ] = [ serialize.ext, '-', '-', '-' ];

      console.log( '\nSrc: ', srcSize );

      try
      {
        let t0 = _.time.now();
        serialized = serialize.encode({ data : src }).out;
        let spent = _.time.spent( t0 );
        let size =  _.strMetricFormatBytes( _.entity.sizeOf( serialized.data ) );

        console.log( 'write: ', spent );
        console.log( serialize.ext, 'out size:', size );

        result[ 1 ] = size;
        result[ 2 ] = spent;

        process.send({ converter : serialize.ext, results });

      }
      catch( err )
      {
        _.errLogOnce( err );

        result[ 1 ] = 'Err';
        result[ 2 ] = 'Err';
        result[ 3 ] = 'Err';

        process.send({ converter : serialize.ext, results });

        continue;
      }

      try
      {
        let t0 = _.time.now();
        deserialized = deserialize.encode({ data : serialized.data }).out;
        let spent = _.time.spent( t0 );
        console.log( 'read: ', spent );

        result[ 3 ] = spent;

        process.send({ converter : serialize.ext, results });

      }
      catch( err )
      {
        _.errLogOnce( err );
        result[ 3 ] = 'Err';

        process.send({ converter : serialize.ext, results });
      }

    }

    process.exit();
  }
}

//

let converters =
{
  'bson' :
  {
    serialize : { inFormat : 'structure', outFormat : 'buffer.node', ext : 'bson' },
    deserialize : { inFormat : 'buffer.node', outFormat : 'structure', ext : 'bson' }
  },

  'json.fine' :
  {
    serialize : { inFormat : 'structure', outFormat : 'string', ext : 'json.fine' },
    deserialize : { inFormat : 'string', outFormat : 'structure', ext : 'json', default : 1 }
  },

  'json.min' :
  {
    serialize : { inFormat : 'structure', outFormat : 'string', ext : 'json', default : 1 },
    deserialize : { inFormat : 'string', outFormat : 'structure', ext : 'json', default : 1 }
  },

  'cson' :
  {
    serialize : { inFormat : 'structure', outFormat : 'string', ext : 'cson' },
    deserialize : { inFormat : 'string', outFormat : 'structure', ext : 'cson' }
  },

  'js' :
  {
    serialize : { inFormat : 'structure', outFormat : 'string', ext : 'js' },
    deserialize : { inFormat : 'string', outFormat : 'structure', ext : 'js' }
  },

  'cbor' :
  {
    serialize : { inFormat : 'structure', outFormat : 'buffer.node', ext : 'cbor' },
    deserialize : { inFormat : 'buffer.node', outFormat : 'structure', ext : 'cbor' }
  },

  'yml' :
  {
    serialize : { inFormat : 'structure', outFormat : 'string', ext : 'yml' },
    deserialize : { inFormat : 'string', outFormat : 'structure', ext : 'yml' }
  },

  'msgpack.lite' :
  {
    serialize : { inFormat : 'structure', outFormat : 'buffer.node', ext : 'msgpack.lite' },
    deserialize : { inFormat : 'buffer.node', outFormat : 'structure', ext : 'msgpack.lite' }
  },

  'msgpack.wtp' :
  {
    serialize : { inFormat : 'structure', outFormat : 'buffer.node', ext : 'msgpack.wtp' },
    deserialize : { inFormat : 'buffer.node', outFormat : 'structure', ext : 'msgpack.wtp' }
  }
}

//

function perfomance( test )
{
  let context = this;
  let a = test.assetFor( false );
  // let toolsPath = a.path.nativize( _.module.toolsPathGet() );
  // let locals = { toolsPath,  };

  var filePath/*programPath*/ = a.program( testApp ).filePath/*programPath*/;

  // a.appStartNonThrowing({ execPath : filePath/*programPath*/ })

  // var routinePath = _.path.join( context.suiteTempPath, test.name );
  // var testAppPath = _.fileProvider.path.nativize( _.path.join( routinePath, 'testApp.js' ) );
  // var testAppCode = testApp.toString() + '\ntestApp();';
  // let program = _.program.make( testApp );
  // _.fileProvider.fileWrite( testAppPath, testAppCode );

  // let o2 = _.program.make
  // ({
  //   routine : o.routine,
  //   locals : o.locals,
  //   tempPath : a.abs( '.' ),
  // });

  let ready = new _.Consequence().take( null );

  for( var c in context.converters )
  ready.finally( _.routineSeal( context, execute, [ context.converters[ c ] ] ) );

  return ready;

  /*  */

  function execute( converter )
  {
    let o =
    {
      // execPath : _.path.nativize( testAppPath ),
      execPath : filePath/*programPath*/,
      maximumMemory : 1,
      mode : 'spawn',
      ipc : 1,
      timeOut : 5 * 600000,
      stdio : 'pipe',
      outputPiping : 1,
    }

    let con = _.process.startNjs( o );

    o.pnd.send( converter );

    o.pnd.on( 'message', ( data ) =>
    {
      context.results[ data.converter ] = data.results;
    })

    con.finally( ( err, got ) =>
    {
      test.true( !err )
      return null;
    })

    return con;
  }
}

perfomance.experimental = 1;
perfomance.timeOut = _.props.onlyOwnKeys( converters ).length * 6 * 60000;
perfomance.rapidity = -4;

// --
// declare
// --

const Proto =
{

  name : 'Tools/base/gdf/Performance',
  silencing : 1,
  enabled : 0,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {

    results : null,
    converters,

    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,

  },

  tests :
  {
    perfomance,
  },

};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
