/*
 * Copyright 2014 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtTest 1.0
import "../../../../qml/Dash/Previews"
import Unity.Test 0.1 as UT

Rectangle {
    id: root
    width: units.gu(40)
    height: units.gu(80)
    color: "lightgrey"

    property var widgetData0: {
        "source": ""
    }

    property var widgetData1: {
        "source": "../../graphics/phone_background.jpg",
        "zoomable": false
    }

    PreviewImage {
        id: image
        width: parent.width
        widgetData: widgetData1
    }

    UT.UnityTestCase {
        name: "PreviewImageTest"
        when: windowShown

        function test_loadImage() {
            var lazyImage = findChild(image, "lazyImage");

            image.widgetData = widgetData0;
            tryCompare(lazyImage.state, "default");

            image.widgetData = widgetData1;
            tryCompare(lazyImage.state, "ready");
        }
    }
}
