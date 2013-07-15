class User < ActiveRecord::Base
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	attr_accessible :avatar, :avatar_file_name, :name
	has_attached_file :avatar, 
	:url => '/images/users/avatar/:id/:style/:basename.:extension',
	:path => ':rails_root/public/images/users/avatar/:id/:style/:basename.:extension',
	:default_url => 'users/avatar/original/missing.png',
	:styles => {
		:large => "600x600>",
		:medium => "300x300>",
		:small => "100x100>",
		:thumb => "100x100#"
	}

	after_update :reprocess_avatar, :if => :cropping?

	def cropping?
    	!crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  	end
  
  	def avatar_geometry(style = :original)
    	@geometry ||= {}
    	@geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  	end
  
  private
  
  	def reprocess_avatar
    	avatar.reprocess!
  	end
end
