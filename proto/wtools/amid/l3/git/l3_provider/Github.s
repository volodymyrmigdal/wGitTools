( function _Github_s_()
{

'use strict';

let Github, Octokit;
const _ = _global_.wTools;
const Parent = _.repo;
_.repo.provider = _.repo.provider || Object.create( null );

// --
// implement
// --

function _open( o )
{
  _.map.assertHasAll( o, _open.defaults );
  _.assert( _.objectIs( o.remotePath ) );
  let ready = _.take( null );
  ready
  .then( () =>
  {
    if( !Octokit )
    Octokit = require( '@octokit/rest' ).Octokit;
    const octokit = new Octokit
    ({
      auth : o.token,
    });
    return octokit;
  })
  return ready;
}

_open.defaults =
{
  token : null,
}

//

function _responseNormalize()
{
  _.assert( 0, 'not implemented' );
}
_responseNormalize.defaults =
{
  requestCommand : null,
  options : null,
  fallingBack : 1,
  response : null,
  result : null,
}

//

function pullListAct( o )
{
  let self = this;
  let ready = _.take( null );
  _.map.assertHasAll( o, pullListAct.defaults );
  _.assert( _.objectIs( o.remotePath ) );
  return this._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.pulls.list
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
    })
  })
  .then( ( response ) =>
  {
    o.result = self._pullListResponseNormalize
    ({
      requestCommand : 'octokit.rest.pulls.list',
      options : o,
      response,
    })
    return o;
  });
}

pullListAct.defaults =
{
  ... Parent.pullListAct.defaults,
}

//

function _pullListResponseNormalize( o )
{
  let result = o.result = o.result || Object.create( null );
  let response = o.response;
  result.total = response.data.total_count;
  result.original = response;
  result.type = 'repo.pull.collection';
  result.elements = response.data.map( ( original ) =>
  {
    let r = Object.create( null );
    r.original = original;
    r.type = 'repo.pull';
    r.description = Object.create( null );
    r.description.head = original.title;
    r.description.body = original.body;
    r.to = Object.create( null );
    r.to.tag = original.base.ref;
    r.to.hash = original.base.sha;
    r.from = Object.create( null );
    r.from.name = original.head.xxx.login;
    r.id = original.number;
    return r;
  });
  return result;
}

_pullListResponseNormalize.defaults =
{
  ... _responseNormalize.defaults,
  requestCommand : 'octokit.rest.pulls.list',
}

//

function pullOpenAct( o )
{
  const self = this;
  _.map.assertHasAll( o, pullOpenAct.defaults );
  _.assert( _.aux.is( o.remotePath ) );
  const ready = new _.Consequence();

  return this._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.pulls.create
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
      title : o.descriptionHead || '',
      body : o.descriptionBody || '',
      head : o.srcBranch,
      base : o.dstBranch,
    });
  })
  .finally( ( err, arg ) =>
  {
    if( err )
    /* Dmytro : the structure of HTTP error is : message, statusCode, headers, body */
    throw _.err( `Error code : ${ err.statusCode }. ${ err.message }` );

    if( o.logger && o.logger.verbosity >= 3 )
    o.logger.log( arg );
    else if( o.logger && o.logger.verbosity >= 1 )
    o.logger.log( `Succefully created pull request "${ o.descriptionHead }" in ${ _.git.path.str( o.remotePath ) }.` );

    return arg;
  });
}

pullOpenAct.defaults =
{
  token : null,
  remotePath : null,
  descriptionHead : null,
  descriptionBody : null,
  srcBranch : null,
  dstBranch : null,
  logger : null,
};

//

function programListAct( o )
{
  let self = this;
  let ready = _.take( null );
  _.map.assertHasAll( o, programListAct.defaults );
  _.assert( _.objectIs( o.remotePath ) );
  return this._open( o )
  .then( ( octokit ) =>
  {
    return octokit.rest.actions.listRepoWorkflows
    ({
      owner : o.remotePath.user,
      repo : o.remotePath.repo,
      per_page : 100,
    });
  })
  .then( ( response ) =>
  {
    o.result = self._programListResponseNormalize
    ({
      requestCommand : 'octokit.rest.actions.listRepoWorkflows',
      options : o,
      response,
    });
    return o;
  });
}

programListAct.defaults =
{
  ... Parent.pullListAct.defaults,
}

//

function _programListResponseNormalize( o )
{
  let result = o.result = o.result || Object.create( null );
  let response = o.response;
  result.total = response.data.total_count;
  result.original = response;
  result.type = 'repo.program.collection';
  result.elements = response.data.workflows.map( ( original ) =>
  {
    let r = Object.create( null );
    r.original = original;
    r.type = 'repo.program';
    r.name = original.name;
    r.id = original.id;
    r.state = original.state;
    r.fileRelativePath = original.path;
    r.fileGlobalPath = original.html_url;
    r.service = 'github';
    return r;
  });
  return result;
}

_programListResponseNormalize.defaults =
{
  ... _responseNormalize.defaults,
  requestCommand : 'octokit.rest.actions.listRepoWorkflows',
}

// --
// declare
// --

const _responseNormalizersMap =
{

  'octokit.rest.pulls.list' : pullListAct,
  'octokit.rest.actions.listRepoWorkflows' : _programListResponseNormalize,

}

//

const Self =
{

  name : 'github',
  names : [ 'github', 'github.com' ],
  _responseNormalizersMap,

  //

  _open,
  _responseNormalize,

  pullListAct,
  _pullListResponseNormalize,

  pullOpenAct,

  programListAct,
  _programListResponseNormalize,

}

_.repo.providerAmend({ src : Self });

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
