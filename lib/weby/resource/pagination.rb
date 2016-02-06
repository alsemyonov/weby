require 'weby/resource'

class Weby
  module Resource
    module Pagination
      class Paginator
        # @param [Weby::Resource] resource
        def initialize(resource)
          @resource = resource
        end

        # @return [Boolean]
        def paginated?
          data['pageable']
        end

        delegate :data, to: :@resource
      end

      # @return [Paginator]
      def paginator
        @paginator ||= Paginator.new(self)
      end

      delegate :paginated?, to: :paginator
    end

    include Pagination
  end
end