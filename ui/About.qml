/*
  This file is part of uInzoZGz
  Copyright (C) 2015 Ricardo Sáez

    This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License 3 as published by
  the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.
*/
import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Page {
    id: aboutPage

    title: i18n.tr("About")
    head.sections.model: [i18n.tr("About"), i18n.tr("Credits")]

    property string version

    Loader {
        id: view

        anchors {
            fill: parent
            margins: units.gu(2)
        }

        sourceComponent: {
            if (aboutPage.head.sections.selectedIndex == 0)
                return aboutSection

            if (aboutPage.head.sections.selectedIndex == 1)
                return creditSection

            if (aboutPage.head.sections.selectedIndex == 2)
                return copyrightSection
        }
    }

    // ABOUT SECTION
    Component {
        id: aboutSection
        Column {
            anchors.centerIn: parent
            width: root.width > units.gu(50) ? units.gu(50) : parent.width
            spacing: units.gu(4)

            UbuntuShape {
                id: logo

                width: root.width > units.gu(50) ? units.gu(25) : parent.width / 2
                height: width
                radius: "medium"

                image: Image {
                    source: "../uInfoZgz.png"
                }

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Column {
                width: parent.width

                Label {
                    fontSize: "x-large"
                    font.weight: Font.DemiBold
                    text: "Info Zgz UbPhone"

                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    // TRANSLATORS: Version of the software (e.g. "Version 0.3.51")
                    text: i18n.tr("Version ") + aboutPage.version

                    anchors.horizontalCenter: parent.horizontalCenter

                    Component.onCompleted: {
                        // Extract version info from manifest.json
                        var doc = new XMLHttpRequest();
                        var json_string;
                        doc.onreadystatechange = function() {
                            if (doc.readyState == XMLHttpRequest.DONE) {
                                json_string = doc.responseText;

                                if (json_string) {
                                    var obj = JSON.parse(json_string)
                                    aboutPage.version = obj.version
                                } else {
                                    /* TRANSLATORS: This is shown where it's impossible to get
                                      the version number (e.g. "Version UNKNOWN") */
                                    aboutPage.version = i18n.tr("UNKNOWN")
                                }
                            }
                        }
                        doc.open("get", Qt.resolvedUrl("../manifest.json"));

                        doc.setRequestHeader("Content-Encoding", "UTF-8");
                        doc.send();
                    }
                }
            }

            Column {
                width: parent.width

                Label {
                    text: "(C) 2015 Ricardo Sáez"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    fontSize: "small"
                    text: i18n.tr("Released under the terms of the GNU GPL v3")

                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Column {
                width: parent.width
                spacing: units.gu(2)

                Label {
                    fontSize: "small"
                    text: i18n.tr("Source code available on ") + "<a href=\"https://launchpad.net/uInfoZgz\">launchpad.net</a>"

                    anchors.horizontalCenter: parent.horizontalCenter

                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }
        }
    }   // END ABOUT SECTION

    // CREDITS SECTION
    Component {
        id: creditSection

        Column {
            anchors.fill: parent
            width: root.width > units.gu(50) ? units.gu(50) : parent.width

            ListItem.Header {
                text: i18n.tr("A big thanks to:")
            }

            ListItem.Subtitled {
                text: "Ayto Zaragoza"
                subText: "For public info Api"
            }

        }
    }   // END CREDIT SECTION

  }
