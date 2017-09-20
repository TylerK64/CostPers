class User < ApplicationRecord
  has_secure_password
  has_secure_token

  has_many :items
  has_many :uses, through: :items, dependent: :destroy

  validates :first_name, :last_name, :email, :password, presence: true, on: :create
  validates :email, uniqueness: true, on: :create

  def self.valid_login?(email, password)
    user = find_by(email: email)
    if user && user.authenticate(password)
      user
    end
  end

  private

  def invalidate_token
    self.update_columns(token: nil)
  end
end
