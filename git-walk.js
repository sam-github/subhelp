#!/usr/bin/env node

var Parser = require('posix-getopt').BasicParser;
var Queue = require('async').queue;
var each = require('async').each;
var exec = require('child_process').exec;
var fs = require('fs');
var path = require('path');
var spawn = require('child_process').spawn;

// May need graceful-fs, might even need graceful-exec...

var parser = new Parser([
  ':v(verbose)',
  'q(quiet)',
  'w:(walk)',
  '1(serial)',
  'n(parallel)',
  'c:(concurrency)',
].join(''), process.argv);

var option;
var verbose = 1;
var where = process.cwd();
var concurrency = 1;

while ((option = parser.getopt()) !== undefined) {
  switch (option.option) {
    case 'v': verbose += 1; break;
    case 'q': verbose = 0; break;
    case 'w': where = option.optarg; break;
    case '1': concurrency = 1; break;
    case 'n': concurrency = 20; break;
    case 'c': concurrency = Number(option.optarg) || concurrency; break;
    default:
      console.error('Invalid usage (near options \'%s\')', options.optopt);
      process.exit(1);
  }
}

var debug = verbose > 1 ? console.log : function() {};

var args = process.argv.slice(parser.optind());

if (!args.length)
  args = ['git', 'status', '--short', '-b']

var cmd = args.join(' ');
var arg0 = args.shift();

var queue = Queue(execute, concurrency);

debug('where: %s', where);
debug('concurrency: %s', concurrency);
debug('cmd: %s', cmd);

follow(process.cwd(), where);

function follow(from, dir, done) {
  var where = path.resolve(from, dir);

  debug('follow from %j dir %j where %j', from, dir, where);

  if (!done) done = function() {};

  fs.readdir(where, function(err, dirs) {
    if (err) {
      // Wasn't a directory: ENOTDIR
      // Dangling symlink: ENOENT
      if (err.code !== 'ENOTDIR' && err.code !== 'ENOENT')
        console.error('readdir failed: %s', err.message);
      return done();
    }

    if (dirs.indexOf('.git') >= 0) {
      push(where);
      return done();
    }

    debug('where %j dirs: %j', dirs);

    each(dirs, follow.bind(null, where), done);
  });
}

function push(where) {
  queue.push(where);
}

function execute(where, done) {
  debug('executor where %j', where);

  var options = {
    cwd: where,
    env: process.env,
    encoding: 'utf8',
    stdio: 'inherit',
    // maxBuffer: 200 * 1024, // default, probably enough
  };

  // git colors output when its writing directly to the console, and those
  // colors are nice, but in parallel mode, direct writing just causes the
  // output to be intermixed on the screen. We can't have our cake and eat it
  // too. We have to choose parallel execution, where output is buffered so it
  // can be written atomically, or serial execution, where output is written
  // directly to console and colored.
  //
  // Buffered is done with exec, direct is done with spawn.

  if (concurrency === 1) {
    if (verbose) console.log('cd %s; `%s`', where, cmd);

    return spawn(arg0, args, options).on('exit', onExit);
  }

  exec(cmd, options, function(err, stdout, stderr) {
    if (err) return onExit(err.code, err.signal);

    if (verbose) console.log('cd %s; `%s`', where, cmd);
    process.stdout.write(stdout);
    process.stderr.write(stderr);
    return onExit(0);
  });

  function onExit(code, signal) {
    if (code === 0) return done();

    console.error('cmd `%s` failed with %s', cmd, signal || code);

    if (signal)
      process.kill(process.pid, err.signal);

    return done();
  }
}
