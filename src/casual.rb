class Casual < Chingu::GameState
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

    Song["Blind_Shift.ogg"].play
  end

  def draw
    Image["bg_rw.png"].draw(0, 0, 0)
    super
  end

  def update
    super
    
    if Meteor.all.size < 5
      Meteor.create
    end


    if Star.all.size < 50
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
      push_game_state(Casual_End) 
    end

    Bullet.destroy_if { |bullet| bullet.outside_window? }
    $window.caption = "FPS: #{$window.fps} - Life: #{@life} - Score: #{@score}"
  end
end


