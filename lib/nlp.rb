module Nlp

  PIPE_LINE = StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
  require "wordnet"
  LEX = WordNet::Lexicon.new
end
