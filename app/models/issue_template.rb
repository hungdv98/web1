class IssueTemplate < ApplicationRecord
  paginates_per 15
  belongs_to :user, optional: true
  has_many :issues, dependent: :destroy
  validates :name, presence: true, length: {maximum: 255},
    uniqueness: true
  validates :description, presence: true,length: {maximum: 10000}
end