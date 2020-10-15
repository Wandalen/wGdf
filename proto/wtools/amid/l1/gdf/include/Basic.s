( function _Basic_s_( )
{

'use strict';

/* gdf */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../wtools/Tools.s' );
  _.include( 'wCopyable' );
  // _.include( 'wIntrospectorBasic' );
  // _.include( 'wStringsExtra' );
  // _.include( 'wStringer' );
  module[ 'exports' ] = _global_.wTools;
}

} )();
