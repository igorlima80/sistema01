require 'test_helper'

class PaymentTestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_test = payment_tests(:one)
  end

  test "should get index" do
    get payment_tests_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_test_url
    assert_response :success
  end

  test "should create payment_test" do
    assert_difference('PaymentTest.count') do
      post payment_tests_url, params: { payment_test: {  } }
    end

    assert_redirected_to payment_test_url(PaymentTest.last)
  end

  test "should show payment_test" do
    get payment_test_url(@payment_test)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_test_url(@payment_test)
    assert_response :success
  end

  test "should update payment_test" do
    patch payment_test_url(@payment_test), params: { payment_test: {  } }
    assert_redirected_to payment_test_url(@payment_test)
  end

  test "should destroy payment_test" do
    assert_difference('PaymentTest.count', -1) do
      delete payment_test_url(@payment_test)
    end

    assert_redirected_to payment_tests_url
  end
end
