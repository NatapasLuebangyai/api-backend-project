class Transaction::Base < ApplicationRecord
  include Cacheable

  attr_accessor :skip_perform_on_create

  belongs_to :user
  belongs_to :asset, optional: true

  validates :name,
    uniqueness: true,
    presence: true,
    length: { maximum: 30 }

  monetize :amount_cents,
    numericality: { greater_than_or_equal_to: 0 }

  before_validation :generate_name, on: :create
  before_validation :set_amount_from_price, on: :create, if: :asset
  before_create :perform_on_create, unless: :skip_perform_on_create?

  scope :with_type, -> (t) { where(type: "Transaction::#{t.classify}") }

  def approve
    self.approved = true
  end

  def approve!
    self.skip_perform_on_create = true
    self.approve
    self.save
  end

  def reject
    self.approved = false
  end

  def reject!
    self.skip_perform_on_create = true
    self.reject
    self.save
  end

  def perform(options = {})
    true
  end

  def display_informations
    hash = {
      id: self.id,
      name: self.name,
      type: self.class.to_s.demodulize.underscore,
      amount: self.amount.format(symbol: false),
      created_at: self.created_at
    }

    hash.merge(dynamic_informations)
  end

  def user_balance
    @user_balance ||= cache_query(Balance, user_id: self.user_id)
  end

  def user_asset_balance
    return @user_asset_balance if @user_asset_balance.present?

    @user_asset_balance = cache_query(AssetBalance, balance_id: user_balance.id, asset_id: self.asset_id)
    @user_asset_balance ||= AssetBalance.new(balance: user_balance, asset_id: self.asset_id)
  end

  protected

  def skip_perform_on_create?
    skip_perform_on_create
  end

  def dynamic_informations
    {}
  end

  def perform_on_create
    throw :abort if !self.perform || self.errors.present?
    approve
  end

  def try_perform
    begin
      self.perform(save: false)
    rescue => e
      errors.add(:base, e) if self.errors.blank?
    end

    throw :abort if self.errors.present?
  end

  private

  def set_amount_from_price
    self.amount = cache_query(Asset, id: self.asset_id).price
  end

  def generate_name
    self.name ||= SecureRandom.urlsafe_base64
  end
end
