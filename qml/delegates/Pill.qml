// SPDX-FileCopyrightText: 2021 Nheko Contributors
// SPDX-FileCopyrightText: 2022 Nheko Contributors
//
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.5
import QtQuick.Controls 2.1
import im.nheko

Label {
    property bool isStateEvent

    color: timelineRoot.palette.text
    height: Math.round(fontMetrics.height * 1.4)
    horizontalAlignment: Text.AlignHCenter
    width: contentWidth * 1.2

    background: Rectangle {
        color: timelineRoot.palette.alternateBase
        radius: parent.height / 2
    }
}
