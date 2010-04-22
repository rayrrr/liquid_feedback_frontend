local member = Member:by_id(param.get_id())

slot.select("title", function()
  execute.view{
    module = "member_image",
    view = "_show",
    params = {
      member = member,
      image_type = "avatar"
    }
  }
end)

slot.put_into("title", encode.html(_"Member '#{member}'":gsub("#{member}", member.name)))

slot.select("actions", function()
  if member.id == app.session.member.id then
  else
    --TODO performance
    local contact = Contact:by_pk(app.session.member.id, member.id)
    if contact then
      ui.container{
        attr = { class = "interest" },
        content = _"You have saved this member as contact."
      }
      ui.link{
        image  = { static = "icons/16/book_delete.png" },
        text   = _"Remove from contacts",
        module = "contact",
        action = "remove_member",
        id     = contact.other_member_id,
        routing = {
          default = {
            mode = "redirect",
            module = request.get_module(),
            view = request.get_view(),
            id = param.get_id_cgi(),
            params = param.get_all_cgi()
          }
        }
      }
    else
      ui.link{
        image   = { static = "icons/16/book_add.png" },
        text    = _"Add to my contacts",
        module  = "contact",
        action  = "add_member",
        id      = member.id,
        routing = {
          default = {
            mode = "redirect",
            module = request.get_module(),
            view = request.get_view(),
            id = param.get_id_cgi(),
            params = param.get_all_cgi()
          }
        }
      }
    end
  end
end)

slot.select("actions", function()
  ui.link{
    content = function()
      ui.image{ static = "icons/16/clock_edit.png" }
      slot.put(encode.html(_"Show name history"))
    end,
    module  = "member",
    view    = "history",
    id      = member.id
  }
end)

util.help("member.show", _"Member page")

execute.view{
  module = "member",
  view = "_show",
  params = { member = member }
}
