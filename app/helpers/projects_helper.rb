module ProjectsHelper
     
  def designs_list(projectId)
    @designs = Design.select('
        d.id,
        d.name,
        d.lastname,
        d.email,
        designs.id,
        designs.path_original_design,
        designs.path_modified_design,
        designs.price,
        designs.created_at,
        s.name_state')
        .joins("INNER JOIN designers As d ON designs.designer_id = d.id")
        .joins("INNER JOIN states As s ON designs.state_id = s.id")
        .where(project_id: projectId, state_id: 2)
        .order(created_at: :desc)
        .all
    return @designs
  end
end
