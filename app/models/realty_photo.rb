class RealtyPhoto < ActiveRecord::Base
  belongs_to :realty
  
  has_attached_file :photo, :styles => { :small => "120x90>", :original => "468x351>" },
                    :url  => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension"

  validates_attachment_presence :photo, :message => "Необходимо указать фотографию"
  validates_attachment_size :photo, :less_than => 5.megabytes, :message => "Размер фотографии не может превышать 5 Мб"
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => "Поддерживаются только картинки с расширением .jpeg, .png и .gif"
end
