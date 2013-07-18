/*
 * Copyright (C) 2013 Canonical, Ltd.
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
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../../Components"

Column {
    id: root

    property var model

    signal sendReview(string review)

    spacing: units.gu(1)
    state: ""

    states: [
        State {
            name: ""
            PropertyChanges { target: sendButton; opacity: 0; }
            PropertyChanges { target: reviewField; width: root.width; }
        },
        State {
            name: "editing"
            PropertyChanges { target: reviewField; width: (root.width - row.spacing - sendButton.width); }
            PropertyChanges { target: sendButton; opacity: 1; }
        }
     ]

    transitions: [
        Transition {
            from: ""
            to: "editing"
            SequentialAnimation {
                UbuntuNumberAnimation { target: reviewField; properties: "width"; duration: UbuntuAnimation.SlowDuration }
                UbuntuNumberAnimation { target: sendButton; properties: "opacity"; duration: UbuntuAnimation.SlowDuration }
            }
        },
        Transition {
            from: "editing"
            to: ""
            SequentialAnimation {
                UbuntuNumberAnimation { target: sendButton; properties: "opacity"; duration: UbuntuAnimation.SlowDuration }
                UbuntuNumberAnimation { target: reviewField; properties: "width"; duration: UbuntuAnimation.SlowDuration }
            }
        }
    ]

    Label {
        fontSize: "medium"
        color: "white"
        style: Text.Raised
        styleColor: "black"
        opacity: .9
        text: i18n.tr("Add a review")
    }

    Row {
        id: row
        spacing: units.gu(1)
        width: root.width
        height: childrenRect.height

        TextField {
            id: reviewField
            placeholderText: i18n.tr("Review")
            width: parent.width
            height: units.gu(5)

            onFocusChanged: {
                root.state = "editing";
            }
        }

        Button {
            id: sendButton
            width: units.gu(10)
            color: Theme.palette.selected.foreground
            text: i18n.tr("Send")
            opacity: 0

            onClicked: {
                root.sendReview(reviewField.text);
                root.state = "";
            }
        }
    }

    ListItem.ThinDivider {}

    Column {
        width: parent.width
        height: childrenRect.height
        spacing: units.gu(2)

        Label {
            fontSize: "medium"
            color: "white"
            style: Text.Raised
            styleColor: "black"
            opacity: .9
            text: i18n.tr("Comments:")
        }

        Repeater {
            model: root.model

            Column {
                width: root.width
                height: childrenRect.height
                Column {
                    Label {
                        text: "" // FROM PREVIEW DATA (FIXME: need scope format data)
                        fontSize: "medium"
                        color: "white"
                        opacity: .8
                        wrapMode: Text.WordWrap
                        style: Text.Raised
                        styleColor: "black"
                    }
                    Row {
                        spacing: units.gu(1)
                        RatingStars {
                            maximumRating: 10
                            rating: 0 // FROM PREVIEW DATA (FIXME: need scope format data)
                        }
                        Label {
                            text: "" // FROM PREVIEW DATA (FIXME: need scope format data)
                            fontSize: "medium"
                            color: "#f3f3e7"
                            opacity: .6
                            style: Text.Raised
                            styleColor: "black"
                        }
                    }
                }
                Label {
                    text: "" // FROM PREVIEW DATA (FIXME: need scope format data)
                    fontSize: "medium"
                    color: "#f3f3e7"
                    opacity: .6
                    width: root.width
                    wrapMode: Text.WordWrap
                    style: Text.Raised
                    styleColor: "black"
                }
            }
        }
    }
}
