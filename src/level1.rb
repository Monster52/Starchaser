class Level1 < Chingu::GameState
  trait :timer

  def initialize(options={})
    super
    @player = Player.create(:x => 500, :y => 400)
    @life = 3
    self.input = { [:q, :escape] => :exit }
  end

  def setup
    $window.score = 0
    Meteor.destroy_all
    Star.destroy_all
    Bullet.destroy_all
    Song["Blind_Shift.ogg"].play

    after(20000) {PowerUp.create(:x => rand * 1000, :y => rand * 800, :type => 1)}
    after(35000) {PowerUp.create(:x => rand * 1000, :y => rand * 800, :type => 2)}
    after(60000) {PowerUp.create(:x => rand * 1000, :y => rand * 800, :type => 3)}
    after(120000) {push_game_state(Win_Level)}
  end

  def draw
    Image["bg_rw.png"].draw(0, 0, 0)
    super
  end

  def update
    super
    
    if rand(100) < 2 && Meteor.all.size < 5
      Meteor.create(:x=>rand * 1000, :y=> 0, :velocity_x=>1, :velocity_y=>1)
    end

    if Star.all.size < 35
      Star.create
    end
    
    @player.each_bounding_circle_collision(Meteor) do |player, meteor|
      meteor.destroy
      player.die
      @life -= 1 
      $window.score -= 50
      Sound["Laser_00.wav"].play(0.4)
      sleep 1
    end

    @player.each_bounding_circle_collision(Star) do |player, star|
      star.destroy
      $window.score += 10
      Sound["UI_Synth_00.wav"].play(0.6)
    end

    @player.each_bounding_circle_collision(PowerUp) do |player, powerup|
      $window.firepower = powerup.type
      powerup.destroy
      Sound["powerup.wav"].play
    end

    Bullet.each_bounding_circle_collision(Meteor) do |bullet, meteor|
      meteor.destroy
      bullet.destroy
      $window.score += 10
      Sound["Laser_00.wav"].play(0.8)
    end

    if @life == 0
      push_game_state(Lose) 
    end

    Bullet.destroy_if { |bullet| bullet.outside_window? }
    $window.caption = "FPS: #{$window.fps} - Life: #{@life} - Score: #{$window.score}"
  end
end

