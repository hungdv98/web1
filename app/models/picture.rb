class Picture < ApplicationRecord
  belongs_to :issue
  mount_uploader :img, PictureUploader
  validates_processing_of :img
  validate :img_size

  private

  def img_size
    if img.size > 3.megabytes
      error[:img] = t "models.picture.img_error"
    end
  end
end