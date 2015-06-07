crumb :photosets do
  link "Photosets", photosets_path
end

crumb :photoset do |ps|
  link ps.title, photosets_path(ps)
  parent :photosets
end

crumb :new_photoset do
  link "New photoset", new_photoset_path
  parent :photosets
end

crumb :edit_photoset do |ps|
  link "Edit #{ps.title}", new_photoset_path
  parent :photosets
end