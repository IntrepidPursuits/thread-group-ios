source 'https://github.com/CocoaPods/Specs.git'

def tg_pods
  pod 'Reachability'
  pod 'UICKeyChainStore', '~> 2.0'
  pod 'UIDeviceIdentifier', :git => 'https://github.com/squarefrog/UIDeviceIdentifier.git'
  pod 'PureLayout', '~> 3.0'
end

target "ThreadGroup" do
  tg_pods
end

target "ThreadGroupTests" do
  tg_pods
end
