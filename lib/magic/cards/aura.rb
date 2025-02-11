module Magic
  module Cards
    class Aura < Card
      def single_target?
        true
      end

      def resolve!(controller, target:)
        permanent = super(controller)
        permanent.attach_to!(target)
      end

      def power_modification
        0
      end

      def toughness_modification
        0
      end

      def keyword_grants
        []
      end

      def type_grants
        []
      end

      def can_activate_ability?(_)
        true
      end
    end
  end
end
