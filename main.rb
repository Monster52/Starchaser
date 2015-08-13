#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
include Gosu
include Chingu

class Game < Chingu::Window
  def initialize
    super(1000, 800, false)

    push_game_state(Intro)
  end
end

class Player < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection, :effect, :velocity
  def initialize(options = {})
    super(options)
    @image = Image["ship_1.png"]
    self.max_velocity = 15 

    self.input = { [:holding_a, :holding_left]  => :turn_left,
                      [:holding_d, :holding_right] => :turn_right,
                      [:holding_w, :holding_up]    => :accelerate,
                      [:holding_s, :holding_down]  => :deccelerate,
                      [:space, :return] => :fire
                    }
  end

  def accelerate
    self.velocity_x = Gosu::offset_x(self.angle, 0.5)*self.max_velocity_x
    self.velocity_y = Gosu::offset_y(self.angle, 0.5)*self.max_velocity_y
  end

  def deccelerate
    self.velocity_x = Gosu::offset_x(self.angle, -0.5)*self.max_velocity_x
    self.velocity_y = Gosu::offset_y(self.angle, -0.5)*self.max_velocity_y
  end

  def turn_right
    # The same can be achieved without trait 'effect' as: self.angle += 4.5
    rotate(5.0)
  end

  def turn_left
    # The same can be achieved without trait 'effect' as: self.angle -= 4.5
    rotate(-5.0)
  end

  def update
    self.velocity_x *= 0.95
    self.velocity_y *= 0.95

    @x %= $window.width #wrap around the screen
    @y %= $window.height
  end

  def fire
  # Bullet.create(:x => @x + Gosu::offset_x(@angle+90, -25), :y => @y + Gosu::offset_y(@angle+90, -25), :angle => @angle)
    Bullet.create(:x => @x, :y => @y, :angle => @angle)
  # Bullet.create(:x => @x + Gosu::offset_x(@angle+90, 25), :y => @y + Gosu::offset_y(@angle+90, 25), :angle => @angle)
    Sound["Laser_08.wav"].play
  end

  
end

class Bullet < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection
  attr_reader :radius

  def initialize(options={})
    super(options.merge(:image => Image["goldCoin1.png"]))
    @speed = 15 
    @radius = 10 
    @velocity_x = Gosu::offset_x(@angle, @speed)
    @velocity_y = Gosu::offset_y(@angle, @speed)
  end

  # Move bullet forward
  def update
    @y += @velocity_y
    @x += @velocity_x
  end
end

class Meteor < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection, :effect, :velocity, :timer 
  attr_reader :radius

  def initialize(options={})
    super
    @image = Image["meteor.png"]  
    @radius = 10
    self.zorder = 100
    self.x =rand * 1000
    self.y =rand * 800 
    cache_bounding_circle
  end

  def update
    @image


    @x %= $window.width
    @y %= $window.height
  end

end

class Star < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection
  attr_reader :radius

  def initialize(options={})
    super
    @image = Image["goldCoin1.png"]  
    @radius = 10 
    self.zorder = 100
    self.x =rand * 1000
    self.y =rand * 800 
    cache_bounding_circle
  end

  def update
    @image
  end

end


class Level < Chingu::GameState
  trait :timer

  def initialize(options={})
    super
    @player = Player.create(:x => 500, :y => 400)

    @score = 0
    @life = 3
    self.input = { [:q, :escape] => :exit }
  end

  def setup
    Meteor.destroy_all
    Star.destroy_all
    Bullet.destroy_all

    @score = 0
  end

  def draw
    Image["space_bg.png"].draw(0, 0, 0)
    super
  end

  def update
    super
    
    if Meteor.all.size < 5
      Meteor.create(:x=>rand * 1000, :y=>rand * 800, :velocity_x=>1, :velocity_y=>1)
    end


    if Star.all.size < 35
      Star.create
    end
    
    @player.each_bounding_circle_collision(Meteor) do |player, meteor|
      meteor.destroy
      @life -= 1 
      @score -= 50
      Sound["Laser_00.wav"].play
    end

    @player.each_bounding_circle_collision(Star) do |player, star|
      star.destroy
      @score += 10
      Sound["UI_Synth_00.wav"].play
    end

    Bullet.each_bounding_circle_collision(Meteor) do |bullet, meteor|
      meteor.destroy
      bullet.destroy
      @score += 10
      Sound["Laser_00.wav"].play
    end

    if @life == 0
      push_game_state(Lose) 
    end

    if @score == 500
      push_game_state(Win_Level)
    end

    Bullet.destroy_if { |bullet| bullet.outside_window? }
    $window.caption = "FPS: #{$window.fps} - Life: #{@life} - Score: #{@score}"
  end
