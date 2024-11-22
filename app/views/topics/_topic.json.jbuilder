json.extract! topic, :id, :title, :content, :author_name, :created_at, :updated_at
json.url topic_url(topic, format: :json)
