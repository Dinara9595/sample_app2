require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
  #посетить страницу профиля
  get user_path(@user)
  assert_template 'users/show'
  #проверить заголовок
  assert_select 'title', full_title(@user.name)
  #проверить имя пользователя
  assert_select 'h1', text: @user.name
  #проверить граватар
  assert_select 'h1>img.gravatar'
  #проверить количество микросообщений
  assert_match @user.microposts.count.to_s, response.body
  #проверить пагинацию
  assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end