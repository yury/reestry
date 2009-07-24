class RealtyPhoto < ActiveRecord::Base
  belongs_to :realty
  
  has_attached_file :photo, :styles => { :small => "120x90#", :original => "468x351>" },
                    :convert_options => { :small => '-strip -quality 75', :original => '-strip'},
                    :url  => "/assets/images/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/images/:id/:style/:basename.:extension"

  validates_attachment_presence :photo#, :options => {:message => "Необходимо указать фотографию"}
  validates_attachment_size :photo, :less_than => 5.megabytes#, :message => "Размер фотографии не может превышать 5 Мб"
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']#, :message => "Поддерживаются только картинки с расширением .jpeg, .png и .gif"
end
