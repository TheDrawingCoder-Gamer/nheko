// SPDX-FileCopyrightText: 2022 Nheko Contributors
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.2
import QtQuick.Window 2.15
import im.nheko
import "../components"
import "../ui"
import "../"

Item {
    id: loginPage

    property string error: login.error
    property int maxExpansion: 400

    Login {
        id: login
    }
    ScrollView {
        id: scroll
        ScrollBar.horizontal.visible: false
        anchors.left: parent.left
        anchors.margins: Nheko.paddingLarge
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        clip: false
        contentWidth: availableWidth
        height: Math.min(loginPage.height, col.implicitHeight)
        palette: timelineRoot.palette

        ColumnLayout {
            id: col
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Nheko.paddingMedium
            width: Math.min(loginPage.maxExpansion, scroll.width - Nheko.paddingLarge * 2)

            Image {
                Layout.alignment: Qt.AlignHCenter
                height: 128
                source: "qrc:/logos/login.png"
                width: 128
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Nheko.paddingLarge

                MatrixTextField {
                    id: matrixIdLabel
                    Keys.forwardTo: [pwBtn, ssoRepeater]
                    ToolTip.text: qsTr("Your login name. A mxid should start with @ followed by the user id. After the user id you need to include your server name after a :.\nYou can also put your homeserver address there, if your server doesn't support .well-known lookup.\nExample: @user:server.my\nIf Nheko fails to discover your homeserver, it will show you a field to enter the server manually.")
                    label: qsTr("Matrix ID")
                    placeholderText: qsTr("e.g @joe:matrix.org")

                    onEditingFinished: login.mxid = text
                }
                Spinner {
                    Layout.alignment: Qt.AlignBottom
                    foreground: timelineRoot.palette.mid
                    height: matrixIdLabel.height / 2
                    running: login.lookingUpHs
                    visible: running
                }
            }
            MatrixText {
                color: Nheko.theme.error
                text: login.mxidError
                textFormat: Text.PlainText
                visible: text
            }
            MatrixTextField {
                id: passwordLabel
                Keys.forwardTo: [pwBtn, ssoRepeater]
                Layout.fillWidth: true
                ToolTip.text: qsTr("Your password.")
                echoMode: TextInput.Password
                label: qsTr("Password")
                visible: login.passwordSupported
            }
            MatrixTextField {
                id: deviceNameLabel
                Keys.forwardTo: [pwBtn, ssoRepeater]
                Layout.fillWidth: true
                ToolTip.text: qsTr("A name for this device, which will be shown to others, when verifying your devices. If none is provided a default is used.")
                label: qsTr("Device name")
                placeholderText: login.initialDeviceName()
            }
            MatrixTextField {
                id: hsLabel
                Keys.forwardTo: [pwBtn, ssoRepeater]
                Layout.fillWidth: true
                ToolTip.text: qsTr("The address that can be used to contact you homeservers client API.\nExample: https://server.my:8787")
                enabled: visible
                label: qsTr("Homeserver address")
                placeholderText: qsTr("server.my:8787")
                text: login.homeserver
                visible: login.homeserverNeeded

                onEditingFinished: login.homeserver = text
            }
            Item {
                Layout.fillWidth: true
                height: Nheko.avatarSize

                Spinner {
                    anchors.centerIn: parent
                    foreground: timelineRoot.palette.mid
                    height: parent.height
                    running: login.loggingIn
                    visible: running
                }
            }
            MatrixText {
                color: Nheko.theme.error
                text: loginPage.error
                textFormat: Text.PlainText
                visible: text
            }
            FlatButton {
                id: pwBtn
                function pwLogin() {
                    login.onLoginButtonClicked(Login.Password, matrixIdLabel.text, passwordLabel.text, deviceNameLabel.text);
                }

                Keys.enabled: pwBtn.enabled && login.passwordSupported
                Layout.alignment: Qt.AlignHCenter
                enabled: login.homeserverValid && matrixIdLabel.text == login.mxid && login.homeserver == hsLabel.text
                text: qsTr("LOGIN")
                visible: login.passwordSupported

                Keys.onEnterPressed: pwBtn.pwLogin()
                Keys.onReturnPressed: pwBtn.pwLogin()
                onClicked: pwBtn.pwLogin()
            }
            Repeater {
                id: ssoRepeater
                model: login.identityProviders

                delegate: FlatButton {
                    id: ssoBtn
                    function ssoLogin() {
                        login.onLoginButtonClicked(Login.SSO, matrixIdLabel.text, modelData.id, deviceNameLabel.text);
                    }

                    Keys.enabled: ssoBtn.enabled && !login.passwordSupported
                    Layout.alignment: Qt.AlignHCenter
                    enabled: login.homeserverValid && matrixIdLabel.text == login.mxid && login.homeserver == hsLabel.text
                    iconImage: modelData.avatarUrl.replace("mxc://", "image://MxcImage/")
                    text: modelData.name
                    visible: login.ssoSupported

                    Keys.onEnterPressed: ssoBtn.ssoLogin()
                    Keys.onReturnPressed: ssoBtn.ssoLogin()
                    onClicked: ssoBtn.ssoLogin()
                }
            }
        }
    }
    ImageButton {
        ToolTip.text: qsTr("Back")
        ToolTip.visible: hovered
        anchors.left: parent.left
        anchors.margins: Nheko.paddingMedium
        anchors.top: parent.top
        height: Nheko.avatarSize
        image: ":/icons/icons/ui/angle-arrow-left.svg"
        width: Nheko.avatarSize

        onClicked: mainWindow.pop()
    }
}
