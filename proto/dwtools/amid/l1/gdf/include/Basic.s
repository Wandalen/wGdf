( function _Basic_s_( )
{

'use strict';

/* gdf */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../dwtools/Tools.s' );
  _.include( 'wCopyable' );
  // _.include( 'wRoutineBasic' );
  // _.include( 'wStringsExtra' );
  // _.include( 'wStringer' );
  module[ 'exports' ] = _global_.wTools;
}

} )();
