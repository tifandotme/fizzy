class Current < ActiveSupport::CurrentAttributes
  attribute :session, :membership, :account
  attribute :http_method, :request_id, :user_agent, :ip_address, :referrer

  delegate :identity, to: :session, allow_nil: true
  delegate :user, to: :membership, allow_nil: true

  def session=(value)
    super(value)

    if value.present? && Current.account.present?
      self.membership = identity.memberships.find_by(tenant: Current.account.external_account_id)
    end
  end
end
