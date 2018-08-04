class History < ApplicationRecord
  paginates_per 15
  belongs_to :issue, optional: true
end