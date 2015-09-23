class GroundAttachment < ActiveRecord::Base
	mount_uploader :photo, PhotoUploader
    belongs_to :ground
end
