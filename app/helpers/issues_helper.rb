module IssuesHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
  $arr_parent = []
  def find_subtask value_parent
    # arr_parent = []
    # parent = value_parent
    # if parent.nil?
    #   return arr_parent
    # end
    # while 1
    #   @query = Issue.where("parent_id=?", parent)
    #   if @query.blank?
    #     arr_parent << parent
    #     break
    #   else
    #     @query.each do |k|
    #       arr_parent << parent
    #       parent = k.id
    #       break
    #     end
    #   end
    # end
    # return arr_parent
    @query = Issue.where("parent_id=?", value_parent)
    if @query.nil?
      return $arr_parent
    else
      @query.each do |k|
        $arr_parent << k.id
        find_subtask(k.id)
      end
    end
    return $arr_parent
  end

  def create_index params_page, index, per_page
    params_page = 1 if params_page.nil?
    (params_page.to_i - 1) * per_page.to_i + index.to_i + 1
  end
end
