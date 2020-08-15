( function _Yml_s_()
{

'use strict';

// /**
//  * //  */
//
// if( typeof module !== 'undefined' )
// {
//
//   let _ = require( '../../../../wtools/Tools.s' );
//
// }

let _global = _global_;
let _ = _global_.wTools;
let Self = _global_.wTools;

// --
// yaml
// --

let Yaml, YamlPath;
try
{
  YamlPath = require.resolve( 'js-yaml' );
}
catch( err )
{
}

let ymlSupported =
{
  primitive : 2,
  regexp : 2,
  buffer : 1,
  structure : 3
}

let readYml = null;
if( YamlPath )
readYml =
{

  ext : [ 'yaml', 'yml' ],
  inFormat : [ 'string.utf8' ],
  outFormat : [ 'structure' ],

  feature : ymlSupported,

  onEncode : function( op )
  {
    let o = Object.create( null );

    if( !Yaml )
    Yaml = require( YamlPath );

    if( op.filePath )
    o.filename = _.fileProvider.path.nativize( op.filePath )

    op.out.data = Yaml.load( op.in.data, o );
    op.out.format = 'structure';
  },

}

let writeYml = null;
if( YamlPath )
writeYml =
{

  ext : [ 'yaml', 'yml' ],
  inFormat : [ 'structure' ],
  outFormat : [ 'string.utf8' ],

  feature : ymlSupported,

  onEncode : function( op )
  {

    if( !Yaml )
    Yaml = require( YamlPath );

    op.out.data = Yaml.dump( op.in.data );
    op.out.format = 'string.utf8';
  },

}

// --
// declare
// --

var Extension =
{

}

Self = _.encode = _.encode || Object.create( null );
_.mapExtend( _.encode, Extension );

// --
// register
// --

_.Gdf([ readYml, writeYml ]);

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
