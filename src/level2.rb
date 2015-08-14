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
      Meteor.create(:x=>rand * 1000, :y=>rand * 800, :velocity_x=>-3, :velocity_y=>1)
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

