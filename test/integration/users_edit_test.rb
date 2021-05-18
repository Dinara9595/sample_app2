require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:  "",
                                    email: "foo@invalid",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    # Issue first page request.
    get edit_user_path(@user)
    # User is not logged in, so requested URL is stored in session[:forwarding_url]

    log_in_as(@user)

    # User is now logged in and should be redirected to the URL stored in session[:forwarding_url].
    assert_redirected_to edit_user_path(@user)
    # sessions[:forwarding_url] should now be nil.

    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email

    # On subsequent login attempts, user should be redirected to their profile page
    # This block is the answer to the exercise.
    assert_nil session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to user_url(@user)
  end

end
