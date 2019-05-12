class MarkovChain
  attr_accessor :memory

  def initialize
    @memory = {}
  end

  def learn(text)
    tokens = text.split(" ")
    bigrams = []
    (0..tokens.length-1).each do |i|
      bigrams << [tokens[i], tokens[i + 1]]
    end
    bigrams.each do |k, v|
      @memory[k] = [] if @memory[k].nil?
      @memory[k] << (v.nil? ? "" : v)
    end
  end

  def babble(amount)
    current_word = ''
    result = _next(current_word)
    amount.times do
      current_word = _next(current_word)
      result += " " + current_word
    end
    result
  end

  def tweet
    current_word = ''
    result = _next(current_word)
    while result.length <= 140
      current_word = _next(current_word)
      result += " " + current_word
    end
    result
  end


  def _next(current_state)
    (@memory[current_state] || @memory.keys).sample
  end

end

m = MarkovChain.new
tweets_json = JSON.parse(File.read('trump_tweets.json'))
tweets_text = tweets_json.map{|t| t["text"]}.join(" ")
m.learn(tweets_text)
m.tweet
