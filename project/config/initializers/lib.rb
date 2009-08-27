class SourceFile < Pathname
  def require
    require to_s.gsub(extname, "")
  end
end

SourceFile.glob("lib/**/*.rb") &:require