require "application_system_test_case"

class PaymentTestsTest < ApplicationSystemTestCase
  setup do
    @payment_test = payment_tests(:one)
  end

  test "visiting the index" do
    visit payment_tests_url
    assert_selector "h1", text: "Payment Tests"
  end

  test "creating a Payment test" do
    visit payment_tests_url
    click_on "New Payment Test"

    click_on "Create Payment test"

    assert_text "Payment test was successfully created"
    click_on "Back"
  end

  test "updating a Payment test" do
    visit payment_tests_url
    click_on "Edit", match: :first

    click_on "Update Payment test"

    assert_text "Payment test was successfully updated"
    click_on "Back"
  end

  test "destroying a Payment test" do
    visit payment_tests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Payment test was successfully destroyed"
  end
end
