class RevenueSerializer
  class << self
    def revenue_by_date(revenue)
      { data: { id: nil,
                type: 'revenue',
                attributes: {
                  revenue: revenue
                } } }
    end

    def unshipped_orders(orders)
      { data: orders.map do |order|
        { id: order.id.to_s,
          type: 'unshipped_order',
          attributes: {
            potential_revenue: order.potential_revenue
          } }
      end }
    end

    def weekly_revenue(weekly_totals)
      { data: weekly_totals.map do |weekly_total|
        { id: nil,
          type: 'weekly_revenue',
          attributes: {
            week: weekly_total.week.to_date.to_s,
            revenue: weekly_total.revenue
          } }
      end }
    end
  end
end
