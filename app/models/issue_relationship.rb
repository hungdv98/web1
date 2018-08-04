class IssueRelationship < ApplicationRecord
  belongs_to :issue, optional: true
  validates :issue_relation, presence: true
  validates_uniqueness_of :issue_relation, :scope => [:issue_id]
end