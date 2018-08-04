class Project < ApplicationRecord
  belongs_to :user, optional: true
  has_many :issues, dependent: :destroy
  has_many :user_projects, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :status, presence: true
  paginates_per 15

  private
  
  def self.search search
    if search
      where(["name LIKE? || status LIKE? || description LIKE? || user_id LIKE?" ,
        "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
    else
      all
    end
  end
end