Fabricator(:organization) do
  name { sequence(:name) { |i| "Organization-Name-#{i}"  }  }
end

