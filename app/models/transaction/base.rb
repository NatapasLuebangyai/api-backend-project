class Transaction::Base < ApplicationRecord
  attr_accessor :skip_approve_on_create

  belongs_to :user
  belongs_to :asset, optional: true

  validates :name,
    uniqueness: true,
    presence: true,
    length: { maximum: 30 }

  monetize :amount_cents,
    numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_amount_form_price, if: :asset
  before_create :approve, unless: :skip_approve_on_create?

  def approve
    self.perform
    self.approved = true
  end

  def approve!
    self.skip_approve_on_create = true
    self.approve
    self.save
  end

  def reject
    self.approved = false
  end

  def reject!
    self.skip_approve_on_create = true
    self.reject
    self.save
  end

  def perform; end

  protected

  def skip_approve_on_create?
    skip_approve_on_create || false
  end

  private

  def set_amount_form_price
    self.amount = asset.price
  end
end
