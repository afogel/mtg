module Magic
  class Effect
    attr_reader :targets
    def initialize(targets: 1)
      @targets = targets
    end

    def no_choice?
      false
    end

    def multiple_targets?
      targets > 1
    end

    def requires_choices?
      false
    end
  end
end
