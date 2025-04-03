require "test_helper"

class Bubble::EngageableTest < ActiveSupport::TestCase
  test "check the engagement status of a bubble" do
    assert bubbles(:logo).doing?
    assert_not bubbles(:shipping).doing?

    assert_not bubbles(:logo).considering?
    assert bubbles(:shipping).considering?
  end

  test "change the engagement" do
    assert_changes -> { bubbles(:shipping).reload.doing? }, to: true do
      bubbles(:shipping).engage
    end

    assert_changes -> { bubbles(:logo).reload.doing? }, to: false do
      bubbles(:logo).reconsider
    end
  end

  test "scopes" do
    assert_includes Bubble.doing, bubbles(:logo)
    assert_not_includes Bubble.doing, bubbles(:shipping)

    assert_includes Bubble.considering, bubbles(:shipping)
    assert_not_includes Bubble.considering, bubbles(:logo)
  end
end
