# Unterstützung für Intel-Chips kontrollieren

```
vainfo
```
```
sudo apt install intel-gpu-tools
```
```
sudo intel_gpu_top
```
Von Nvidia-Chip auf Intel wechseln (Notebooks mit Hybrid-Grafik):
```
sudo prime-select intel
```
# Videos in Firefox mit VA-API abspielen
```
sudo intel_gpu_top
```
Wer die GPU-Auslastung prüfen will, installiert das Tool Radeon Profile mit diesen drei Zeilen:
```
sudo add-apt-repository ppa:radeon-profile/stable
sudo apt update
sudo apt install radeon-profile
```
Der Wert hinter „GPU usage“ steigt, sobald Sie ein Video abspielen.

# VA-API für Nvidia nachrüsten
Ubuntu 22.04 oder Linux Mint 21, proprietäre Nvidia-Treiber in der Version 470, 500 oder höher.
```
sudo apt install build-essential git meson gstreamer1.0-plugins-bad libffmpeg-nvenc-dev libva-dev libegl-dev cmake pkg-config libdrm-dev libgstreamer-plugins-bad1.0-dev
```
Erstellen Sie ein Arbeitsverzeichnis und laden Sie den Quellcode herunter (vier Zeilen):
```
mkdir ~/src && cd ~/src
wget https://github.com/elFarto/nvidia-vaapi-driver/archive/refs/tags/v0.0.11.tar.gz
tar xvf v0.0.11.tar.gz
cd nvidia-vaapi-driver-0.0.11
```
Passen Sie die Versionsnummern bei Bedarf an (siehe https://github.com/elFarto/nvidia-vaapi-driver/releases). Danach kompilieren und installieren Sie den Treiber (zwei Zeilen):
```
meson setup build
sudo meson install -C build
```
# Nvidia-VA-API-Treiber für Firefox aktivieren
Öffnen Sie die Datei „/etc/environment“ als Administrator in einem Texteditor und fügen Sie die drei Zeilen 
```
export LIBVA_DRIVER_NAME=nvidia
export MOZ_DISABLE_RDD_SANDBOX=1
export NVD_BACKEND=direct
```
an. Die letzte Zeile ist zurzeit für Nvidia-Treiber ab Version 525 erforderlich.

Außerdem muss dem Linux-Kernel beim Start eine zusätzliche Option übergeben werden. Öffnen Sie die Textdatei „/etc/default/grub“ mit administrativen Rechten und ergänzen Sie in der Zeile „GRUB_CMDLINE_LINUX_DEFAULT“ die Option 
```
nvidia-drm.modeset=1
```
Danach führen Sie im Terminal
```
sudo update-grub
```
aus. Starten Sie Linux neu, damit die Änderungen wirksam werden.

Mit vainfo können Sie die korrekte Funktion prüfen. Das Tool gibt „vainfo: Driver version: VA-API NVDEC driver [direct backend]“ aus.
Damit Firefox den neuen Treiber berücksichtigt, müssen Sie einige Einstellungen ändern. Zur Sicherheit verwenden Sie ein neues Benutzerprofil, um die Einstellungen erst einmal zu testen. Starten Sie im Terminal
```
firefox -P
```
und erstellen und starten Sie ein neues Profil. Rufen Sie die URL about:config auf und ändern Sie die folgenden drei Optionen
```
media.ffmpeg.vaapi.enabled
media.rdd-ffmpeg.enabled
widget.dmabuf.force-enabled
```
jeweils auf „true“. Danach starten Sie Firefox neu.

Für den Test der GPU-Auslastung starten Sie Nvidia X Server Settings und klicken auf „GPU 0“ ([Nvidia-Modell])“. Hinter „GPU Utilization“ und „Video Engine Utilization“ steigen die Werte, wenn die Hardwarebeschleunigung genutzt wird.
