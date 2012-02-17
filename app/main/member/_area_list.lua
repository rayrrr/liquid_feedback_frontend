local units = app.session.member.units_with_voting_right
local member = param.get("member", "table")
for i, unit in ipairs(units) do
  local areas_selector = Area:new_selector()
    :join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", member.id })
    :add_where{ "area.unit_id = ?", unit.id }
    :add_order_by("area.member_weight DESC")
  
  local area_count = areas_selector:count()
  local class = "heading"
  if area_count > 0 then
    class = class .. " member_area_list"
  end
  ui.link{
    attr = { class = class },
    text = unit.name,
    module = "area", view = "list", params = { unit_id = unit.id }
  }

  if area_count > 0 then
    execute.view{
      module = "area", view = "_list",
      params = { areas_selector = areas_selector }
    }
  else
    ui.tag{ content = _"You have voting privileges for this unit, but you are not member of any of its areas." }
    slot.put(" ")
    ui.link{
      text = _"Show all areas of this unit",
      module = "area", view = "list", params = { unit_id = unit.id }
    }
   end
  slot.put("<br />")
  slot.put("<br />")
  
end
