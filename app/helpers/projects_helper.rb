module ProjectsHelper
     
  def designs_list(projectId)
    stateAvailable = State.where(name_state: "Disponible").first    
    @designs = Design.collection.aggregate([
      {
        '$sort' => {'created_at' => -1}
      },
      {
        '$match' => { '$and': [{'project_id'=> projectId}, {'state_id'=> stateAvailable._id}]}
      },
      {
        '$lookup':
          {
            'from': "designers",
            'localField': "designer_id",
            'foreignField': "_id",
            'as': "designer"
          }
      },
      {
        '$lookup':
          {
            'from': "states",
            'localField': "state_id",
            'foreignField': "_id",
            'as': "state"
          }
      }
    ]).as_json()

    @designs.each do |d| 
      currentDesign = Design.where(_id: d['_id']['$oid']).first
      d['original_design'] = currentDesign.path_original_design.url
      d['mini'] = currentDesign.path_original_design.mini.url
      puts d
    end

    return @designs
  end
end
