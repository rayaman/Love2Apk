print("Loading please wait...")
package.path = "./?/init.lua;./?.lua;"
package.cpath = "./?.dll;"
local gd = require("gd")
local bin = require("bin")
function getInput(msg,list)
	io.write(msg or "")
	local dat = io.read()
	if list then
		for i=1,#list do
			if list[i]==dat then
				return dat
			end
		end
		print("Invalid input: "..dat)
		return getInput(msg,list)
	else
		return dat
	end
end
print("AutoLoveMaker V1.0.0\nEnsure that all your files are in the same directory as the program! game.love, and loveandroid.apk must be present with these filenames for the program to work!")
name = getInput("Game Name: ")
if not io.dirExists("dat") then
	io.mkDir("dat")
end
_o={l = "sensorLandscape",p = "portrait"}
if bin.fileExist("dat/"..name..".dat") then
	b = getInput("You have compiled a game by this name before! Do you want to use the last build settings? (y/n): ",{"y","n"})
	if not io.dirExists("love_decoded") then
		os.execute([[apktool d -s -o love_decoded ../loveandroid.apk]])
	end
	if b=="y" then
		local file = bin.load("dat/"..name..".dat")
		local dat = file:getBlock("t")
		o=dat.o
		packageName=dat.packageName
		ver=dat.ver
		verN=dat.verN
	else
		print("We are going to manage Settings that affect your apk...")
		o = getInput("Svreep Orientation(p - portrait | l - landscape): ",{"o","p"})
		packageName = "game."..name..".org"
		ver = getInput("Version Code(number): ")
		verN = getInput("Version Name(number.number): ")
		if not io.dirExists("love_decoded") then
			os.execute([[apktool d -s -o love_decoded ../loveandroid.apk]])
		end
		io.mkDir("love_decoded/assets")
		bin.load("game.love"):tofile("love_decoded/assets/game.love")
		local file = bin.new()
		file:addBlock({
			o = o,
			packageName = packageName,
			ver = ver,
			verN = verN,
		})
		file:tofile("dat/"..name..".dat")
	end
else
	print("We are going to manage Settings that affect your apk...")
	o = getInput("Svreep Orientation(p - portrait | l - landscape): ",{"o","p"})
	packageName = "game."..name..".org"
	ver = getInput("Version Code(number): ")
	verN = getInput("Version Name(number.number): ")
	if not io.dirExists("love_decoded") then
		os.execute([[apktool d -s -o love_decoded ../loveandroid.apk]])
	end
	io.mkDir("love_decoded/assets")
	bin.load("game.love"):tofile("love_decoded/assets/game.love")
	local file = bin.new()
	file:addBlock({
		o = o,
		packageName = packageName,
		ver = ver,
		verN = verN,
	})
	file:tofile("dat/"..name..".dat")
end
if bin.fileExist("../game.png") then
	print("building icon")
	local icon = gd.createFromPng("../game.png")
	local i48 = gd.createFromPng("love_decoded/res/drawable-mdpi/love.png")
	local i96 = gd.createFromPng("love_decoded/res/drawable-xhdpi/love.png")
	local i144 = gd.createFromPng("love_decoded/res/drawable-xxhdpi/love.png")
	local i192 = gd.createFromPng("love_decoded/res/drawable-xxxhdpi/love.png")
	i48:copyResized(icon, 0, 0, 0, 0, 48, 48, 192, 192)
	i96:copyResized(icon, 0, 0, 0, 0, 96, 96, 192, 192)
	i144:copyResized(icon, 0, 0, 0, 0, 144, 144, 192, 192)
	i192:copyResized(icon, 0, 0, 0, 0, 192, 192, 192, 192)
	i48:pngEx("love_decoded/res/drawable-mdpi/love.png",0)
	i96:pngEx("love_decoded/res/drawable-xhdpi/love.png",0)
	i144:pngEx("love_decoded/res/drawable-xxhdpi/love.png",0)
	i192:pngEx("love_decoded/res/drawable-xxxhdpi/love.png",0)
end
bin.new([[<?xml version="1.0" encoding="utf-8" standalone="no"?>
<manifest package="]]..packageName..[["
      android:versionCode="]]..ver..[["
      android:versionName="]]..verN..[["
      android:installLocation="auto" xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.VIBRATE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-feature android:glEsVersion="0x00020000"/>
    <application
        android:allowBackup="true"
        android:icon="@drawable/love"
        android:label="]]..name..[["
        android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
    >
        <activity
            android:configChanges="orientation|screenSize"
            android:label="]]..name..[["
            android:launchMode="singleTop"
            android:name="org.love2d.android.GameActivity"
            android:screenOrientation="]].._o[o]..[["
        >
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
                <category android:name="tv.ouya.intent.category.GAME"/>
            </intent-filter>
        </activity>
    </application>
</manifest>]]):tofile("love_decoded/AndroidManifest.xml")
temp = bin.load("love_decoded/apktool.yml")
temp.data:gsub("minSdkVersion: '(%d%d)'","minSdkVersion: '16'")
temp.data:gsub("targetSdkVersion: '(%d%d)'","targetSdkVersion: '16'")
temp:tofile("love_decoded/apktool.yml")
print("Building apk...")
os.execute([[apktool b -o ]]..name..[[.apk love_decoded]])
print("Signing apk...")
os.execute([[java -jar uber-apk-signer.jar -a ]]..name..[[.apk]])
f1 = bin.load(name.."-aligned-debugSigned.apk"):tofile("../"..name.."-Signed.apk")
f2 = bin.load(name..".apk"):tofile("../"..name.."-Unsigned.apk")
os.remove(name.."-aligned-debugSigned.apk")
os.remove(name..".apk")
--minSdkVersion: '16'
--targetSdkVersion: '16'

--portrait,sensorLandscape
