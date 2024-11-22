json.extract! reply, :id, :content, :author_name, :topic_id, :created_at, :updated_at
json.url reply_url(reply, format: :json)
