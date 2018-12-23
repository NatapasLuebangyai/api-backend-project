module ClearCacheable
  def clear_cacheable
    [Asset, AssetBalance, Balance].each do |klass|
      Rails.cache.delete(klass.to_s.underscore)
    end
  end
end
