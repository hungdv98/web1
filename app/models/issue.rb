class Issue < ApplicationRecord
  paginates_per 15
  belongs_to :user, optional: true
  belongs_to :project, optional: true
  belongs_to :issue_template, optional: true
  has_many :histories, dependent: :destroy
  has_many :pictures
  accepts_nested_attributes_for :pictures
  has_many :issue_relationships, dependent: :destroy
  VALID_TIME_REGEX = /\A(([0-9]|[0-3][0-9]).[0][0]|[0-9]|[0-3][0-9])\z/i
  validates :estimate_time, format: {with: VALID_TIME_REGEX}, allow_blank: :true
  validates :subject, presence: true, length: {maximum: 100}
  validates_uniqueness_of :subject, :scope => [:project_id]
  mount_uploaders :pictures, PictureUploader
  validate :img_size
  #validates :parent_id, format: { with: /\A\d+\z/}, allow_blank: :false
  def self.search search
    if search
      where(["id =? || subject LIKE?", "%#{search}%", "%#{search}%"])
    else
      all
    end
  end

  private

  def img_size
    if pictures.size > 3.megabytes
      error[:pictures] = "less than 3MB"
    end
  end
end