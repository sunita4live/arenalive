class UserDeviseMailer < Devise::Mailer
  #helper :application # gives access to all helpers defined within `application_helper`.
  
  default template_path: 'devise/mailer', from: "SpotMyArena <support@spotmyarena.com>" # to make sure that your mailer uses the devise views

  # before_action :add_logo, only: [:confirmation_instructions, :reset_password_instructions]

  # private
  #   def fetch_asset name
  #     asset = MyHaps::Application.assets.find_asset(name)
  #     File.read(asset.pathname) unless asset.nil?
  #   end

  #   def attach_logo
  #     attachments.inline["logo.png"] = fetch_asset("logo.png")
  #   end

  #   def add_logo
  #     attach_logo
  #   end
end