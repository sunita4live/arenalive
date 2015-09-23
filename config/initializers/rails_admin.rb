RailsAdmin.config do |config|

  ### Popular gems integration
  #config.main_app_name = ["SpotMyArena"]
  config.main_app_name = Proc.new { |controller| [ "SpotMyArena", "Admin - #{controller.params[:action].try(:titleize)}" ] }
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  #config.attr_accessible_role { _current_user.role.to_sym }
  ## == Cancan ==
  # config.authorize_with :cancan
  config.authorize_with :cancan
  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
