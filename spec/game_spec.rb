require 'spec_helper'

RSpec.describe Magic::Game do
  let(:p1) { Magic::Player.new }
  let(:p2) { Magic::Player.new }


  context "active player" do
    subject { Magic::Game.new(players: [p1, p2] )}
    it "first player in list is active player" do
      expect(subject.active_player).to eq(p1)
    end
  end

  context "state machine" do
    let(:p1_forest) { Magic::Cards::Forest.new(controller: p1, tapped: true) }

    subject { Magic::Game.new(players: [p1, p2]) }

    before do
      subject.battlefield.add(p1_forest)
    end

    it "transitions between each stage" do
      expect(subject.step).to be_untap
      subject.next_step
      expect(subject.step).to be_upkeep

      expect(p1).to receive(:draw!)
      subject.next_step
      expect(subject.step).to be_draw

      subject.next_step
      expect(subject.step).to be_first_main

      subject.next_step
      expect(subject.step).to be_beginning_of_combat

      subject.next_step
      expect(subject.step).to be_declare_attackers

      subject.next_step
      expect(subject.step).to be_end_of_combat

      subject.next_step
      expect(subject.step).to be_second_main

      subject.next_step
      expect(subject.step).to be_end_of_turn

      subject.next_step
      expect(subject.step).to be_cleanup

      subject.next_step
      expect(subject.step).to be_untap

      expect(subject.active_player).to eq(p2)
      expect(p1_forest).to be_untapped

      subject.next_step
      expect(subject.step).to be_upkeep

      expect(p2).to receive(:draw!)
      subject.next_step
    end
  end
end
