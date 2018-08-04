User.create!(
  login_name: "admin",
  last_name: "admin",
  first_name: "admin",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  user_type: 0,
  activated: true,
  activated_at: Time.zone.now
  )

110.times do |t|
  User.create!(
  login_name: "user#{t}",
  last_name: "user#{t}",
  first_name: "user#{t}",
  email: "user#{t}@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  user_type: 1,
  activated: true,
  activated_at: Time.zone.now
  )
end

8.times do |t|
  IssueTemplate.create!(
  name: "template#{t}",
  description: "template#{t}",
  type_template: 1,
  user_id: 1
  )
end

100.times do |p|
  n = "New"
  i = "In Progress"
  r = "Resolved"
  s = n
  if p%6 == 0
    s = n
  elsif p%3 == 0
    s = i
  else
    s = r
  end
  tmp = rand(1..100)
  Project.create!(
    name: "project#{p}",
    description: "Cras nascetur. Dapibus eget nisl
    fermentum ipsum vehicula. Quam
    feugiat urna rutrum vel sed, urna velit tincidunt donec
    justo metus imperdiet. Turpis urna consectetuer",
    user_id: tmp,
    status: s
    )
end


for setProject in 1...100
  tmpUser = []
  randNumb = rand(1...5)
  for i in 0...randNumb
    setUser = rand(1..100)
    if tmpUser.include?(setUser)
      next
    else
      tmpUser << setUser
      UserProject.create!(
            project_id: setProject,
            user_id: setUser
          )
    end
  end
end

# 50.times do |n|
#   source = ["/home/packetloss0709/Desktop/logo.png"]
#   Emoji.create!(
#     user_id: rand(1..110),
#     code: "tmp#{n+1}",
#     emo: source
#   )
# end

20.times do |n|
  type_issue = "Task"
  subject = "genTask#{n+1}"
  Issue.create!(
    type_issue: 2,
    subject: subject,
    user_id: rand(1...110),
    description: "Cras nascetur. Dapibus eget nisl
    fermentum ipsum vehicula. Quam
    feugiat urna rutrum vel sed, urna velit tincidunt donec
    justo metus imperdiet. Turpis urna consectetuer",
    assignee: "",
    status: "New",
    priority: 1,
    percent_progress: "0%",
    project_id: 20,
    created_at: "2017-07-27 08:29:25"
    )
end
20.times do |n|
  type_issue = "Bug"
  subject = "genBug#{n+1}"
  Issue.create!(
    type_issue: 1,
    subject: subject,
    user_id: rand(1...110),
    description: "Cras nascetur. Dapibus eget nisl
    fermentum ipsum vehicula. Quam
    feugiat urna rutrum vel sed, urna velit tincidunt donec
    justo metus imperdiet. Turpis urna consectetuer",
    assignee: "",
    status: "New",
    priority: 1,
    percent_progress: "0%",
    project_id: 20,
    created_at: "2017-07-27 08:29:25"
    )
end
