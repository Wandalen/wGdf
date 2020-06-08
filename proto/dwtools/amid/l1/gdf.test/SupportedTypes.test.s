( function _SupportedTypes_test_s_()
{
'use strict';

if( typeof module !== 'undefined' )
{
  var _ = require( '../../../../dwtools/Tools.s' );
}

var _global = _global_;
var _ = _global_.wTools;

_.assert( _testerGlobal_.wTools !== _global_.wTools );

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
    head : [ 'Transformer','Primitive(0-3)','RegExp(0-2)','BufferNode(0-3)','Structure(0-3)' ],
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
  },

  tests :
  {
    supportedTypes
  },

};

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
