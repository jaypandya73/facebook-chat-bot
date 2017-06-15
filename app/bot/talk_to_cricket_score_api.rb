class TalkToCricketScoreApi

  API_URL = 'http://cricscore-api.appspot.com/csa'.freeze
  MATCH_SCORE_URL = 'http://cricapi.com/api/cricketScore'.freeze
  API_KEY = ENV['CRIC_API_KEY']
  ALLOWED_TEAMS = %w(India Sri\ Lanka West\ Indies South\ Africa Pakistan Australia England New\ Zealand).freeze

  def self.fetch_team_lists_with_unq_id
    teams = get
    return [] if teams.blank?
    teams
  end

  def self.fetch_selected_teams
    all_teams = fetch_team_lists_with_unq_id
    all_teams.select {|m| ALLOWED_TEAMS.include?(m['t1'] || m['t2'] )}.inject([]) {|arr,t| arr << [[t['t1'],t['t2']],t['id']]; arr }
  end

  def self.fetch_score_details(unique_id)
    post(unique_id)
  end

  def self.get
    HTTParty.get(API_URL)
  end

  def self.post(unique_id)
    parameters = { apikey: API_KEY, unique_id: unique_id }
    HTTParty.post( MATCH_SCORE_URL, query: parameters )
  end

  private_class_method :get

end
