json.array!(@reports) do |report|
  json.extract! report, :id, :sha1, :title, :createdOn, :updatedOn, :type, :mimeType, :size, :file
  json.url report_url(report, format: :json)
end
