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
    @title = Chingu::Text.create(:text=>"Starchaser I", :x=>350, :y=>300, :size=>70)
    @instruct = Chingu::Text.create(:text=>"Q = Quit / I = Instructions", :x=>325, :y=>500, :size=>40)
    @game_mode = Chingu::Text.create(:text=>"N = New Game / C = Casual Mode", :x=>250, :y=>550, :size=>40)
    self.input = { [:esc, :q] => :exit, :n => Level1, :c => Casual, :i => Instructions}
  end
end

class Instructions < Chingu::GameState
  def initialize(options={})
    super
    @title = Chingu::Text.create(:text=>"Instructions", :x=>350, :y=>100, :size=>70)
    @instruct = Chingu::Text.create(:text=>"Left Arrow / 'a' = Turn Left", :x=>350, :y=>300, :size=>30)
    @instruct = Chingu::Text.create(:text=>"Right Arrow / 'd' = Turn Right", :x=>350, :y=>350, :size=>30)
    @instruct = Chingu::Text.create(:text=>"Up Arrow / 'w' = Accelerate", :x=>350, :y=>400, :size=>30)
    @instruct = Chingu::Text.create(:text=>"Down Arrow / 's' = Deccelerate", :x=>350, :y=>450, :size=>30)
    @instruct = Chingu::Text.create(:text=>"Space / Return = Fire Guns", :x=>350, :y=>500, :size=>30)
    @instruct = Chingu::Text.create(:text=>"The objective is to obtain 1000 points by cature of stars or shooting meteors.", :x=>150, :y=>600, :size=>30)
    @instruct = Chingu::Text.create(:text=>"There are 3 Mission Levels and one Casual Level.  Have fun", :x=>150, :y=>650, :size=>30)
    @instruct = Chingu::Text.create(:text=>"Press M to go back to the Menu", :x=>350, :y=>750, :size=>30)

    self.input = { [:esc, :q] => :exit, :m => Intro}
  end
end


class Lose < Chingu::GameState
  def initialize(options={})
    super
    @title = Chingu::Text.create(:text=>"You failed the Mission", :x=>250, :y=>300, :size=>70)
    @instruct = Chingu::Text.create(:text=>"Q to Quit or N for New Game", :x=>300, :y=>500, :size=>40)
    self.input = { [:esc, :q] => :exit, :n => Level1}
  end
end

class Win_Level < Chingu::GameState
  def initialize(options={})
    super
    @title = Chingu::Text.create(:text=>"You have complete the Mission 1", :x=>150, :y=>300, :size=>70)
    @instruct = Chingu::Text.create(:text=>"Q to Quit or N for Next Level", :x=>300, :y=>500, :size=>40)
    self.input = { [:esc, :q] => :exit, :n => Level2}
#####    Sound["open_theme.wav"].play
  end
end

class Win_Level2 < Chingu::GameState
  def initialize(options={})
    super
    @title = Chingu::Text.create(:text=> "You have completed Mission 2", :x=>150, :y=>300, :size=> 70)
    @instruct = Chingu::Text.create(:text=>"Q to Quit or N for Next Level", :x=>300, :y=>500, :size=>40)
    self.input = { [:esc, :q] => :exit, :n => Level3}
  end
end

class Win_Level3 < Chingu::GameState
  def initialize(options={})
    super
    @title = Chingu::Text.create(:text=> "You have completed all Missions", :x=>150, :y=>300, :size=> 70)
    @instruct = Chingu::Text.create(:text=>"Q to Quit or N for New Game", :x=>300, :y=>500, :size=>40)
    self.input = { [:esc, :q] => :exit, :n => Level1}
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
