module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.upcase
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    if season
      link_to title, {sort: column, direction: direction, season: season}, {:class => css_class}
    else
      link_to title, {sort: column, direction: direction}, {:class => css_class}
    end
  end
end
