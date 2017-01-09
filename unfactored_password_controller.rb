class PasswordsController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    return render plain: "Unauthorized request!" unless authorized_slack_request?(params[:token])

    if params[:text].blank?

      user = User.find_by(slack_id: params[:user_id])

      if user
        sign_ins = user.sign_ins.where('created_at > ?', Date.today - 7.days).where('created_at < ?', Date.today).where(day: [1,2,3,4,5]).where(ip: MAGIC_IPS).select(:day, :created_at).distinct(:day)
        password = user.new_password!
        user.log_out!
        if sign_ins.size < ENV['ATTENDANCE_THRESHOLD'].to_i
          render plain: "COME TO CLASS!"
        else
          render plain: "Use your email with this password: #{password}"
        end
      else
        render plain: "Please authorize the Slack API"
      end

    else
      authorized_user = User.find_by(slack_id: params[:user_id])
      return render plain: "You need to be an admin to do this! If you just want to retrieve your own password just type `/get_password` in Slack without any email addresses" unless authorized_user.superadmin? || authorized_user.mentor? || authorized_user.admin?

      user = User.find_by(email: params[:text]) #verify

      if user
        password = user.new_password!
        user.log_out!
        render plain: "Ask the user to use their email and log in with this password: #{password}"
      else
        render plain: "The user has not authorized the Slack API"
      end

    end
  end
end