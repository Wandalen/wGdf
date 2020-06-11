( function _Base64_test_s_()
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

function base64( test )
{
  var self = this;

  var src = 'Lorem Ipsum is simply dummy text.';
  var buffer = _.bufferBytesFrom( src );

  test.case = 'buffer.bytes <-> string/base64';

  var serialize = _.Gdf.Select({ in : 'buffer.bytes', out : 'string/base64' });
  test.identical( serialize.length, 1 );
  let base64FromBuffer = serialize[ 0 ];

  var serialize = _.Gdf.Select({ out : 'buffer.bytes', in : 'string/base64' });
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

  var serialize = _.Gdf.Select({ in : 'string/utf8', out : 'string/base64', default : 1 });
  test.identical( serialize.length, 1 );
  let base64FromUtf8 = serialize[ 0 ];

  var serialize = _.Gdf.Select({ out : 'string/utf8', in : 'string/base64', default : 1 });
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

// --
// declare
// --

var Self =
{

  name : 'Tools.base64.gdf',
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
