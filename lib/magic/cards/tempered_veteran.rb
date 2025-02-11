module Magic
  module Cards
    TemperedVeteran = Creature("Tempered Veteran") do
      creature_type "Human Knight"
      cost generic: 1, white: 1
    end

    class TemperedVeteran < Creature
      class ActivatedAbility < Magic::ActivatedAbility
        def initialize(source:)
          @costs = [Costs::Mana.new(white: 1), Costs::Tap.new(source)]

          super
        end

        def target_choices
          game.battlefield.creatures.select { _1.counters.of_type(Counters::Plus1Plus1).any? }
        end

        def single_target?
          true
        end

        def resolve!(target:)
          effect = Effects::AddCounter.new(
            choices: target_choices,
            source: source,
            counter_type: Counters::Plus1Plus1,
            targets: target,
          )
          game.add_effect(effect)
        end
      end

      class ActivatedAbility2 < Magic::ActivatedAbility
        def initialize(source:)
          @costs = [Costs::Mana.new(white: 2, generic: 4), Costs::Tap.new(source)]

          super
        end

        def target_choices
          game.battlefield.creatures
        end

        def single_target?
          true
        end

        def resolve!(target:)
          effect = Effects::AddCounter.new(
            choices: target_choices,
            source: source,
            counter_type: Counters::Plus1Plus1,
            targets: target,
          )
          game.add_effect(effect)
        end
      end

      def activated_abilities = [ActivatedAbility, ActivatedAbility2]
    end
  end
end
