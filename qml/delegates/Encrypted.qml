// SPDX-FileCopyrightText: 2021 Nheko Contributors
// SPDX-FileCopyrightText: 2022 Nheko Contributors
//
// SPDX-License-Identifier: GPL-3.0-or-later

import "../"
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import im.nheko

Rectangle {
    id: r

    required property int encryptionError
    required property string eventId

    color: timelineRoot.palette.alternateBase
    height: contents.implicitHeight + Nheko.paddingMedium * 2
    implicitWidth: encryptedText.implicitWidth + 24 + Nheko.paddingMedium * 3 // Column doesn't provide a useful implicitWidth, should be replaced by ColumnLayout
    radius: fontMetrics.lineSpacing / 2 + Nheko.paddingMedium
    width: parent.width ? parent.width : 0

    RowLayout {
        id: contents
        anchors.fill: parent
        anchors.margins: Nheko.paddingMedium
        spacing: Nheko.paddingMedium

        Image {
            Layout.alignment: Qt.AlignVCenter
            height: width
            source: "image://colorimage/:/icons/icons/ui/shield-filled-cross.svg?" + Nheko.theme.error
            width: 24
        }
        Column {
            Layout.fillWidth: true
            spacing: Nheko.paddingSmall

            MatrixText {
                id: encryptedText
                color: timelineRoot.palette.text
                text: {
                    switch (encryptionError) {
                    case Olm.MissingSession:
                        return qsTr("There is no key to unlock this message. We requested the key automatically, but you can try requesting it again if you are impatient.");
                    case Olm.MissingSessionIndex:
                        return qsTr("This message couldn't be decrypted, because we only have a key for newer messages. You can try requesting access to this message.");
                    case Olm.DbError:
                        return qsTr("There was an internal error reading the decryption key from the database.");
                    case Olm.DecryptionFailed:
                        return qsTr("There was an error decrypting this message.");
                    case Olm.ParsingFailed:
                        return qsTr("The message couldn't be parsed.");
                    case Olm.ReplayAttack:
                        return qsTr("The encryption key was reused! Someone is possibly trying to insert false messages into this chat!");
                    default:
                        return qsTr("Unknown decryption error");
                    }
                }
                width: parent.width
            }
            Button {
                palette: timelineRoot.palette
                text: qsTr("Request key")
                visible: encryptionError == Olm.MissingSession || encryptionError == Olm.MissingSessionIndex

                onClicked: room.requestKeyForEvent(eventId)
            }
        }
    }
}
