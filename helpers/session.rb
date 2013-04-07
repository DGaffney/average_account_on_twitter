module SessionHelper
  def current_user
    Account.find(session[:account_id])
  end
end