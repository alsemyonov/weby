require 'weby/resource'

class Weby
  module Resource
    module Sortable
      include Comparable

      def position
        data['position'].to_i
      end

      def published_at_timestamp
        published_at.to_time.to_i
      end

      def to_sortable
        [position, published_at_timestamp, url.to_s]
      end

      def <=>(other)
        to_sortable <=> other.to_sortable
      end
    end

    include Sortable
  end
end
