class Contact < ActiveRecord::Base
  belongs_to :contact_type
  belongs_to :user
  has_and_belongs_to_many :realties
end
