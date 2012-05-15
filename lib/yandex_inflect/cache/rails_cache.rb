# encoding: utf-8

module YandexInflect
  module Cache
    class RailsCache
      attr_reader :cache, :keys

      def initialize
        @cache = Rails.cache
        @keys  = []
      end

      def fetch(word)
        cache.read(key(word))
      end

      def store(word, value)
        word_key = key(word)
        cache.write(word_key, value)
        keys << word_key unless keys.include?(word_key)
      end

      def clear
        while word_key = keys.pop
          cache.delete(word_key)
        end
      end

      private

      def key(word)
        [prefix, encode(word)].join
      end

      def prefix
        :inflected_
      end

      def encode(word)
        Digest::SHA1.hexdigest(word)
      end
    end
  end
end
