class SimiCheckWebService
  require 'rest-client'

  @api_key = '34fdeffbe203432383df873a0306b005595ff4c6f040447a9ec52cf7bee0af2a4b6ef22fdb414fe09dba556a50085505388f8b837afc4364b226d058a2dc84bc'
  @@base_uri = 'https://www.simicheck.com/api'

  ############################################
  # Comparison Operations
  ############################################

  # Lists all comparisons for the SimiCheck account
  def self.get_all_comparisons
    full_url = @@base_uri + '/comparisons'
    puts full_url
    response = RestClient::Request.execute(method: :get,
                                           url: full_url,
                                           headers: {simicheck_api_key: @api_key},
                                           verify_ssl: false)
    return response
  end

  # Creates a new comparison
  def self.new_comparison
    full_url = @@base_uri + '/comparison'
    puts full_url
    json_body = {:comparison_name => 'test new comparison'}.to_json
    puts json_body
    response = RestClient::Request.execute(method: :put,
                                           url: full_url,
                                           payload: json_body,
                                           headers:
                                               {
                                                   simicheck_api_key: @api_key,
                                                   content_type: :json,
                                                   accept: :json
                                               },
                                           verify_ssl: false)
    return response
  end

  # Deletes a comparison
  def self.delete_comparison(comparison_id)
    full_url = @@base_uri + '/comparison/' + comparison_id
    puts full_url
    response = RestClient::Request.execute(method: :delete,
                                           url: full_url,
                                           headers: {simicheck_api_key: @api_key},
                                           verify_ssl: false)
    return response
  end

  # Gets the details about a comparison
  def self.get_comparison_details(comparison_id)
    full_url = @@base_uri + '/comparison/' + comparison_id
    puts full_url
    response = RestClient::Request.execute(method: :get,
                                           url: full_url,
                                           headers: {simicheck_api_key: @api_key},
                                           verify_ssl: false)
    return response
  end

  # Updates a comparison (currently only the name)
  def self.update_comparison(comparison_id)
    full_url = @@base_uri + '/comparison/' + comparison_id
    puts full_url
    json_body = {:comparison_name => 'test update comparison'}.to_json
    puts json_body
    response = RestClient::Request.execute(method: :post,
                                           url: full_url,
                                           payload: json_body,
                                           headers:
                                               {
                                                   simicheck_api_key: @api_key,
                                                   content_type: :json,
                                                   accept: :json
                                               },
                                           verify_ssl: false)
    return response
  end

  ############################################
  # File Operations
  ############################################

  # Uploads a file
  def self.upload_file(comparison_id)
    full_url = @@base_uri + '/upload_file/' + comparison_id
    puts full_url
    file_to_upload = File.new('/tmp/helloworld.txt', 'rb')
    json_body = {"file" => file_to_upload}
    response = RestClient::Request.execute(method: :put,
                                           url: full_url,
                                           payload: json_body,
                                           headers:
                                               {
                                                   simicheck_api_key: @api_key,
                                                   content_type: 'multipart/form-data',
                                                   accept: :json
                                               },
                                           verify_ssl: false)
    return response
  end

  # Deletes files from a comparison
  #   comparison_id - comparison to delete files from
  #   filenames - array of filenames to delete
  def self.delete_files(comparison_id, filenames_to_delete)
    full_url = @@base_uri + '/comparison/' + comparison_id
    puts full_url
    json_body = {"filenames" => filenames_to_delete}
    response = RestClient::Request.execute(method: :delete,
                                           url: full_url,
                                           payload: json_body,
                                           headers:
                                               {
                                                   simicheck_api_key: @api_key,
                                                   content_type: :json,
                                                   accept: :json
                                               },
                                           verify_ssl: false)
    return response
  end

  ############################################
  # Similarity
  ############################################

  # Gets the results of the similarity comparison
  def self.get_similarity_nxn(comparison_id)

  end

  # Starts the computation of file similarity for a comparison
  def self.post_similarity_nxn(comparison_id)

  end

  # Checks where a NxN comparison has terminated
  def self.get_similarity_status(comparison_id)

  end

  # Gets the latest results for the similarity of one file wrt. all other files in a comparison
  def self.get_similarity_1xn(comparison_id)

  end

  # Finds the files in a comparison that are most similar to a given file
  def self.post_similarity_1xn(comparison_id)

  end

  ############################################
  # Visualization
  ############################################

  # Gets the results of the similarity comparison
  def self.visualize_similarity(comparison_id)

  end

  # Gets the results of similarity comparison
  def self.visualize_comparison(comparison_id, file_id_1, file_id_2)

  end
end


###
# TESTING
###

# TODO: Refactor / accept all inputs to methods (no hardcoded values)

# Create new comparison
response = SimiCheckWebService.new_comparison
puts response.code
json_response = JSON.parse(response.body)
new_id = json_response["id"]
puts new_id
puts '----'
# Get list of all comparisons
response = SimiCheckWebService.get_all_comparisons
puts response.code
json_response = JSON.parse(response.body)
json_response["comparisons"].each do |comparison|
  puts comparison["comparison_name"] + ' (' + comparison["id"] + ')'
end
puts '----'
# Change the new comparison name
response = SimiCheckWebService.update_comparison(new_id)
puts response.code
puts '----'
# Upload a file to the new comparison
response = SimiCheckWebService.upload_file(new_id)
puts response.code
json_response = JSON.parse(response.body)
puts json_response["name"] + ' (' + json_response["id"] + ')'
puts '----'
# Look up the details for the newly created comparison
response = SimiCheckWebService.get_comparison_details(new_id)
response.code
json_response = JSON.parse(response.body)
puts json_response["name"] + ':'
json_response["files"].each do |file|
  puts file["name"] + ' (' + file["id"].to_s + ')'
end
puts '----'
# Delete the newly created comparison
response = SimiCheckWebService.delete_comparison(new_id)
puts response.code