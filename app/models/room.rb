class Room < ApplicationRecord
  belongs_to :user

  has_many :reservations

  has_one_attached :image

  validates :listing_name, presence: true
  validates :summary, presence: true
  validates :price, presence: true
  validates :address, presence: true
  validates :image, presence: true

end
