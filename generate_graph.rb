require 'optparse'
params = ARGV.getopts('n')
load "sentence2graph.rb"

File.open(ARGV[0], "r") { |io|
  sentence = io.read
  s2g = Sentence2Graph.new
  filename = (ARGV[1] || ARGV[0]).match(/([^.]+).?/)[1]
  layout = (params['n']) ? 'neato' : 'dot'
  s2g.generate_graph_from_sentence(sentence, filename, :png, layout)
}