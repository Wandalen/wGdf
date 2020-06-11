( function _MsgpackLiteWtp_s_()
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
// Msgpack-lite
// --

let MsgpackLite, MsgpackLitePath;
try
{
  MsgpackLitePath = require.resolve( 'msgpack-lite' );
}
catch( err )
{
}

let readMsgpackLite = null;
if( MsgpackLitePath )
readMsgpackLite =
{

  ext : [ 'msgpack.lite' ],
  in : [ 'buffer.node' ],
  out : [ 'structure' ],

  onEncode : function( op )
  {

    if( !MsgpackLite )
    MsgpackLite = require( MsgpackLitePath );

    _.assert( _.bufferNodeIs( op.in.data ) );
    op.out.data = MsgpackLite.decode( op.in.data );
    op.out.format = 'structure';
  },

}

let writeMsgpackLite = null;
if( MsgpackLitePath )
writeMsgpackLite =
{

  ext : [ 'msgpack.lite' ],
  in : [ 'structure' ],
  out : [ 'buffer.node' ],

  onEncode : function( op )
  {

    if( !MsgpackLite )
    MsgpackLite = require( MsgpackLitePath );

    _.assert( _.mapIs( op.in.data ) );
    op.out.data = MsgpackLite.encode( op.in.data );
    op.out.format = 'buffer.node';
  },

}

// --
// Msgpack-wtp
// --

let MsgpackWtp, MsgpackWtpPath;
try
{
  MsgpackWtpPath = require.resolve( 'what-the-pack' );
}
catch( err )
{
}

let readMsgpackWtp = null;
if( MsgpackWtpPath )
readMsgpackWtp =
{

  ext : [ 'msgpack.wtp' ],
  in : [ 'buffer.node' ],
  out : [ 'structure' ],

  onEncode : function( op )
  {
    _.assert( _.bufferNodeIs( op.in.data ) );

    if( !MsgpackWtp )
    {
      MsgpackWtp = require( MsgpackLitePath );
      // if( !MsgpackWtp.decode )
      MsgpackWtp = MsgpackWtp.initialize( 2**27 ); //134 MB
    }

    op.out.data = MsgpackWtp.decode( op.in.data );
    op.out.format = 'structure';
  },

}

let writeMsgpackWtp = null;
if( MsgpackWtpPath )
writeMsgpackWtp =
{

  ext : [ 'msgpack.wtp' ],
  in : [ 'structure' ],
  out : [ 'buffer.node' ],

  onEncode : function( op )
  {
    _.assert( _.mapIs( op.in.data ) );

    if( !MsgpackWtp )
    {
      MsgpackWtp = require( MsgpackLitePath );
      MsgpackWtp = MsgpackWtp.initialize( 2**27 ); //134 MB
    }

    // if( !MsgpackWtp.encode )
    // MsgpackWtp = MsgpackWtp.initialize( 2**27 ); //134 MB

    op.out.data = MsgpackWtp.encode( op.in.data );
    op.out.format = 'buffer.node';
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

_.Gdf([ readMsgpackLite, writeMsgpackLite, readMsgpackWtp, writeMsgpackWtp ]);

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

} )();
