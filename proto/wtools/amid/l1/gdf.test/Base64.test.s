( function _Base64_test_s_()
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

_.assert( _globals_.testing.wTools !== _global_.wTools );

// --
// test
// --

function base64( test )
{
  let context = this;

  var src = 'Lorem Ipsum is simply dummy text.';
  var buffer = _.bufferBytesFrom( src );

  test.case = 'buffer.bytes <-> string.base64';

  var serialize = _.gdf.selectContext({ inFormat : 'buffer.bytes', outFormat : 'string.base64' });
  test.identical( serialize.length, 1 );
  let base64FromBuffer = serialize[ 0 ];

  var serialize = _.gdf.selectContext({ outFormat : 'buffer.bytes', inFormat : 'string.base64' });
  test.identical( serialize.length, 1 );
  let base64ToBuffer = serialize[ 0 ];

  var converted = base64FromBuffer.encode({ data : buffer });
  test.identical( converted.out.format, 'string.base64' );
  test.true( _.strIs( converted.out.data ) );

  var converted = base64ToBuffer.encode({ data : converted.out.data });
  test.identical( converted.out.format, 'buffer.bytes' );
  test.true( _.bufferBytesIs( converted.out.data ) );
  test.identical( converted.out.data, buffer );

  test.case = 'string.utf8 <-> string.base64';

  var utf8 = _.encode.utf8FromBuffer( buffer );

  var serialize = _.gdf.selectContext({ inFormat : 'string.utf8', outFormat : 'string.base64' });
  test.identical( serialize.length, 1 );
  let base64FromUtf8 = serialize[ 0 ];

  var serialize = _.gdf.selectContext({ outFormat : 'string.utf8', inFormat : 'string.base64' });
  test.identical( serialize.length, 1 );
  let base64ToUtf8 = serialize[ 0 ];

  var converted = base64FromUtf8.encode({ data : utf8 });
  test.identical( converted.out.format, 'string.base64' );
  test.true( _.strIs( converted.out.data ) );

  var converted = base64ToUtf8.encode({ data : converted.out.data });
  test.identical( converted.out.format, 'string.utf8' );
  test.true( _.strIs( converted.out.data ) );
  test.identical( converted.out.data, utf8 );

}

// --
// declare
// --

let Self =
{

  name : 'Tools64.gdf',
  silencing : 1,

  context :
  {
  },

  tests :
  {
    base64
  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

} )();
