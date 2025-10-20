# frozen_string_literal: true

require "spec_helper"
require "mastermind/game"

# prevent printing in terminal during tests
RSpec.configure do |config|
  config.around(:each) do |example|
    original_stdout = $stdout
    $stdout = StringIO.new
    example.run
    $stdout = original_stdout
  end
end

RSpec.describe Mastermind::Game do
  subject(:game) { described_class.new }

  describe "#initialize" do
    it "sets up the game code with correct length" do
      expect(game.instance_variable_get(:@secret).size).to eq(Mastermind::Game::CODE_LENGTH)
    end

    it "sets up empty game data" do
      expect(game.instance_variable_get(:@game_data)).to eq([])
    end
  end

  describe "#generate_secret" do
    it "generates a code of allowed colors" do
      code = game.send(:generate_secret)
      expect(code.size).to eq(Mastermind::Game::CODE_LENGTH)
      expect(code).to all(satisfy { |peg| Mastermind::Game::ALLOWED_COLORS.include?(peg) })
    end
  end

  describe "#guess" do
    context "when user_code matches secret exactly" do
      let(:user_code) { %i[red blue yellow green] }
      let(:secret) { %i[red blue yellow green] }

      before do
        game.instance_variable_set(:@secret, secret)
        allow_any_instance_of(Mastermind::SelectCode).to receive(:code).and_return(user_code)
      end

      it "adds correct feedback for exact match" do
        expect { game.send(:guess) }.to change { game.instance_variable_get(:@game_data).size }.by(1)
        feedback = game.instance_variable_get(:@game_data).last[:feedback]
        expect(feedback).to eq(%i[red red red red])
      end
    end

    context "when user_code has some correct and some misplaced pegs" do
      let(:user_code) { %i[red green blue yellow] }
      let(:secret) { %i[red blue yellow green] }

      before do
        game.instance_variable_set(:@secret, secret)
        allow_any_instance_of(Mastermind::SelectCode).to receive(:code).and_return(user_code)
      end

      it "adds feedback for correct and misplaced pegs" do
        game.send(:guess)
        feedback = game.instance_variable_get(:@game_data).last[:feedback]
        expect(feedback).to include(:red)
        expect(feedback).to include(:white)
      end
    end

    context "when user_code has no matching pegs" do
      let(:user_code) { %i[magenta magenta magenta magenta] }
      let(:secret) { %i[red blue yellow green] }

      before do
        game.instance_variable_set(:@secret, secret)
        allow_any_instance_of(Mastermind::SelectCode).to receive(:code).and_return(user_code)
      end

      it "adds no feedback for wrong guess" do
        game.send(:guess)
        feedback = game.instance_variable_get(:@game_data).last[:feedback]
        expect(feedback).to be_empty
      end
    end

    context "when user_code and secret have duplicate colors" do
      let(:user_code) { %i[red red blue blue] }
      let(:secret) { %i[red blue red blue] }

      before do
        game.instance_variable_set(:@secret, secret)
        allow_any_instance_of(Mastermind::SelectCode).to receive(:code).and_return(user_code)
      end

      it "handles duplicate colors correctly in feedback" do
        game.send(:guess)
        feedback = game.instance_variable_get(:@game_data).last[:feedback]
        expect(feedback.count(:red)).to eq(2)
        expect(feedback.count(:white)).to eq(2)
      end
    end

    context "when user_code and secret have duplicate colors v2" do
      let(:user_code) { %i[red red red blue] }
      let(:secret) { %i[red blue blue blue] }

      before do
        game.instance_variable_set(:@secret, secret)
        allow_any_instance_of(Mastermind::SelectCode).to receive(:code).and_return(user_code)
      end

      it "handles duplicate colors correctly in feedback" do
        game.send(:guess)
        feedback = game.instance_variable_get(:@game_data).last[:feedback]
        expect(feedback.count(:red)).to eq(2)
        expect(feedback.count(:white)).to eq(0)
      end
    end
  end

  describe "#finished?" do
    it "returns true if player wins" do
      game.instance_variable_set(:@secret, %i[red blue yellow green])
      game.instance_variable_set(:@game_data, [{ code: %i[red blue yellow green], feedback: %i[red red red red] }])
      expect(game.send(:finished?)).to be true
    end

    it "returns true if player loses after max rounds" do
      game.instance_variable_set(:@secret, %i[red blue yellow green])
      game.instance_variable_set(:@game_data, Array.new(Mastermind::Game::MAX_ROUNDS) do
        { code: %i[blue blue blue blue], feedback: %i[white white white white] }
      end)
      expect(game.send(:finished?)).to be true
    end

    it "returns false if game is not finished" do
      game.instance_variable_set(:@game_data, [])
      expect(game.send(:finished?)).to be false
    end
  end
end
