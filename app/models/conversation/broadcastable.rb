module Conversation::Broadcastable
  extend ActiveSupport::Concern

  def broadcast_state_change
    broadcast_replace_to user, :conversation,
      target: "conversation-thinking-indicator",
      partial: "conversations/composer/thinking_indicator"
  end
end
