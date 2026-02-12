#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_REPO="$PARENT_DIR/MBox-Build"
KEYSTORE_SRC="$BUILD_REPO/DIY/TVBoxOSC.jks"
KEYSTORE_DST="$SCRIPT_DIR/app/TVBoxOSC.jks"

echo "========================================"
echo "MBox 构建脚本 (Mac/Linux)"
echo "========================================"

# 检查签名文件是否存在
if [ ! -f "$KEYSTORE_SRC" ]; then
    echo "[错误] 签名文件不存在: $KEYSTORE_SRC"
    echo "请确保 MBox-Build 仓库已克隆到父目录"
    exit 1
fi

# 复制签名文件
echo "[1/3] 复制签名文件..."
cp "$KEYSTORE_SRC" "$KEYSTORE_DST"

# 清理函数（确保失败时也删除签名文件）
cleanup() {
    if [ -f "$KEYSTORE_DST" ]; then
        echo "[3/3] 清理签名文件..."
        rm -f "$KEYSTORE_DST"
    fi
}
trap cleanup EXIT

# 构建 Debug APK
echo "[2/3] 构建 Debug APK..."
./gradlew assembleDebug --no-daemon

# 构建 Release APK
echo "[2/3] 构建 Release APK..."
./gradlew assembleRelease --no-daemon

echo ""
echo "========================================"
echo "构建完成！"
echo "Debug:   app/build/outputs/apk/debug/MBox_v*.apk"
echo "Release: app/build/outputs/apk/release/MBox_v*.apk"
echo "========================================"
