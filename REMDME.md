#!/bin/bash

#用于打包ipa（用于普通xcodeproj文件打包）
#参数说明：参数1：项目的工程路径xcodeproj文件上层目录
#参数2：target名称
#调用方法：sh path/to/ipa_build.sh path/to/project targetName

project_path=$1
target_name=$2

abc_Lee@bogon


cd $project_path

/usr/bin/xcodebuild -target $target_name clean
/usr/bin/xcodebuild -target $target_name

/usr/bin/xcrun -sdk iphoneos PackageApplication -v ./build/Release-iphoneos/$target_name.app -o $project_path/$ipa_name.ipa


