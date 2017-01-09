class PasswordsController < ApplicationController
  protect_from_forgery with: :null_session

  def new
    return render plain: "Unauthorized request!" unless authorized_slack_request?(secure_token: params[:token])

    return render plain: "Please authorize the Slack API from your Learning Portal account first." unless current_slack_user.present?

    if retrieving_password_for_others?
      retrieve_password_for_others

    else
      retrieve_password

    end
  end

  private

  def retrieving_password_for_others?
    the_other_users_email.present?
  end

  def retrieve_password_for_others
    return render plain: "You need to be an authorized admin to retrieve password on behalf of another user! If you just want to retrieve your own password just type `/get_password` in Slack without any email addresses." unless can_retrieve_password_for_others?(user: current_slack_user)

    if the_other_user = User.find_by(email: the_other_users_email)
      new_password = reset_password(user: the_other_user)
      render plain: "Ask the user to use their email and log in with this password: `#{new_password}`."

    else
      render plain: "The are no records of any user with the email: #{the_other_users_email} in NEXT ACademy's learning portal. Notify an admin if you believe this is an error."

    end
  end

  def retrieve_password
    if can_retrieve_password?(user: current_slack_user)
      new_password = reset_password(user: current_slack_user)
      render plain: "Use your email with this password: `#{new_password}`."

    else
      render plain: "COME TO CLASS!"

    end
  end

  def can_retrieve_password_for_others?(user:)
    user.superadmin? || user.mentor? || user.admin?
  end

  def can_retrieve_password?(user:)
    return true if user.superadmin? || user.mentor? || user.admin? #authorized users can retrieve password regardless of attendance

    return true unless high_absenteeism?(student: user)

    false
  end

  def high_absenteeism?(student:)
    attendance(user: student) < ENV['ATTENDANCE_THRESHOLD'].to_i
  end

  def the_other_users_email
    params[:text].strip
  end

  def current_slack_user
    @current_slack_user ||= User.find_by(slack_id: params[:user_id])
  end

  def attendance(user:)
    user
      .sign_ins
      .where('created_at > ?', Time.zone.now.to_date - 7.days)
      .where('created_at < ?', Time.zone.now.to_date)
      .where(day: [1,2,3,4,5])
      .where(ip: MAGIC_IPS)
      .select(:day, :created_at)
      .distinct(:day)
      .size
  end

  def reset_password(user:)
    password = user.new_password!
    user.log_out!
    password
  end
end