module ApplicationHelper
	def resource_name
	   :user
	end

	def resource
	   @resource ||= User.new
	end

	def devise_mapping
	   @devise_mapping ||= Devise.mappings[:user]
	end

	def generate_unique_id
	  charset = [('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
	  (0...7).map{ charset.to_a[rand(charset.size)] }.join
	end
end
