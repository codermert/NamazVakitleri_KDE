import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents
import Qt.labs.platform 1.1 as Platform

PlasmoidItem {
    width: 600
    height: 150

    property string currentDate: ""
    property var nextPrayerTime: null
    property string nextPrayerName: ""
    property string remainingTime: ""
    property int currentPrayerIndex: -1
    property var lastNotificationTime: null

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height - 40
            spacing: 1

            Repeater {
                model: ListModel {
                    id: prayerTimesModel
                }

                delegate: Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: index === currentPrayerIndex ? "#4CAF50" : "#E8F5E9"

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 5

                        PlasmaComponents.Label {
                            text: model.name
                            font.pointSize: 12
                            color: index === currentPrayerIndex ? "white" : "#388E3C"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        PlasmaComponents.Label {
                            text: model.time
                            font.pointSize: 14
                            font.bold: true
                            color: index === currentPrayerIndex ? "white" : "#388E3C"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                }
            }
        }

        PlasmaComponents.Label {
            text: nextPrayerName + " VAKTİNE KALAN SÜRE: " + remainingTime
            font.pointSize: 12
            font.bold: true
            color: "#388E3C"
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var newDate = Qt.formatDate(new Date(), "yyyy-MM-dd")
            if (newDate !== currentDate) {
                currentDate = newDate
                updatePrayerTimes()
            }
            checkAndNotify()
            updateRemainingTime()
            updateCurrentPrayerIndex()
        }
    }

    Timer {
        interval: 3600000 // Her saat (3600000 ms = 1 saat)
        running: true
        repeat: true
        onTriggered: {
            updatePrayerTimes()
        }
    }

    Platform.SystemTrayIcon {
        id: systemTrayIcon
        visible: true
        icon.name: "clock" // veya başka bir uygun ikon adı
    }

    Component.onCompleted: {
        currentDate = Qt.formatDate(new Date(), "yyyy-MM-dd")
        updatePrayerTimes()
    }

    function updatePrayerTimes() {
        var xhr = new XMLHttpRequest();
        var apiUrl = "https://vakit.vercel.app/api/timesFromPlace?country=Turkey&region=Diyarbak%C4%B1r&city=Diyarbak%C4%B1r&date=" + currentDate + "&days=1&timezoneOffset=180&calculationMethod=Turkey";
        
        xhr.open("GET", apiUrl);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    var times = response.times[currentDate];
                    var names = ["İMSAK", "GÜNEŞ", "ÖĞLE", "İKİNDİ", "AKŞAM", "YATSI"];
                    if (prayerTimesModel.count > 0) {
                        prayerTimesModel.clear();
                    }
                    for (var i = 0; i < times.length; i++) {
                        prayerTimesModel.append({"name": names[i], "time": times[i]});
                    }
                    updateNextPrayerTime()
                    updateCurrentPrayerIndex()
                } else {
                    console.log("Failed to fetch prayer times");
                }
            }
        }
        xhr.send();
    }

    function updateNextPrayerTime() {
        var now = new Date();
        nextPrayerTime = null;
        nextPrayerName = "";

        for (var i = 0; i < prayerTimesModel.count; i++) {
            var prayerTime = new Date(currentDate + " " + prayerTimesModel.get(i).time);
            if (prayerTime > now) {
                nextPrayerTime = prayerTime;
                nextPrayerName = prayerTimesModel.get(i).name;
                break;
            }
        }

        if (!nextPrayerTime) {
            nextPrayerTime = new Date(currentDate + " " + prayerTimesModel.get(0).time);
            nextPrayerTime.setDate(nextPrayerTime.getDate() + 1);
            nextPrayerName = prayerTimesModel.get(0).name;
        }
        updateRemainingTime();
    }

    function updateRemainingTime() {
        if (!nextPrayerTime) return;

        var now = new Date();
        var timeDiff = nextPrayerTime.getTime() - now.getTime();
        
        var hours = Math.floor(timeDiff / (1000 * 60 * 60));
        var minutes = Math.floor((timeDiff % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((timeDiff % (1000 * 60)) / 1000);
        
        remainingTime = padZero(hours) + ":" + padZero(minutes) + ":" + padZero(seconds);
    }

    function updateCurrentPrayerIndex() {
        var now = new Date();
        currentPrayerIndex = -1;
        for (var i = 0; i < prayerTimesModel.count; i++) {
            var prayerTime = new Date(currentDate + " " + prayerTimesModel.get(i).time);
            if (now >= prayerTime) {
                currentPrayerIndex = i;
            } else {
                break;
            }
        }
        if (currentPrayerIndex === -1 && prayerTimesModel.count > 0) {
            currentPrayerIndex = prayerTimesModel.count - 1;
        }
    }

    function padZero(num) {
        return num < 10 ? "0" + num : num;
    }

    function checkAndNotify() {
        if (!nextPrayerTime) return;

        var now = new Date();
        var timeDiff = (nextPrayerTime.getTime() - now.getTime()) / 60000;

        if (timeDiff <= 60 && timeDiff > 59 && (!lastNotificationTime || now - lastNotificationTime > 3600000)) {
            systemTrayIcon.showMessage("Namaz Vakti Yaklaşıyor", nextPrayerName + " vaktine 1 saat kaldı");
            lastNotificationTime = now;
        } else if (timeDiff <= 15 && timeDiff > 14 && (!lastNotificationTime || now - lastNotificationTime > 900000)) {
            systemTrayIcon.showMessage("Namaz Vakti Yaklaşıyor", nextPrayerName + " vaktine 15 dakika kaldı");
            lastNotificationTime = now;
        } else if (timeDiff <= 5 && timeDiff > 4 && (!lastNotificationTime || now - lastNotificationTime > 300000)) {
            systemTrayIcon.showMessage("Namaz Vakti Çok Yakın", nextPrayerName + " vaktine 5 dakika kaldı");
            lastNotificationTime = now;
        } else if (timeDiff <= 0 && timeDiff > -1 && (!lastNotificationTime || now - lastNotificationTime > 60000)) {
            systemTrayIcon.showMessage("Namaz Vakti", nextPrayerName + " vakti girdi");
            lastNotificationTime = now;
            updateNextPrayerTime();
        }
    }
}
