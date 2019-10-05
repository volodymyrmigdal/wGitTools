// ( function _Hooker_s_( ) {
//
// 'use strict';
//
// if( typeof module !== 'undefined' )
// {
//
//   require( '../IncludeBase.s' );
//
// }
//
// //
//
// let _ = wTools;
// let Parent = null;
// let Self = function wGitHooker( o )
// {
//   return _.workpiece.construct( Self, this, arguments );
// }
//
// Self.shortName = 'GitHooker';
//
// // --
// // inter
// // --
//
// function init( o )
// {
//   let git = this;
//
//   _.assert( arguments.length === 0 || arguments.length === 1 );
//
//   _.workpiece.initFields( git );
//   Object.preventExtensions( git );
//
//   if( o )
//   git.copy( o );
//
// }
//
// //
//
// function hookRegister( o )
// {
//   let self  = this;
//   let provider = _.fileProvider;
//   let path = provider.path;
//
//   _.assert( arguments.length === 1 );
//   _.routineOptions( hookRegister, o );
//
//   var specialComment = 'This script is generated by utility willbe';
//
//   try
//   {
//     register();
//     return true;
//   }
//   catch( err )
//   {
//     if( o.throwing )
//     throw err;
//     return null;
//   }
//
//   /* */
//
//   function register()
//   {
//     if( !provider.fileExists( o.filePath ) )
//     throw _.err( 'Source handler path doesn\'t exit:', o.filePath )
//
//     if( !_.arrayHas( KnownHooks, o.hookName ) )
//     throw _.err( 'Unknown git hook:', o.hookName );
//
//     let handlerNamePattern = new RegExp( `${o.hookName}.*` );
//
//     if( !handlerNamePattern.test( o.handlerName ) )
//     throw _.err( 'Handler name:', o.handlerName, 'should match the pattern ', handlerNamePattern.toString() )
//
//     if( o.handlerName === o.hookName || o.handlerName === o.hookName + '.was' )
//     throw _.err( 'Rewriting of original git hook script', o.handlerName, 'is not allowed.' );
//
//     let handlerPath = path.resolve( '.git/hooks', o.handlerName );
//
//     if( !o.rewriting )
//     if( provider.fileExists( handlerPath ) )
//     if( !provider.filesAreSame( o.filePath, handlerPath ) )
//     throw _.err( 'Handler:', o.handlerName, 'for git hook:', o.hookName, 'is already registered. Enable option {-o.rewriting-} to rewrite existing handler.' );
//
//     let sourceCode = provider.fileRead( o.filePath );
//     provider.fileWrite( handlerPath, sourceCode );
//
//     let originalHandlerPath = path.resolve( '.git/hooks', o.hookName );
//
//     if( provider.fileExists( originalHandlerPath ) )
//     {
//       let read = provider.fileRead( originalHandlerPath );
//
//       if( _.strHas( read, specialComment ) )
//       return true
//
//       let originalHandlerPathDst = originalHandlerPath + '.was';
//       if( provider.fileExists( originalHandlerPathDst ) )
//       throw _.err( 'Can\'t rename original git hook file:',originalHandlerPath, '. Path :', originalHandlerPathDst, 'already exists.'  );
//       provider.fileRename( originalHandlerPathDst, originalHandlerPath );
//     }
//
//     _.assert( !provider.fileExists( originalHandlerPath ) );
//
//     let hookLauncher = hookLauncherMake();
//
//     provider.fileWrite( originalHandlerPath, hookLauncher );
//   }
//
//   /*  */
//
//   function hookLauncherMake()
//   {
//     return `#!/bin/bash
//
//     #${specialComment}
//     #Based on
//     #https://github.com/henrik/dotfiles/blob/master/git_template/hooks/pre-commit
//
//     hook_dir=$(dirname $0)
//     hook_name=$(basename $0)
//
//     if [[ -d $hook_dir ]]; then
//       stdin=$(cat /dev/stdin)
//
//       for hook in $hook_dir/$hook_name.*; do
//         echo "Running $hook hook"
//         echo "$stdin" | $hook "$@"
//
//         exit_code=$?
//
//         if [ $exit_code != 0 ]; then
//           exit $exit_code
//         fi
//       done
//     fi
//
//     exit 0
//   `
//   }
// }
//
// hookRegister.defaults =
// {
//   filePath : null,
//   handlerName : null,
//   hookName : null,
//   throwing : 1,
//   rewriting : 0
// }
//
// //
//
// function hookUnregister( o )
// {
//   let self  = this;
//   let provider = _.fileProvider;
//   let path = provider.path;
//
//   _.assert( arguments.length === 1 );
//   _.routineOptions( hookUnregister, o );
//
//   try
//   {
//     if( _.arrayHas( KnownHooks, o.handlerName ) )
//     if( !o.force )
//     throw _.err( 'Removal of original git hook hanler is not allowed. Please enable option {-o.force-} to delete it.' )
//
//     let handlerPath = path.resolve( '.git/hooks', o.handlerName );
//
//     if( !provider.fileExists( handlerPath ) )
//     throw _.err( 'Git hook handler:', handlerPath, 'doesn\'t exist.' )
//
//     provider.fileDelete
//     ({
//       filePath : handlerPath,
//       sync : 1,
//       throwing : 1
//     });
//
//     return true;
//   }
//   catch( err )
//   {
//     if( o.throwing )
//     throw err;
//     return null;
//   }
// }
//
// hookUnregister.defaults =
// {
//   handlerName : null,
//   force : 0,
//   throwing : 1
// }
//
// // --
// // relations
// // --
//
// let Composes =
// {
// }
//
// let Aggregates =
// {
// }
//
// let Associates =
// {
// }
//
// let Medials =
// {
// }
//
// let Restricts =
// {
// }
//
// let Statics =
// {
//   hookRegister,
//   hookUnregister,
// }
//
// let Forbids =
// {
// }
//
// let Accessors =
// {
// }
//
// // --
// // declare
// // --
//
// let Extend =
// {
//
//   // inter
//
//   init,
//
//   Composes,
//   Aggregates,
//   Associates,
//   Medials,
//   Restricts,
//   Statics,
//   Forbids,
//   Accessors,
//
// }
//
// //
//
// _.classDeclare
// ({
//   cls : Self,
//   parent : Parent,
//   extend : Extend,
// });
//
// _.Copyable.mixin( Self );
//
// //
//
// if( typeof module !== 'undefined' && module !== null )
// module[ 'exports' ] = _global_.wTools;
//
// _global_.wTools[ Self.shortName ] = Self;
//
// })();
