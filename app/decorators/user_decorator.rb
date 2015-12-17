class UserDecorator < Draper::Decorator
  include GitHub

  delegate_all

  def avatar_url(size)
    "https://avatars.githubusercontent.com/u/#{uid}?v=3&size=#{size}"
  end

  def github_url
    github_user.html_url
  end

  def login
    github_user.login
  end

  def name
    github_user.name
  end

  private

  def github_user
    begin
      @github_user ||= GitHubUser.new(github_client, uid).user
    rescue GitHub::Forbidden
      @github_user ||= GitHubUser.new(application_github_client, uid).user
    end
  rescue GitHub::NotFound
    NullGitHubUser.new
  end
end
