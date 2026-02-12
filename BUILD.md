# MBox 构建脚本

## 简介

跨平台构建脚本，自动完成：复制签名文件 → 构建 APP → 删除签名文件

## 前置要求

- Git
- JDK 21+
- Android SDK
- Gradle 8.7+

## 使用方法

### Windows

```cmd
build.bat
```

### Mac / Linux

```bash
chmod +x build.sh
./build.sh
```

## 构建产物

| 类型 | 路径 |
|------|------|
| Debug | `app/build/outputs/apk/debug/MBox_v*.apk` |
| Release | `app/build/outputs/apk/release/MBox_v*.apk` |

## 工作流程

1. **检查签名文件** - 从 `MBox-Build` 仓库获取
2. **复制签名文件** - 临时复制到 `app/TVBoxOSC.jks`
3. **构建 Debug APK** - `gradlew assembleDebug`
4. **构建 Release APK** - `gradlew assembleRelease`
5. **清理签名文件** - 自动删除敏感文件

## 目录结构

```
TVBoxOS-Mobile/
├── build.bat          # Windows 构建脚本
├── build.sh           # Mac/Linux 构建脚本
├── MBox-Build/        # 签名文件仓库 (父目录)
└── app/
    └── TVBoxOSC.jks   # 临时签名文件 (构建后删除)
```

## 注意事项

- 签名文件 `TVBoxOSC.jks` 不会提交到版本控制
- 首次运行前请确保 `MBox-Build` 仓库在父目录中
- 构建完成后签名文件会被自动清理
