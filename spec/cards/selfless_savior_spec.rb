require 'spec_helper'

RSpec.describe Magic::Cards::SelflessSavior do
  include_context "two player game"

  subject { ResolvePermanent("Selfless Savior", owner: p1) }
  let(:wood_elves) { ResolvePermanent("Wood Elves", owner: p1) }

  context "activated ability" do
    def ability
      subject.activated_abilities.first
    end

    it "sacrifices selfless, applies indestructible to elves until eot" do
      action = Magic::Actions::ActivateAbility.new(player: p1, permanent: subject, ability: subject.activated_abilities.first)
        .pay(p1, :sacrifice, subject)
        .targeting(wood_elves)
      game.take_action(action)
      expect(wood_elves).to be_indestructible
      expect(wood_elves.keyword_grants.first.until_eot?).to eq(true)
    end
  end
end
