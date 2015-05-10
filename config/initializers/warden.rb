Warden::Manager.serialize_into_session do |user|
  # ID in Mongoid is a BSON:ObjectId object - we just want the id string
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find(id)
end