require "test_helper"

class Users::StocksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_stocks_index_url
    assert_response :success
  end
end