end

class Level2 < Chingu::GameState
  trait :timer

  def initialize(options={})
    super
    @player = Player.create(:x => 500, :y => 400)

    @score = 0
    @life = 3
    self.input = { [:q, :escape] => :exit }
  end

  def setup
    Meteor.destroy_all
    Star.destroy_all
    Bullet.destroy_all

    @score = 0
  end

  def draw
    Image["space_bg.png"].draw(0, 0, 0)
    super
  end

  def update
    super
    
    if Meteor.all.size < 10 
      Meteor.create(:x=>rand * 1000, :y=>rand * 800, :velocity_x=>3, :velocity_y=>1)
    end


    if Star.all.size < 35
      Star.create
    end
    
    @player.each_bounding_circle_collision(Meteor) do |player, meteor|
      meteor.destroy
      @life -= 1 
      @score -= 50
      Sound["Laser_00.wav"].play
    end

    @player.each_bounding_circle_collision(Star) do |player, star|
      star.destroy
      @score += 10
      Sound["UI_Synth_00.wav"].play
    end

    Bullet.each_bounding_circle_collision(Meteor) do |bullet, meteor|
      meteor.destroy
      bullet.destroy
      @score += 10
      Sound["Laser_00.wav"].play
    end

    if @life == 0
      push_game_state(Lose) 
    end

    if @score == 500
      push_game_state(Win_Level2)
    end

    Bullet.destroy_if { |bullet| bullet.outside_window? }
    $window.caption = "FPS: #{$window.fps} - Life: #{@life} - Score: #{@score}"
  end
end

class Level3 < Chingu::GameState
  trait :timer

  def initialize(options={})
    super
    @player = Player.create(:x => 500, :y => 400)

    @score = 0
    @life = 3
    self.input = { [:q, :escape] => :exit }
  end

  def setup
    Meteor.destroy_all
    Star.destroy_all
    Bullet.destroy_all

    @score = 0
  end

  def draw
    Image["space_bg.png"].draw(0, 0, 0)
    super
  end

  def update
    super
    
    if Meteor.all.size < 10 
      Meteor.create(:x=>rand * 1000, :y=>rand * 800, :velocity_x=>3, :velocity_y=>5)
    end


    if Star.all.size < 35
      Star.create
    end
    
    @player.each_bounding_circle_collision(Meteor) do |player, meteor|
      meteor.destroy
      @life -= 1 
      @score -= 50
      Sound["Laser_00.wav"].play
    end

    @player.each_bounding_circle_collision(Star) do |player, star|
      star.destroy
      @score += 10
      Sound["UI_Synth_00.wav"].play
    end

    Bullet.each_bounding_circle_collision(Meteor) do |bullet, meteor|
      meteor.destroy
      bullet.destroy
      @score += 10
      Sound["Laser_00.wav"].play
    end

    if @life == 0
      push_game_state(Lose) 
    end

    if @score == 500
      push_game_state(Win_Level3)
    end

    Bullet.destroy_if { |bullet| bullet.outside_window? }
    $window.caption = "FPS: #{$window.fps} - Life: #{@life} - Score: #{@score}"
  end
end


class Intro < Chingu::GameState
  def initialize(options={})
    super
    @title = Chingu::Text.create(:text=>"Starchaser I", :x=>350, :y=>300, :size=>70)
    @instruct = Chingu::Text.create(:text=>"Q to Quit or N for New Game", :x=>300, :y=>500, :size=>40)
    self.input = { [:esc, :q] => :exit, :n => Level}
  end
end

class Lose < Chingu::GameState
  def initialize(options={})
    super
    @title = Chingu::Text.create(:text=>"You failed the Mission", :x=>250, :y=>300, :size=>70)
    @instruct = Chingu::Text.create(:text=>"Q to Quit or N for New Game", :x=>300, :y=>500, :size=>40)
    self.input = { [:esc, :q] => :exit, :n => Level}
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
    self.input = { [:esc, :q] => :exit, :n => Level}
  end
end


Game.new.show
