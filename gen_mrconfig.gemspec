$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require 'gen_mrconfig/version'

Gem::Specification.new do |s|
  s.name = 'gen_mrconfig'
  s.version = GenMRConfig::VERSION
  s.licenses = 'MIT'
  s.platform  = Gem::Platform::RUBY
  s.summary = 'generate myrepos configuration files'
  s.description = 'generate myrepos configuration files'
  s.authors = [ 'Mathieu Sauve-Frankel' ]
  s.email = 'msf@kisoku.net'
  s.files = `git ls-files`.split($/)
  s.bindir = 'bin/'
  s.executables = %w{
    gen_mrconfig
    slow_roll
  }
  s.add_dependency 'mixlib-cli'
  s.add_dependency 'octokit'
end
