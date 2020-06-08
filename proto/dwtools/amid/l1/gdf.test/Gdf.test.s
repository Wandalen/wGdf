( function _Gdf_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{
  // require( 'wTesting' );
  var _ = require( '../../../../dwtools/Tools.s' );
  require( '../gdf/Converter.s' );
  _.include( 'wTesting' );

  // var bson = require( './Bson.test.s' ).tests.bson;
  // var cbor = require( './Cbor.test.s' ).tests.cbor;
  // var yml = require( './Yml.test.s' ).tests.yml;
  // var json = require( './Json.test.s' ).tests.json;
  // var js = require( './Js.test.s' ).tests.js;
  // var cson = require( './Cson.test.s' ).tests.cson;
  // var jsonMin = require( './JsonMin.test.s' ).tests.jsonMin;
  // var jsonFine = require( './JsonFine.test.s' ).tests.jsonFine;
  // var utf8 = require( './Utf8.test.s' ).tests.utf8;
  // var base64 = require( './Base64.test.s' ).tests.base64;
  // var supportedTypes = require( './SupportedTypes.test.s' ).tests.supportedTypes;
  // var registerAndFinit = require( './RegisterAndFinit.test.s' ).tests.registerAndFinit;
  // var select = require( './Select.test.s' ).tests.select;
  // var trivial = require( './Trivial.test.s' ).tests.trivial;
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

// --
// test
// --



// --
// declare
// --

var Self =
{

  name : 'Tools.base.gdf',
  silencing : 1,

  context :
  {
    // converterTypesCheck,

    // primitive1,
    // primitive2,
    // primitive3,
    // regExp1,
    // regExp2,
    // buffer1,
    // buffer2,
    // buffer3,
    // structure1,
    // structure2,
    // structure3,
  },

  tests :
  {

    // trivial,
    // select,
    // registerAndFinit,

    // //

    // jsonFine,
    // jsonMin,
    // json,
    // cson,
    // js,
    // bson,
    // cbor,
    // yml,

    // base64,
    // utf8,

    // //

    // supportedTypes,

  },

};

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
