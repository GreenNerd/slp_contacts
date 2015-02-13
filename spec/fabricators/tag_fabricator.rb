Fabricator(:tag) do
  name { sequence(:name) { |i| "Tag-Name-#{i}"  }  }
end

