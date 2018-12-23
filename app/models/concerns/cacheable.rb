module Cacheable
  extend ActiveSupport::Concern
  ALLOWED_CACHE_CLASS = [
    Balance,
    Asset,
    AssetBalance
  ]

  def cache_query(klass, query)
    return unless ALLOWED_CACHE_CLASS.include?(klass)
    hash = Rails.cache.read(klass.to_s.underscore) rescue nil
    hash ||= {}

    object = query_from_hash(hash, query)
    return object if object.present?

    object = klass.find_by(query)
    return nil unless object.present?

    hash[object.id] = object
    Rails.cache.write(klass.to_s.underscore, hash, expires_in: 60.seconds)
    object
  end

  def cache_write(object)
    klass = object.class
    return unless ALLOWED_CACHE_CLASS.include?(klass)

    hash = Rails.cache.read(klass.to_s.underscore) rescue nil
    hash ||= {}
    hash[object.id] = object
    Rails.cache.write(klass.to_s.underscore, hash, expires_in: 60.seconds)
  end

  private

  def query_from_hash(hash, query)
    result = if query[:id].present?
      hash[query[:id]]
    else
      hash.values.detect do |object|
        query.all? { |key, val| object[key] == val }
      end
    end

    result
  end
end
