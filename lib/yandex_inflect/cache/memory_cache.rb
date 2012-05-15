# encoding: utf-8

module YandexInflect
  module Cache
    class MemoryCache
      attr_reader :cache

      def initialize
        @cache = {}
      end

      def fetch(word)
        cache[key(word)]
      end

      def store(word, value)
        cache[key(word)] = value
      end

      def clear
        @cache = {}
      end

      private

      def key(word)
        word.to_s
      end
    end
  end
end
