module Admin::TransactionsHelper
  def table_headers
    %w[ID Name UserID Type Asset Amount CreatedAt Approve Reject]
  end
end
