module Magic
  class Player
    class CastAction
      attr_reader :game, :player, :card, :payment

      def initialize(game:, player:, card:)
        @game = game
        @player = player
        @card = card
        @payment = Hash.new(0)
        @payment[:generic] = {}
      end

      def pay(mana)
        @payment = mana
        @payment[:generic] ||= {}
      end

      def final_cost
        apply_cost_reductions(card)
      end

      def can_cast?
        return false if card.land? && player.can_play_lands?
        return false unless card.zone.hand?
        cost = final_cost
        return true if cost.values.all?(&:zero?)

        pool = player.mana_pool.dup
        color_costs = cost.slice(*Mana::COLORS)

        deduct_from_pool(pool, color_costs)

        generic_mana_payable = pool.values.sum >= cost[:generic]

        generic_mana_payable && (pool.values.all? { |v| v.zero? || v.positive? })
      end

      def cast!
        cost = final_cost
        pool = player.mana_pool.dup
        deduct_from_pool(pool, payment[:generic])

        payment[:generic].each do |_, amount|
          cost[:generic] -= amount
        end

        color_payment = payment.slice(*Mana::COLORS)
        deduct_from_pool(pool, color_payment)

        color_payment.each do |color, amount|
          cost[color] -= amount
        end

        if cost.values.all?(&:zero?)
          player.pay_mana(payment.slice(*Mana::COLORS))
          player.pay_mana(payment[:generic])
          card.cast!
          player.played_a_land! if card.land?
        else
          raise "Cost has not been fully paid."
        end
      end

      private

      def apply_cost_reductions(card)
        base_cost = card.cost

        reduce_mana_cost_abilities = game.battlefield.static_abilities
          .applies_to(card)
          .select { |ability| ability.is_a?(Abilities::Static::ReduceManaCost) }

        reduce_mana_cost_abilities.each_with_object(base_cost) { |ability, cost| ability.apply(cost) }
      end

      def deduct_from_pool(pool, mana)
        mana.each do |color, amount|
          pool[color] -= amount
        end
      end
    end
  end
end
