# 🕌 Namaz Vakitleri Plasmoid

Günlük namaz vakitlerini gösteren ve hatırlatan KDE Plasma plasmoid'i. 🕰️

## ✨ Özellikler

- 📅 Günlük namaz vakitlerini gösterir (İmsak, Güneş, Öğle, İkindi, Akşam, Yatsı)
- ⏳ Bir sonraki namaz vaktine kalan süreyi gösterir
- 🔆 Mevcut namaz vaktini vurgular
- 🔔 Yaklaşan namaz vakitleri için bildirimler sunar (1 saat, 15 dakika ve 5 dakika kala)
- 🔄 Otomatik olarak günlük namaz vakitlerini günceller

## Ekran görüntüsü
![image](https://github.com/user-attachments/assets/f8752c89-c604-4ff1-86ba-1bc6f1e5b27c)


## 🛠️ Kurulum

1. Repository'yi klonlayın:
2. git clone https://github.com/codermert/NamazVakitleri_KDE.git

Plasmoid'i derleyin ve yükleyin:
cd NamazVakitleri_KDE
mkdir build && cd build
cmake ..
make
sudo make install

kquitapp6 plasmashell && kstart6 plasmashell
Plasmoid'i masaüstünüze ekleyin. 🖥️

## 🚀 Kullanım

Plasmoid'i ekledikten sonra, otomatik olarak günlük namaz vakitlerini gösterecek ve güncelleyecektir. Yaklaşan namaz vakitleri için bildirimler alacaksınız. 🙏

## 🎨 Özelleştirme

Şu an için, plasmoid Diyarbakır şehri için namaz vakitlerini göstermektedir. Farklı bir şehir için vakitleri göstermek isterseniz, `updatePrayerTimes()` fonksiyonundaki API URL'sini değiştirmeniz gerekecektir.

## 🤝 Katkıda Bulunma

1. Bu repository'yi fork edin 🍴
2. Yeni bir özellik branch'i oluşturun (`git checkout -b yeni-ozellik`)
3. Değişikliklerinizi commit edin (`git commit -am 'Yeni özellik: Detaylar'`)
4. Branch'inizi push edin (`git push origin yeni-ozellik`)
5. Yeni bir Pull Request oluşturun 📬

## 📄 Lisans

Bu proje [MIT Lisansı](LICENSE) altında lisanslanmıştır.

## 📞 İletişim

Sorularınız veya önerileriniz için lütfen bir issue oluşturun veya [codermert@bk.ru] adresinden bana ulaşın. 💌

## 🧑‍💻 Geliştirici Bilgileri

Bu plasmoid, QtQuick 2.15 ve KDE Plasma framework'ü kullanılarak geliştirilmiştir. Ana kod şu şekildedir:

```qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents
import Qt.labs.platform 1.1 as Platform

PlasmoidItem {
 // 
}
