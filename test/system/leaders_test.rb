require "application_system_test_case"

class LeadersTest < ApplicationSystemTestCase
  setup do
    @leader = leaders(:one)
  end

  test "visiting the index" do
    visit leaders_url
    assert_selector "h1", text: "Leaders"
  end

  test "creating a Leader" do
    visit leaders_url
    click_on "New Leader"

    fill_in "Father name", with: @leader.father_name
    fill_in "Mother name", with: @leader.mother_name
    fill_in "Rg", with: @leader.rg
    click_on "Create Leader"

    assert_text "Leader was successfully created"
    click_on "Back"
  end

  test "updating a Leader" do
    visit leaders_url
    click_on "Edit", match: :first

    fill_in "Father name", with: @leader.father_name
    fill_in "Mother name", with: @leader.mother_name
    fill_in "Rg", with: @leader.rg
    click_on "Update Leader"

    assert_text "Leader was successfully updated"
    click_on "Back"
  end

  test "destroying a Leader" do
    visit leaders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Leader was successfully destroyed"
  end
end
