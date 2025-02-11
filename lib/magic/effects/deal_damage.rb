module Magic
  module Effects
    class DealDamage < TargetedEffect
      attr_reader :damage

      def initialize(damage:, **args)
        @damage = damage
        super(**args)
      end

      def resolve(target)
        target.take_damage(source: source, damage: damage)
        super
      end
    end
  end
end
