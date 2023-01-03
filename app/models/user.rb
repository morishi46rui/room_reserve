class User < ApplicationRecord
  
  has_many :rooms
  has_many :reservations

  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  
  validates :name, presence: true, length: {maximum: 50}

  def is_active_host
    !self.merchant_id.blank?
  end
  
end
