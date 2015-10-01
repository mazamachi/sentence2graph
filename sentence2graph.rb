require 'cabocha'
require 'gviz'

class Sentence2Graph
  attr_accessor :parser, :gv
  def initialize
    @parser = CaboCha::Parser.new
    @gv = Gviz.new
  end

  # 空白を含まないものを文節に分解して配列にする
  def parse_string_to_array(str)
    if str.match("\s")
      raise "str must be one line"
    end
    tree = self.parser.parse(str)
    return tree.toString(CaboCha::FORMAT_TREE).force_encoding("utf-8").gsub(" ","").gsub("EOS","").gsub(/-*D *\|?/,"").split
  end

  # 文章を与えられたら文節に分解して返す
  def parse_sentence_to_array(str)
    return str.gsub("　","").split.map{|s| self.parse_string_to_array(s)}.flatten
  end

  def generate_link_array(str)
    # {あ=>["い", "う"], か=>["き", "く"]}みたいなやつ
    words = parse_sentence_to_array(str)
    words.unshift("START")
    words.push("END")
    from_to_array = {}
    len = words.length
    words.each_with_index do |word, index|
      if from_to_array[word] == nil
        from_to_array[word] = []
      end

      if index==len-1
        break
      end

      from_to_array[word] << words[index+1]
    end
    from_to_array
  end

  def generate_graph_from_sentence(str, filename=:graph, filetype=:png, layout="dot")
    words = parse_sentence_to_array(str)
    links = generate_link_array(str)
    len = words.length
    edge_style = ["bold", "solid", "dashed", "dotted"]

    self.gv.graph do
      global layout: layout, overlap:false, splines:true
      links.each do |from, ar|
        node make_sym(from), label: from, fontsize: 20*(ar.length/2+1)
        ar.uniq.each_with_index do |to, index|
          route make_sym(from) => make_sym(to)
          edge (make_sym(from).to_s+"_"+make_sym(to).to_s).to_sym, style: edge_style[index%4]
          node make_sym(to), label: to
        end
      end
      # words.each_with_index do |word, index|
      #   if index==len-1
      #     break
      #   end
      #   route make_sym(word) => make_sym(words[index+1])
      #   node make_sym(word), label: word
      # end
      # node make_sym(words.last), label: words.last
    end
    self.gv.save(filename, filetype)
  end
end

def make_sym(str)
  str.to_s.split("").map(&:ord).join.to_sym
end
