require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
#Bundler.require(*Rails.groups(assets: %w(development test)))
Bundler.require(:default, Rails.env)

module Praiseme
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += %W(#{config.root}/lib)

  #  config.middleware.insert_before 0, "StampSuggestions"

  end

  #NLP_PIPE_LINE = StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref)
  #require "wordnet"
  #NLP_LEX = WordNet::Lexicon.new



end

Hirb.enable

#module SimilarKeywordHelper
  #def self.refine_keywords(original_text, keywords)
    #uniq_keywords = keywords.uniq
    #uniq_keywords = uniq_keywords - [original_text]
  #end
#end

#class String
  #def to_pos_tags
    #text_anno = StanfordCoreNLP::Annotation.new(self)
    #Praiseme::NLP_PIPE_LINE.annotate(text_anno)
    #pos_hashes = []
    #text_anno.get(:sentences).each do |sentence|
      #sentence.get(:tokens).each do |token|
        #part_of_speech = token.get(:part_of_speech).to_s
        #original_text = token.get(:original_text).to_s

        #last_hash = pos_hashes.last
        #if last_hash.present? && last_hash[:pos].pos_label == :adjective && part_of_speech.pos_label == :noun
          #pos_hashes = [{:text => "#{last_hash[:text]} #{original_text}", :pos => "PHRASE"}] + pos_hashes
        #end
        #if last_hash.present? && last_hash[:pos].pos_label == :noun && part_of_speech.pos_label == :noun
          #last_hash[:text] = "#{last_hash[:text]} #{original_text}"
        #else
          #pos_hashes << {:text => original_text, :pos => part_of_speech}
        #end
      #end
    #end
    #return pos_hashes
  #end

  #def pos_label
    #pos_labels = {:noun => ["NN", "NNS", "NNP", "NNPS", "PRP", "PRP$", "WP", "WP$"],
           #:verb => ["VB", "VBD", "VBG", "VBN", "VBP", "VBZ"],
           #:adjective => ["JJ", "JJR", "JJS"],
           #:adverb => ["RB", "RBR", 'RBS'],
           #:phrase => ["PHRASE"]
          
    #}
    #pos_labels.each_pair do |pos_label, list|
      #if list.include? self
        #return pos_label
      #end
    #end

    #return nil

  #end

  #def similar_keywords

    #keywords = {:phrase => [], :noun => [], :adjective => [], :verb => [], :adverb => []}
    #self.to_pos_tags.each do |pos_tag|
      #if pos_tag[:pos].pos_label.present?
        #if pos_tag[:pos].pos_label == :phrase
          #keywords[:phrase] = SimilarKeywordHelper.refine_keywords(self, keywords[:phrase] + pos_tag[:text].synomyms)
        #else
          #keywords[pos_tag[:pos].pos_label] = SimilarKeywordHelper.refine_keywords(self, keywords[pos_tag[:pos].pos_label] + pos_tag[:text].synomyms(pos_tag[:pos].pos_label.to_s))
          #if pos_tag[:pos].pos_label == :adjective
            #keywords[:adjective] = SimilarKeywordHelper.refine_keywords(self, keywords[:adjective] + pos_tag[:text].synomyms("adjective satellite").uniq)
          #end
        #end
      #end
    #end
    #return keywords
  #end

  #def synomyms(pos = nil)
    #if pos.present?
      #synsets = Praiseme::NLP_LEX.lookup_synsets(self, pos)
    #else
      #synsets = Praiseme::NLP_LEX.lookup_synsets(self)
    #end
    #synsets.map {|synset| synset.words.map{|word| word.to_s}}.flatten
  #end
#end


