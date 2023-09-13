class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true
  
  validates :name, :url, presence: true
  validates_format_of :url, with: URI.regexp, on: :create

  def gist?
    self.url.include?("gist.github.com")
  end

  def gist_id
    self.url.split('/').last
  end
end
