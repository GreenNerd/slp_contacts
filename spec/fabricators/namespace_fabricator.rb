Fabricator(:namespace) do
  name { sequence(:name) { |i| "Name-#{i}"  }  }
end

