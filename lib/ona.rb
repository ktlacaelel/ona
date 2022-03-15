#!/usr/bin/env ruby

require 'ostruct'
require 'readline'
require 'isna'

class Ona
  def self.resource(name, attributes)
    @resources ||= {}
    @resources[name] ||= {}
    @resources[name][:class] = Struct.new(*attributes)
    @resources[name][:entries] = []
    @resources[name][:handlers] = []
    @resources[name][:attributes] = attributes
    _create_to_s_method(@resources[name])
    nil
  end
  def self._create_to_s_method(resource)
    attribute_sizes = resource[:attributes].map do |attribute|
      attribute.to_s.size
    end
    resource[:class].send(:define_method, :to_s) do
      max_attribute_length = attribute_sizes.sort.last + 4
      resource[:attributes].sort.map do |attribute|
        key = attribute.to_s.rjust(max_attribute_length, ' ')
        "#{key.to_ansi.green.to_s} : #{send(attribute)}"
      end * "\n"
    end
  end
  def self.register(name, &block)
    object = @resources[name][:class].new
    block.call(object)
    @resources[name][:entries].push(object)
    nil
  end
  def self.action(hash, &block)
    unless hash[:find]
      _generic_action(hash, &block)
      return
    end
    unless hash[:token]
      $stderr.puts "No token for: #{hash.inspect}"
      exit 1
    end
    _single_action(hash, &block)
  end
  def self._generic_action(hash, &block)
    hash[:block] = block
    @resources[hash[:resource]][:handlers].push(hash)
    nil
  end
  def self._single_action(hash, &block)
    Ona._generic_action(hash) do |resources, command, regex|
      wanted_id = hash[:token].call(command.scan(regex))
      wanted_id = wanted_id.to_i
      resources.each_with_index do |array, id|
        next if id != wanted_id
        block.call(array, id)
      end
    end
  end
  def self.run(command)
    @resources.each do |name, resource|
      resource[:handlers].each do |handler|
        next unless handler[:regex].match(command)
        handler[:block].call(resource[:entries], command, handler[:regex])
        return
      end
    end
    nil
  end
  def self.prompt=(string)
    @prompt = string
  end
  def self.prompt
    @prompt
  end
  def self.main(use_defaults = true)
    defaults if use_defaults
    _prompt = (prompt || 'Ona').to_ansi.cyan.to_s + '> '
    while input = Readline.readline(_prompt, true)
	  Ona.run(input)
    end
    puts ''
  end
  def self._get_max_regex_length
    max = 0
    @resources.each do |name, resource|
      resource[:handlers].each do |handler|
        if max < handler[:regex].inspect.size
          max = handler[:regex].inspect.size
        end
      end
    end
    max
  end
  def self._get_max_example_length
    max = 0
    @resources.each do |name, resource|
      resource[:handlers].each do |handler|
        if max < handler[:example].size
          max = handler[:example].size
        end
      end
    end
    max
  end
  def self._get_max_name_length
    max = 0
    @resources.each do |name, resource|
      if max < name.size
        max = name.size
      end
    end
    max
  end
  def self.help
    @resources.each do |name, resource|
      pretty_name = "[#{name}]".to_s.rjust(_get_max_name_length + 2, ' ')
      pretty_name = pretty_name.to_ansi.cyan.to_s
    resource[:handlers].sort do |a, b|
      a[:example] <=> b[:example]
    end.each do |handler|
        pretty_regex = handler[:regex].inspect.ljust(_get_max_regex_length, ' ')
        pretty_regex = pretty_regex.to_s.to_ansi.pink.to_s
        pretty_example = handler[:example].ljust(_get_max_example_length, ' ')
        pretty_example = pretty_example.to_s.to_ansi.yellow.to_s
        puts "#{pretty_name} #{pretty_example} #{handler[:text]}"
      end
    end
  end
  def self.defaults
    Ona.resource(:any, [:empty])

    Ona.action(
      :regex    => /(^)(quit|exit)($)/,
      :resource => :any,
      :text     => 'Exit this program.',
      :example  => 'quit'
    ) do |resource, command, regex|
      puts 'bye.'
      exit 0
    end

    Ona.action(
      :regex    => /^help$/,
      :resource => :any,
      :text     => 'Print help.',
      :example  => 'help'
    ) do |resource, command, regex|
      Ona.help
    end
  end
  def self.confirm(text, expected)
    puts ''
    puts "# " + " #{text} ".to_ansi.white.red_background.to_s
    puts "# " + '=' * 78
    puts "Type [#{expected.to_ansi.green.to_s}] to continue. or anything else to skip."
    print 'What to do? >'
    input = gets.chomp
    input == expected
  end
end

