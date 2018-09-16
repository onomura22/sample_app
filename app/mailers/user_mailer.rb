class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user # ユーザーを含むインスタンス変数を作成してビューで使えるようにする
    mail to: user.email, subject: "Account activation" # メールの件名を設定
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end