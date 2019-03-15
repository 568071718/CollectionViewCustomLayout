
Pod::Spec.new do |s|

s.name         = "DSHCustomLayout"
s.version      = "0.0.1"
s.summary      = "自定义 collection view layout"
s.description  = <<-DESC
        UICollectionView 横向分页自定义layout
                    DESC
s.homepage     = "https://github.com/568071718/CollectionViewCustomLayout"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "lu" => "568071718@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/568071718/CollectionViewCustomLayout.git", :tag => s.version }
s.source_files  = "Classes", "Classes/**/*.{h,m}"
s.requires_arc = true
end
