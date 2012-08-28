#!/usr/bin/env ruby

# This program is used by Chef to regenerate bcsec.rb for the CAS server.
# Modifications will be overwritten.

require 'erb'

fragments = ARGV[0]
target = ARGV[1]

authorities = []
kvs = {}

Dir["#{fragments}/authorities/*"].each do |fn|
  authorities << File.read(fn)
end

Dir["#{fragments}/*"].reject { |fn| File.directory?(fn) }.each do |fn|
  kvs[File.basename(fn)] = File.read(fn)
end

template = ERB.new(DATA.read)

File.open(target, 'w') { |f| f.write(template.result(binding)) }

__END__
Bcsec.configure do
  authorities <%= authorities.join(', ') %>
  <% kvs.each do |k, v| %>
    <%= k %> "<%= v %>"
  <% end %>
end
