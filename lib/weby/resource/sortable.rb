require 'weby/resource'

class Weby
  module Resource
    module Sortable
      include Comparable

      # @return [Fixnum]
      def position
        @position ||= data['position'] ? data['position'].to_i : (2**(0.size * 8 -2) -1)
      end

      # @return [(Fixnum, Fixnum, String)]
      def to_sortable
        [position, published_at_timestamp, url.to_s]
      end

      # @param [Weby::Resource::Sortable] other
      # @return [-1, 0, 1]
      def <=>(other)
        to_sortable <=> other.to_sortable
      end

      # @return [<Weby::Resource::Sortable>]
      def children
        @sorted_children ||= super.sort
      end

      private

      # @return [Fixnum]
      def published_at_timestamp
        published_at.to_time.to_i
      end
    end

    include Sortable
  end
end
