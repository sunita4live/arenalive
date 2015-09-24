  class User < ActiveRecord::Base
    include ApplicationHelper
    rolify
    #enum roles: [:member, :ground_owner, :admin]
    
    acts_as_commontator
    
    ratyrate_rater

    attr_accessor :role 
    attr_accessor :current_password
    after_create :set_role
    after_create :set_member_id
    has_many :grounds, :dependent => :destroy
    has_many :bookings, :dependent => :destroy
    
    mount_uploader :avatar, AvatarUploader

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable#, :confirmable

    def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      if user
        return user
      else
        registered_user = User.where(:email => auth.info.email).first
        if registered_user
          return registered_user
        else
          user = User.new(
            first_name: auth.extra.raw_info.first_name,
            last_name: auth.extra.raw_info.last_name,
            provider: auth.provider,
            uid: auth.uid,
            oauth_token: auth.credentials.token,
            oauth_expires_at:  Time.at(auth.credentials.expires_at),
            email:auth.info.email,
            password:Devise.friendly_token[0,20]
          )
          user.add_role 'member'
          #user.skip_confirmation!
          user.save
          user
        end    
      end
    end

    def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
      if user
        return user
      else
        registered_user = User.where(:email => access_token.info.email).first
        if registered_user
          return registered_user
        else
          
          user = User.new(first_name: data["first_name"],
            provider:access_token.provider,
            email: data["email"],
            uid: access_token.uid ,
            password: Devise.friendly_token[0,20],
            confirmed_at: Time.now,

          )
          user.add_role 'member'
          #user.skip_confirmation!
          user.save
          user
        end
      end
    end

    def name
      [self.first_name, self.last_name].join(' ')
    end
    private
    
    def set_role
      self.add_role role
    end

    def set_member_id
      id = generate_unique_id
      self.update(member_id: id)
    end

    # def confirmation_required?
    #   true
    # end

    # def send_confirmation_notification?
    #   true
    # end
  end
