class BowlingGame

  attr_accessor :rounds

  def initialize
    @rounds = []
  end  

  def play
    rounds_count = @rounds.size
    if rounds_count >= 0 && rounds_count < 10
      round,first_score = [], hit #TODO 第一次投球
      round << first_score
      #TODO 第二次投球,如果第一次为全中，则不用投第二次
      round << (first_score == 10 ? 0 : hit(10 - first_score))
      @rounds << round
    end
    add_round if @rounds.size == 10
    @rounds
  end  

  def scores
    total_score = 0
    @rounds.each_with_index do |round, index|
      next if index >= 9 #TODO 第10局另算

      if is_strike? round #全中
        total_score += strike_round_score(index)
        print_game_info(index, "strike",  round, total_score)

      elsif is_spare? round #补中
        total_score += (round.sum + find_round(index + 1)[0])
        print_game_info(index, "spare",  round, total_score)

      else is_miss? round
        total_score += round.sum
        print_game_info(index, "miss",  round, total_score)
      end
    end

    #TODO 如果第10局是全中或补中,则有加投的球
    tenth_round,additional_round = find_round(9), find_round(10)
    if additional_round != nil
      total_score += (tenth_round.sum + additional_round.sum)

      if is_strike? tenth_round
        print_game_info(9, "strike",  tenth_round, total_score)
      else
        print_game_info(9, "spare",  tenth_round, total_score, additional_round)
      end

    else
      total_score += tenth_round.sum
      print_game_info(9, "miss",  tenth_round, total_score)
    end
    puts "--------总得分为：#{total_score}-----"
    total_score
  end


  private

  def print_game_info index, status, round, score, additional_round = []
    index += 1
    round = round.map{|r| r == 0 ? "-" : r}
    #additional_round.map{|r| r == 0 ? "-" : r}
    round_status = case status
      when "miss"
        "失球|#{round.join('|')}|"
      when "spare"
        "补中|#{round[0]}|/|#{additional_round.empty? ?  '' : additional_round[0].to_s + '|'}"
      when "strike"
        "全中|x|#{index == 10 ? round.join('|') : ' '}|"
      end
    puts "--------第#{index}局".concat(round_status).concat(",得分：#{score}-----")

  end

  def strike_round_score index
    next_round, second_round = find_round(index + 1),find_round(index + 2)

    if is_strike?(next_round) && second_round == nil #连续两轮全中，且为最后一轮
      last_round[0] + 20 #两轮全中的加上附加的那轮
    elsif is_strike?(next_round) && is_strike?(second_round) #连续三次全中
      30
    elsif is_strike?(next_round) #连续两轮全中
      second_round[0] + 20  #连续两轮全中再加上下一轮的第一次
    else
      next_round.sum + 10 #一次全中加上下一轮的二次之和
    end
  end

  def add_round
    if is_strike? last_round #TODO 如果第10局全中,则继续投两局
      @rounds << [hit, hit]
    elsif is_spare? last_round #TODO 如果为补中,则继续投完一局
      @rounds << [hit, 0]
    end
  end

  def find_round index
    @rounds[index]
  end
  
  def last_round
    @rounds.last
  end

  def hit maximum = 10
    rand(0..maximum)
  end

  #失球
  def is_miss? current_round
    current_round.sum >= 0 && current_round.sum < 10
  end

  #补中
  def is_spare? current_round
    current_round.first != 10 && current_round.sum == 10
  end

  #全中
  def is_strike? current_round
    current_round.first == 10
  end

end  

def start
  xh_bowling_game = BowlingGame.new
  xm_bowling_game = BowlingGame.new
  10.times do
    xh_bowling_game.play
    xm_bowling_game.play
  end
  puts "小红的得分情况如下:"
  xh_bowling_game.scores
  puts "**********************************************"
  puts "小明的得分情况如下:"
  xm_bowling_game.scores
end

start
