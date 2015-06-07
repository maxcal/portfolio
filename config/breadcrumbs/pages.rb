crumb :pages do
  link "Pages", pages_path
end

crumb :page do |page|
  link page.title, page
  parent :pages
end

crumb :new_page do
  link "New page", new_page_path
  parent :pages
end

crumb :edit_page do |page|
  link "Editing #{page.title}", edit_page_path(page)
  parent :pages
end