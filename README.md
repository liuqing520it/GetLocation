# GetLocation
静态库可以用来获取当前位置和搜索位置信息;
a framework can get current location; also search location information.


## 效果图 effect picture
![image](https://github.com/liuqing520it/GetLocation/raw/master/images/getposition.gif)

## 如何使用 How to use

1. 打开工程 切换到framwork;

![image](https://github.com/liuqing520it/GetLocation/raw/master/images/WX20171216-224718.png)
##
2. 配置工程

一. 为了保证编译的静态包含所有架构

![image](https://github.com/liuqing520it/GetLocation/raw/master/images/5946F42A.png)

二. 制作的是静态库, 动态库是不允许上架的!

![image](https://github.com/liuqing520it/GetLocation/raw/master/images/BC98F35A.png)

三. 最终发布版本是release,所以这里编译release

![image](https://github.com/liuqing520it/GetLocation/raw/master/images/WX20171216-230645.png)
##
3. 编译framework工程,Show in Find

![image](https://github.com/liuqing520it/GetLocation/raw/master/images/WX20171216-231038.png)

* tips: 如果需要模拟器调试 建议打包的时候将真机版本和模拟器版本合并;

合并命令:sudo lipo -create "真机framework路径" 加上 "模拟器framework路径"  -output "合并之后的路径"/"静态库的名字"
* 例如: ```sudo lipo -create /Users/liuqing/Library/Developer/Xcode/DerivedData/GetLocationInfo-hcrqkywlkcuzasgisrzxjhdpwfxs/Build/Products/Release-iphoneos/LocationInfoFramework.framework/LocationInfoFramework /Users/liuqing/Library/Developer/Xcode/DerivedData/GetLocationInfo-hcrqkywlkcuzasgisrzxjhdpwfxs/Build/Products/Release-iphonesimulator/LocationInfoFramework.framework/LocationInfoFramework -output /User/Desktop/temp/LocationInfoFramework ```

##
4. 将打包好的framework和资源包拖入到新工程
![image](https://github.com/liuqing520it/GetLocation/raw/master/images/WX20171217-221359.png)
###
5. 因为集成的是高德地图的SDK所以工程需要导入高德的SDK;这里采用Pod自动导入(如果需要手动导入请参考 [高德的开放平台] (http://lbs.amap.com/api/ios-sdk/guide/create-project/manual-configuration). )
```
pod 'AMap3DMap'

pod 'AMapSearch'
```
###
6. 代码调用
    一. 首先在info.plist 添加两个重要Key ``` Privacy - Location When In Use Usage Description和Privacy - Location Always and When In Use Usage Description```
    ###
    二. 首先包含头文件,遵循代理接收回调;
   ![image](https://github.com/liuqing520it/GetLocation/raw/master/images/WX20171217-222933.png)
   ###
   三. present出封装好的控制器遵循代理并实现代理方法
    ![image](https://github.com/liuqing520it/GetLocation/raw/master/images/WX20171217-223402.png)
    ###
    


