require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit games_url
  #
  #   assert_selector "h1", text: "Game"
  # end

  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "Filling the input text with random words" do
    visit new_url

    fill_in "answer", with: "bhup"
    click_on "Submit"
    assert_text "Sorry but BHUP can't be built out of"
  end

  test "Filling the input text with one word consonant" do
    visit new_url

    fill_in "answer", with: "h"
    click_on "Submit"
    assert_text "Sorry but L is not a valid word."
  end
end
