# typed: strict
# frozen_string_literal: true

# https://docs-v2.squake.earth/operation/operation-post-calculations
module Squake
  class Calculation
    extend T::Sig

    ENDPOINT = T.let('/v2/calculations', String)

    sig do
      params(
        client: Squake::Client,
        items: T::Array[T.any(Squake::Model::Items::BaseType, T::Hash[T.any(String, Symbol), T.untyped])],
        carbon_unit: String,
        expand: T::Array[String],
      ).returns(Squake::Model::Carbon)
    end
    def self.create(client:, items:, carbon_unit: 'gram', expand: [])
      # @TODO: add typed objects for all possible items. Until then, we allow either a Hash or a T::Struct
      items = items.map do |item|
        item.is_a?(T::Struct) ? item.serialize : item
      end

      result = client.call(
        path: ENDPOINT,
        method: :post,
        params: {
          items: items.map(&:serialize),
          carbon_unit: carbon_unit,
          expand: expand,
        },
      )
      raise Squake::APIError.new(response: result) unless result.success?

      Squake::Model::Carbon.from_api_response(
        T.cast(result.body, T::Hash[Symbol, T.untyped]),
      )
    end
  end
end
