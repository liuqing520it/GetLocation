Pod::Spec.new do |s|
s.name     = 'LQGetLocationInfo'
s.version  = '1.0.0'
s.license = 'MIT'
s.platform = :ios, '9.0'
s.summary  = 'get positions'
s.homepage = 'https://github.com/liuqing520it/GetLocation'
s.authors   = { "liuqing520it" => "330663384@qq.com" }
s.source   = { :git => 'https://github.com/liuqing520it/GetLocation.git', :tag => s.version  }
s.description = 'a framework can get current location; also search location information.'
s.source_files = 'Sources/*.{.h.m}'
s.requires_arc = true
s.dependency AMap3DMap
s.dependency AMapSearch
end


