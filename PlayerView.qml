import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Window 2.0
import QtMultimedia 5.12


import Qt.labs.folderlistmodel 2.12

ApplicationWindow {


    FolderListModel {
        id: fm
        showDirs: false
        showDirsFirst: false
        folder: "file:" +  "G:/Users/user/Desktop/music"

        nameFilters: ["*.mp3"]
    }
    function updateFilter()
        {
            var text = filterFeild.text
            var filter = "*"
            for(var i = 0; i<text.length; i++)
                if(!sensitiveCheckbox.checked)
                    filter+= "[%1%2]".arg(text[i].toUpperCase()).arg(text[i].toLowerCase())
                else
                    filter+= text[i]
            filter+="*mp3"
            //print(filter)
            fm.nameFilters = [filter]
        }
    Component {
        id:fileDelegate
        Text {text:fileName}
    }




    MediaPlayer{
        id:player



    }

    id: window
    width: 1280
    height: 720
    property alias playlistView: playlistView
    visible: true
    title: "Qt Quick Controls 2 - Imagine Style Example: Music Player"

    Component.onCompleted: {
        x = Screen.width / 2 - width / 2
        y = Screen.height / 2 - height / 2
    }

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: Qt.quit()
    }

    header: ToolBar {
    }

    RowLayout {
        anchors.leftMargin: 64
        anchors.rightMargin: 17
        spacing: 116.1
        anchors.fill: parent
        anchors.margins: 70

        ColumnLayout {
            spacing: 26
            Layout.preferredWidth: 230

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: "Photo/Furukawa Nagisa.jpg"
                }
            }

            Item {
                id: songLabelContainer
                clip: true

                Layout.fillWidth: true
                Layout.preferredHeight: songNameLabel.implicitHeight

                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite

                    PauseAnimation {
                        duration: 2000
                    }
                    ParallelAnimation {
                        XAnimator {
                            target: songNameLabel
                            from: 0
                            to: songLabelContainer.width //- songNameLabel.implicitWidth
                            duration: 5000
                        }
                        OpacityAnimator {
                            target: leftGradient
                            from: 0
                            to: 1
                        }
                    }
                    OpacityAnimator {
                        target: rightGradient
                        from: 1
                        to: 0
                    }
                    PauseAnimation {
                        duration: 1000
                    }
                    OpacityAnimator {
                        target: rightGradient
                        from: 0
                        to: 1
                    }
                    ParallelAnimation {
                        XAnimator {
                            target: songNameLabel
                            from: songLabelContainer.width - songNameLabel.implicitWidth
                            to: 0
                            duration: 5000
                        }
                        OpacityAnimator {
                            target: leftGradient
                            from: 0
                            to: 1
                        }
                    }
                    OpacityAnimator {
                        target: leftGradient
                        from: 1
                        to: 0
                    }
                }

                Rectangle {
                    id: leftGradient
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#dfe4ea"
                        }
                        GradientStop {
                            position: 1
                            color: "#00dfe4ea"
                        }
                    }

                    width: height
                    height: parent.height
                    anchors.left: parent.left
                    z: 1
                    rotation: -90
                    opacity: 0
                }

                Label {
                    id: songNameLabel
                    text: fm.get(playlistView.currentIndex,"fileName")
                    font.pixelSize: Qt.application.font.pixelSize * 1.4
                }

                Rectangle {
                    id: rightGradient
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#00dfe4ea"
                        }
                        GradientStop {
                            position: 1
                            color: "#dfe4ea"
                        }
                    }

                    width: height
                    height: parent.height
                    anchors.right: parent.right
                    rotation: -90
                }
            }

            RowLayout {
                spacing: 8
                Layout.alignment: Qt.AlignHCenter
                Button {
                    text: qsTr("Prev")
                    onClicked: playlistView.decrementCurrentIndex()
                    ,player.source = fm.get(playlistView.currentIndex,"filePath"),player.play(),
                    songNameLabel.text =  fm.get(playlistView.currentIndex,"fileName")
                    Layout.fillWidth: true
                }
                Button {
                    text: qsTr("Next")
                    onClicked: playlistView.incrementCurrentIndex()
                    ,player.source = fm.get(playlistView.currentIndex,"filePath"),player.play(),
                    songNameLabel.text =  fm.get(playlistView.currentIndex,"fileName")
                    Layout.fillWidth: true

                }





                Button {
                    text: qsTr("Pause")
                   onClicked:
                       if(player.hasAudio) {

                           switch(player.playbackState){

                              case MediaPlayer.PlayingState:
                              player.pause()

                              break

                              case MediaPlayer.PausedState:
                              player.play()

                              break
                           }
                }
                }
                Button {
                   text: qsTr("Random")
                    onClicked: playlistView.currentIndex = Math.floor(Math.random()*playlistView.count),
                    player.source = fm.get(playlistView.currentIndex,"filePath"),player.play(),
                    songNameLabel.text =  fm.get(playlistView.currentIndex,"fileName")
                }

            }

            Slider {
                id: seekSlider
                from: 0
                to: player.duration


                Layout.fillWidth: true
                     onMoved:
                    if(player.hasAudio && player.seekable){
                      // print(player.position)
                      //  print(seekSlider.value)

                       player.seek(seekSlider.value)

                    }
                  value: player.position

                Slider {
                    id: slider
                    x: -60
                    y: -160
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    Layout.fillWidth: false
                    Layout.fillHeight: false
                    orientation: Qt.Vertical
                    layer.textureMirroring: ShaderEffectSource.MirrorVertically
                    wheelEnabled: false
                    value: 0.5

                }

                ToolTip {
                    parent: seekSlider.handle
                    visible: seekSlider.pressed
                    text: pad(Math.floor(value / 1800))
                    y: parent.height

                    readonly property int value: seekSlider.valueAt(seekSlider.position)

                    function pad(number) {
                        if (number <= 9)
                            return "0" + number;
                        return number;
                    }
                }

            }
        }

        ColumnLayout {
            spacing: 16
            Layout.preferredWidth: 230

            ButtonGroup {
                buttons: libraryRowLayout.children
            }

            RowLayout {
                id: libraryRowLayout
                spacing: 6
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: "Files"
                    Layout.fillWidth: true
                    highlighted: false
                    checked: true
                }
            }

            RowLayout {
                TextField {
                    id: filterFeild
                    onTextChanged: updateFilter()
                    Layout.fillWidth: true
                }
                CheckBox {
                    id:sensitiveCheckbox
                    onCheckedChanged: updateFilter()

                    icon.name: "folder"
                }
            }

            Frame {
                id: filesFrame
                width: 340
                height: 340
                leftPadding: 1
                rightPadding: 1

                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: playlistView
                    width: 144
                    height: 422
                    anchors.bottomMargin: -11
                    anchors.rightMargin: 0
                    anchors.topMargin: -12
                    anchors.fill: parent
                    spacing: 30
                    Layout.fillWidth: true

                    // Layout.preferredWidth: -1
                    implicitWidth: 250
                    implicitHeight: 250
                    clip: true

                    model: fm


                    delegate:   RowLayout {
                        width: playlistView.widthL

                        /*Image {
                            id: name

                            source: model.photopath
                            Layout.preferredHeight: 100
                            Layout.preferredWidth: 100
                        }*/
                        MouseArea{
                            id:area
                            width: 313
                            height: 50



                            anchors.fill: parent
                            onPressed: player.source = filePath,player.play(),
                            print(playlistView.currentIndex =
                            playlistView.indexAt(area.mouseX,area.mouseY)),
                            print("mouse X is " + " " + area.mouseX ),
                            print("mouse Y is " + " " + area.mouseY ),
                            songNameLabel.text = fileName
                        }
                            Text {
                                text: fileName
                                font.pointSize: 12
                                font.family: "Arial"
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                transformOrigin: Item.Center
                                verticalAlignment: Text.AlignVCenter
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                fontSizeMode: Text.HorizontalFit
                                textFormat: Text.AutoText
                                horizontalAlignment: Text.AlignHCenter

                            }


                        }

                        ScrollBar.vertical: ScrollBar {
                            parent: filesFrame
                            policy: ScrollBar.AlwaysOn
                            anchors.top: parent.top
                            anchors.topMargin: filesFrame.topPadding
                            anchors.right: parent.right
                            anchors.rightMargin: 1
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: filesFrame.bottomPadding
                        }

                    }
                }
            }
        }
    }

    /*##^##
Designer {
    D{i:50;anchors_height:403;anchors_width:466;anchors_x:"-1";anchors_y:-12}
}
##^##*/
