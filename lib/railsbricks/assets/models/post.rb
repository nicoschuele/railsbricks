class Post < ActiveRecord::Base
  # Use friendly_id
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Markdown
  before_save { MarkdownWriter.update_html(self) }

  # Validations
  validates :title, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :content_md, presence: true

  # Pagination
  paginates_per 30

  # Relations
  belongs_to :user

  # Scopes
  scope :published, lambda {
    where(draft: false)
    .order("updated_at DESC")
  }

  scope :drafted, lambda {
    where(draft: true)
    .order("updated_at DESC")
  }

end
