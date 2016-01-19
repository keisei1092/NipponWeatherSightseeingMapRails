class ActionDispatch::Request
  alias_method :__url, :url
  def url
    __url.force_encoding("utf-8")
  end
end
