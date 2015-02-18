#!/usr/bin/env ruby
#
# Do things with (update, print) a shopping list.
#

require "trollop"

class ShoppingList
  attr_reader :list

  def initialize(file)
    @filename = file
    @list = File.new(@filename, "r").read.split(/\n/)
  end

  def show
    for line in @list
      puts "  [ ] " + line
    end
  end

  def write
    file = File.new(@filename, "w")
    for line in @list
      file.puts(line)
    end
  end

  def add(item)
    @list << item
    write
  end

  def clear
    @list = []
    write
  end

  def print
    `lp #{@filename}`
  end
end

opts = Trollop::options do
  opt :file, "File to use as list", short: "f"
  opt :print, "Print the list after any other operations", short: "p"
  opt :clear, "Clear the list", short: "c"
end

if opts[:file]
  file = opts[:file]
else
  file = ENV["HOME"] + "/shopping.md"
end

list = ShoppingList.new(file)

if opts[:clear]
  list.clear
end

# add any arguments
ARGV.each do |arg|
  list.add(arg)
  puts "#{arg} added"
end

# print finished list
list.show

if opts[:print]
  list.print
  puts "printed"
end
