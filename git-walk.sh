#!/usr/bin/ruby -w

require "find"
require "optparse"
require "ostruct"

Options = OpenStruct.new

Options.verbose = 1

OptionParser.new do |opts|
  opts.banner = "Usage: git-walk [options] [<command>]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    if v
      Options.verbose += 1
    else
      Options.verbose = 0
    end
  end

  opts.on("-q", "--[no-]quiet", "Run quiet") do |q|
    if q
      Options.verbose = 0
    else
      Options.verbose = 1
    end
  end

  opts.on("-w", "--walk PATH", "Path to start walking from.") do |v|
    Options.walk ||= []
    Options.walk << v
  end
end.parse!

STATUS = ["git", "status", "--short", "-b"]

Cmd = ARGV.empty? ?  STATUS : ARGV

unless Options.walk
  Options.walk = [ "." ]
end

if Options.verbose > 1
  p Options
  p Cmd
end

Find.find(*Options.walk) do |path|
  puts "? "+path if Options.verbose > 1
  next unless FileTest.directory? path
  next unless FileTest.directory? path+"/.git"

  begin
    pwd = Dir.pwd
    Dir.chdir path

    if Cmd.empty?
      puts path
      next
    end

    cmd = Cmd.dup

    if Options.verbose > 0
      puts "cd #{path}; #{cmd.join " "}"
    end

    system(*cmd)

    unless $?.success?
      $stderr.write "cmd failed with #{$?} - #{cmd.inspect}\n"
      unless $?.exited?
        exit! 1
      end
    end
  ensure
    Dir.chdir pwd

    Find.prune
  end
  
end

