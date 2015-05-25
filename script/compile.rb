#!/usr/bin/env ruby
project = ARGV[0] or raise 'no project given'

path    = File.expand_path("~/nanoclouds/#{project}")
File.exists?(path) or raise "project #{path} does not exist"

`rm -r output`

%w(
  content
  layouts
  rules_preprocess.rb
  rules_compile.rb
  config.yaml
  lib/filters_local.rb
  lib/helpers_local.rb
).each do |file|
  `rm -r #{file}`
  if File.exists?("#{path}/#{file}")
    `cp -r #{path}/#{file} #{file}`
  end
end

{
  'layouts-default' => 'layouts'
}.each do |source, target|
  `cp #{source}/* #{target}`
end

puts "compiling..."

puts `nanoc co`
