# ld06_test
[![Open in Dev Containers](https://img.shields.io/static/v1?label=Dev%20Containers&message=Open&color=blue&logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/teruyamato0731/ld06_test)

ROS2 でUSBシリアル変換基板を用いて [LD06 LiDAR](https://www.ldrobot.com/editor/file/20210422/1619071627351038.pdf) の動作を確認する。

これらの動作確認は [Qiitaの記事](https://qiita.com/porizou1/items/77a59ef93e77b10edbda) を参考に行った。

# 環境
- Ubuntu 22.04
- ROS2 humble

# 配線
LD06 LiDAR をUSBシリアル変換ケーブルに繋ぎ、USBをPCに挿す。

`lsusb` を実行し、シリアル変換機を検知していることを確認。
また `ls /dev/ | grep ttyUSB` を実行し、シリアル変換機のポートを確認しておく。

/dev/ 以下に ttyUSB がなかった場合 -> [#Trouble Shooting](#trouble-shooting)

# Quick Start
あなたがすでにVS CodeとDockerをインストールしている場合は、上記のバッジまたは[こちら](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/teruyamato0731/ld06_test)をクリックすることで使用することができる。<br>
これらのリンクをクリックすると、vscodeが必要に応じてdev container拡張機能を自動的にインストールし、ソースコードをコンテナボリュームにクローンし、使用するためのdev containerを起動する。

上記手順がうまく行かなかった場合、下記コマンドを手動で実行する。
```bash
git clone https://github.com/teruyamato0731/ld06_test.git
code ld06_test
```
その後、vscode の中で「Open in Container」を実行する。

# How to use
1. 下記コマンドを実行。
  ```bash
  rosdep update && rosdep install --from-path src --ignore-src -y
  colcon build
  source install/setup.bash
  ```
1. ROS ノードを実行。
  なお ${USB_PORT} は各自のシリアル変換機のポートに読み替えること。
  ```bash
  ros2 launch ldlidar ldlidar.launch.py serial_port:=/dev/${USB_PORT}
  # 例
  # ros2 launch ldlidar ldlidar.launch.py serial_port:=/dev/ttyUSB0
  ```
1. `rviz2` を起動し、FixedFrame に laser を入力。ADDからLaserScanを選択して /scan を追加。

# Trouble Shooting
`sudo dmesg` で出力を確認。
```log
[ 4383.654037] ch341 1-2:1.0: ch341-uart converter detected
[ 4383.655295] usb 1-2: ch341-uart converter now attached to ttyUSB0
[ 4384.217062] input: BRLTTY 6.4 Linux Screen Driver Keyboard as /devices/virtual/input/input37
[ 4384.336817] usb 1-2: usbfs: interface 0 claimed by ch341 while 'brltty' sets config #1
[ 4384.337255] ch341-uart ttyUSB0: ch341-uart converter now disconnected from ttyUSB0
[ 4384.337270] ch341 1-2:1.0: device disconnected
```
上記メッセージがあった場合、下記コマンドで解決できる。[参照](https://www.reddit.com/r/pop_os/comments/uf54bi/how_to_remove_or_disable_brltty/)
```bash
systemctl stop brltty-udev.service
sudo systemctl mask brltty-udev.service
systemctl stop brltty.service
systemctl disable brltty.service
```
