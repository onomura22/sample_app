class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "アカウントを認証してください"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "パスワードをリセットします"
  end
end