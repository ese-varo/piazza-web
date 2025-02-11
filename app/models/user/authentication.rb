module User::Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    validates :password,
      on: [:create, :password_change],
      presence: true,
      length: { minimum: 8 }
    validate :password_changed, on: :password_change

    has_many :app_sessions
  end

  class_methods do
    def create_app_session(email:, password:)
      user = User.authenticate_by(email: email, password: password)
      user.app_sessions.create if user.present?
    end
  end

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private

    def password_changed
      if password.present? && BCrypt::Password.new(password_digest_was).is_password?(password)
        errors.add(:password, :same_as_current)
      end
    end
end
