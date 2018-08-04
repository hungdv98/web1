class Emoji < ApplicationRecord
  belongs_to :user
  VALID_EMO_REGEX = /:([\w+-]+):/
  validates :code, presence: true, uniqueness: true, format: {with: VALID_EMO_REGEX}
  validates :user_id, presence: true
  validates :emo, presence: true
  mount_uploader :emo, EmojiUploader
end