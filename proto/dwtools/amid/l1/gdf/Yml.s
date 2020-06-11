( function _Yml_s_()
{

'use strict';

/**
 * @file EncoderStrategyStandanrd.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../../dwtools/Tools.s' );

}

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
  in : [ 'string' ],
  out : [ 'structure' ],

  supporting : ymlSupported,

  onEncode : function( op )
  {
    let o = Object.create( null );

    if( !Yaml )
    Yaml = require( YamlPath );

    if( op.envMap.filePath )
    o.filename = _.fileProvider.path.nativize( op.envMap.filePath )

    op.out.data = Yaml.load( op.in.data, o );
    op.out.format = 'structure';
  },

}

let writeYml = null;
if( YamlPath )
writeYml =
{

  ext : [ 'yaml', 'yml' ],
  in : [ 'structure' ],
  out : [ 'string' ],

  supporting : ymlSupported,

  onEncode : function( op )
  {

    if( !Yaml )
    Yaml = require( YamlPath );

    op.out.data = Yaml.dump( op.in.data );
    op.out.format = 'string';
  },

}

// --
// declare
// --

var Extend =
{

}

Self = _.encode = _.encode || Object.create( null );
_.mapExtend( _.encode, Extend );

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
