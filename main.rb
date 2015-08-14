#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

require_all File.join(ROOT, "src")

class Game < Chingu::Window
  def initialize
    super(1000, 800, false)

    push_game_state(Intro)
  end
end

class Intro < Chingu::GameState
  def initialize(options={})
    super
    self.input = { [:esc, :q] => :exit, :n => Level1, :c => Casual, :i => Instructions}
  end

  def setup
    Sample["open_theme.wav"].play
  end

  def draw
    Image["intro.png"].draw(0, 0, 0)
  end
end

class Instructions < Chingu::GameState
  def initialize(options={})
    super
    self.input = { [:esc, :q] => :exit, :m => Intro}
  end

  def setup
    #music here
  end

  def draw
    Image["instructions.png"].draw(0, 0, 0)
  end
end


class Lose < Chingu::GameState
  def initialize(options={})
    super
    self.input = { [:esc, :q] => :exit, :n => Level1}
  end

  def setup
    #music here
  end

  def draw
    Image["lose.png"].draw(0, 0, 0)
  end
end

class Win_Level < Chingu::GameState
  def initialize(options={})
    super
    self.input = { [:esc, :q] => :exit, :n => Level1, :l => Level2}
  end

  def setup
    #music here
  end

  def draw
    Image["win_1_2.png"].draw(0, 0, 0)
  end
end

class Win_Level2 < Chingu::GameState
  def initialize(options={})
    super
    self.input = { [:esc, :q] => :exit, :n => Level1, :l => Level3}
  end

  def setup
    #music here
  end

  def draw
    Image["win_1_2.png"].draw(0, 0, 0)
  end
end

class Win_Level3 < Chingu::GameState
  def initialize(options={})
    super
    self.input = { [:esc, :q] => :exit, :n => Level1}
  end

  def setup
    # music here
  end

  def draw
    Image["win.png"].draw(0, 0, 0)
  end
end

class Casual_End < Chingu::GameState
  def initialize(options={})
    super
    @title = Chingu::Text.create(:text=> "You have completed all Missions", :x=>150, :y=>300, :size=> 70)
    @instruct = Chingu::Text.create(:text=>"Q = Quit / C = Casual / M = Menu", :x=>300, :y=>500, :size=>40)
    self.input = { [:esc, :q] => :exit, :n => Casual, :m => Intro}
  end
end


Game.new.show
