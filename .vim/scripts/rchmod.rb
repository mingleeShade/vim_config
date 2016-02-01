#!/usr/bin/env ruby

require 'getoptlong'


# get correct path
dir = "./"
if ARGV.size != 0 then
  dir = ARGV.first
end

def call_system_command(cmd)
  result = false
# if @debug then
#   puts "Absolute path is: #{Dir.pwd}"
# # puts "\t#{cmd}"
#   print "Command is: "
#   print_warning " #{cmd}"
#   puts
#   result = true
# else
    result = system(cmd)
# end
end

def remove_exe_attribute(path, fullname)
  puts "true #{fullname}" if File.executable? fullname
  puts "false #{fullname}" unless File.executable? fullname
  cmd_chmod = "chmod a-x #{fullname}"
  puts cmd_chmod
  result = call_system_command(cmd_chmod)
  # Dir.chdir(path) do
  #   cmd_chmod = "chmod a-x #{@fullname}"
  #   result = call_system_command(cmd_chmod)
  # end
end

def rchmod(path)
  path += "/" unless path.end_with? "/"
  puts path
  Dir.foreach(path) do |entry|
    # skip self and parent directory
    next if entry == "." || entry == ".." || entry == "rchmod.rb"

    # get fullname for each entry
    fullname = path + entry

    # recursive call rchmod if fullname if a directory
    rchmod(fullname) if File.directory? fullname
    next if File.directory? fullname

    # remove the executable attribute for executable files
    remove_exe_attribute(path, fullname) if File.executable? fullname
  end
end

rchmod dir


# vim:set tabstop=2 shiftwidth=2 expandtab:
