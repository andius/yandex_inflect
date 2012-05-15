# encoding: utf-8

require 'httparty'

module YandexInflect
  module Cache
    autoload :RailsCache,  'yandex_inflect/cache/rails_cache'
    autoload :MemoryCache, 'yandex_inflect/cache/memory_cache'
  end

  INFLECTIONS_COUNT = 6

  class Inflection
    include HTTParty
    base_uri 'http://export.yandex.ru'

    def self.fetch(name)
      inflections = get('/inflect.xml', :query => { :name => name })
      inflections["inflections"]["inflection"]
    end
  end

  class << self
    attr_accessor :cache_store

    def cache
      @cache ||= (cache_store == :rails_cache ? Cache::RailsCache : Cache::MemoryCache).new
    end

    def clear_cache
      cache.clear
    end

    def inflections(word)
      cached_word = cache.fetch(word)
      return cached_word if cached_word

      inflections = []
      response = Inflection.fetch(word) rescue nil

      case response
        when Array
          inflections = response.map { |inflection| inflection['__content__'] }
          cache.store(word, inflections)
        when Hash
          inflections.fill(response['__content__'], 0..INFLECTIONS_COUNT-1)
          cache.store(word, inflections)
        else
          inflections.fill(word, 0..INFLECTIONS_COUNT-1)
      end

      inflections
    end
  end
end
