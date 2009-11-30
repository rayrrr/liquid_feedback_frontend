local initiative = Initiative:by_id(param.get("initiative_id", atom.integer))
local issue = initiative.issue
local member = Member:by_id(param.get("member_id", atom.integer))

local members_selector = Member:new_selector()
  :join("delegating_population_snapshot", nil, "delegating_population_snapshot.member_id = member.id")
  :add_where{ "delegating_population_snapshot.issue_id = ?", issue.id }
  :add_where{ "delegating_population_snapshot.event = ?", issue.latest_snapshot_event }
  :add_where{ "delegating_population_snapshot.delegate_member_ids[1] = ?", member.id }
  :add_field{ "delegating_population_snapshot.weight" }

execute.view{
  module = "member",
  view = "_list",
  params = { 
    members_selector = members_selector,
    issue = issue,
    trustee = member
  }
}