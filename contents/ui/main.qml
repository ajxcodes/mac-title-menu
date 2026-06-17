import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.taskmanager       as TaskManager
import org.kde.kirigami          as Kirigami
import org.kde.activities        as Activities
import "../tools/Tools.js"       as Tools

PlasmoidItem {
    id: root
    Plasmoid.constraintHints:   Plasmoid.CanFillArea
    Plasmoid.backgroundHints:   root.expanded ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground
    preferredRepresentation:    Plasmoid.compactRepresentation

    property int titleImplicitWidth: 100
    property int titleImplicitHeight: 20

    readonly property bool isVertical:              plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool existsWindowActive:      windowInfoLoader.item && windowInfoLoader.item.existsWindowActive
    readonly property bool isActiveWindowPinned:    existsWindowActive && activeTaskItem.isOnAllDesktops
    readonly property bool isActiveWindowMaximized: existsWindowActive && activeTaskItem.isMaximized
    readonly property var cfg:                      plasmoid.configuration
    property bool isAboutOpen:                      aboutWindow.visible
    property alias macAppMenuPopup:                 macAppMenuPopup

    property Item activeTaskItem:                   windowInfoLoader.item.activeTaskItem
    property var icon:                              Tools.getIcon()
    property string text:                           Tools.getText()
    states: [
        State{
            name: "editMode"
            when:  Plasmoid.containment.corona?.editMode?true:false
            PropertyChanges{
                target: root
                text:   "Edit Mode"
                icon:   "document-edit"
                Layout.minimumWidth: isVertical?parent.width:root.titleImplicitWidth
                Layout.maximumWidth: Layout.minimumWidth
                Layout.minimumHeight: isVertical?root.titleImplicitHeight:parent.height
                Layout.maximumHeight: Layout.minimumHeight
            }
        },
        State{
            name: "contentsLength"
            when: cfg.lengthKind === 0 && !isVertical
            PropertyChanges{
                target: root
                Layout.minimumWidth: root.titleImplicitWidth
                Layout.maximumWidth: Layout.minimumWidth
                Layout.fillHeight:   true
            }
        },
        State{
            name: "fixedLength"
            when: cfg.lengthKind === 1 && !isVertical
            PropertyChanges{
                target: root
                Layout.minimumWidth: cfg.fixedLength
                Layout.maximumWidth: cfg.fixedLength
                Layout.fillHeight:   true
            }
        },
        State{
            name: "maximumLength"
            when: cfg.lengthKind === 2 && !isVertical
            PropertyChanges{
                target: root
                Layout.minimumWidth: Math.min(cfg.fixedLength,root.titleImplicitWidth)
                Layout.maximumWidth: Math.min(cfg.fixedLength,root.titleImplicitWidth)
                Layout.fillHeight:   true
            }
        },
        State{
            name: "contentsLengthVert"
            when: cfg.lengthKind === 0 && isVertical
            PropertyChanges{
                target: root
                Layout.minimumHeight: root.titleImplicitHeight
                Layout.maximumHeight: Layout.minimumHeight
                Layout.fillWidth:     true
            }
        },
        State{
            name: "fixedLengthVert"
            when: cfg.lengthKind === 1 && isVertical
            PropertyChanges{
                target: root
                Layout.minimumHeight: cfg.fixedLength
                Layout.maximumHeight: cfg.fixedLength
                Layout.fillWidth:     true
            }
        },
        State{
            name: "maximumLengthVert"
            when: cfg.lengthKind === 2 && isVertical
            PropertyChanges{
                target: root
                Layout.minimumHeight: Math.min(cfg.fixedLength,root.titleImplicitHeight)
                Layout.maximumHeight: Math.min(cfg.fixedLength,root.titleImplicitHeight)
                Layout.fillWidth:     true
            }
        }
    ]

    TaskManager.ActivityInfo { id: activityInfo }
    Activities.ActivityInfo { id: fullActivityInfo; activityId: ":current" }
    TaskManager.VirtualDesktopInfo { id: virtualDesktopInfo }
    Loader {
        id: windowInfoLoader
        sourceComponent: plasmaTasksModel
        Component{
            id: plasmaTasksModel
            PlasmaTasksModel{}
        }
    }
    Title { 
        id: titleLayout
        onImplicitWidthChanged: root.titleImplicitWidth = implicitWidth
        onImplicitHeightChanged: root.titleImplicitHeight = implicitHeight
    }
    ActionsMouseArea {}

    PlasmaExtras.Menu {
        id: macAppMenuPopup
        visualParent: root

        PlasmaExtras.MenuItem {
            text: i18n("About %1", root.activeTaskItem ? root.activeTaskItem.appName : "")
            onClicked: Qt.callLater(function(){
                aboutWindow.targetAppName = root.activeTaskItem ? root.activeTaskItem.appName : "Mac App Menu";
                aboutWindow.targetTitle = root.text;
                aboutWindow.targetIcon = root.icon;
                aboutWindow.visible = true;
                aboutWindow.requestActivate();
            })
        }
        PlasmaExtras.MenuItem { separator: true }

        PlasmaExtras.MenuItem {
            text: root.activeTaskItem && root.activeTaskItem.isMinimized ? i18n("Restore") : i18n("Minimize")
            onClicked: Qt.callLater(function(){
                if(existsWindowActive) windowInfoLoader.item.toggleMinimized();
            })
        }

        PlasmaExtras.MenuItem {
            text: root.activeTaskItem && root.activeTaskItem.isMaximized ? i18n("Restore") : i18n("Maximize")
            onClicked: Qt.callLater(function(){
                if(existsWindowActive) windowInfoLoader.item.toggleMaximized();
            })
        }

        PlasmaExtras.MenuItem {
            text: i18n("Keep Above")
            onClicked: Qt.callLater(function(){
                if(existsWindowActive) windowInfoLoader.item.toggleKeepAbove();
            })
        }

        PlasmaExtras.MenuItem {
            text: i18n("Pin to all Desktops")
            onClicked: Qt.callLater(function(){
                if(existsWindowActive) windowInfoLoader.item.togglePinToAllDesktops();
            })
        }
        PlasmaExtras.MenuItem { separator: true }

        PlasmaExtras.MenuItem {
            text: i18n("Close")
            onClicked: Qt.callLater(function(){
                if(existsWindowActive) windowInfoLoader.item.requestClose();
            })
        }
    }
    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        active: text !== ""
        interactive: true
        location: plasmoid.location
        visible: cfg.showTooltip
        mainItem: RowLayout {
            spacing:                    Kirigami.Units.largeSpacing
            Layout.margins:             Kirigami.Units.smallSpacing
            Kirigami.Icon {
                source: root.icon
            }
            PlasmaComponents.Label {
                id: fullText
                elide:Text.ElideRight
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
                text:root.text
            }
        }
    }

    Window {
        id: aboutWindow
        
        property string targetAppName: "Mac App Menu"
        property string targetTitle: ""
        property var targetIcon: ""

        title: i18n("About %1", targetAppName)
        width: Kirigami.Units.gridUnit * 18
        height: aboutLayout.implicitHeight + Kirigami.Units.largeSpacing * 2
        x: Screen.width / 2 - width / 2
        y: Screen.height / 2 - height / 2
        color: Kirigami.Theme.backgroundColor
        flags: Qt.Dialog | Qt.WindowCloseButtonHint | Qt.WindowTitleHint

        ColumnLayout {
            id: aboutLayout
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Kirigami.Units.iconSizes.huge
                Layout.preferredHeight: Kirigami.Units.iconSizes.huge
                source: aboutWindow.targetIcon
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: aboutWindow.targetAppName
                font.bold: true
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.5
            }

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: aboutWindow.targetTitle
                elide: Text.ElideRight
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.7
            }

            Item { Layout.fillHeight: true } // Spacer

            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignHCenter
                text: i18n("Close")
                onClicked: aboutWindow.visible = false
            }
        }
    }
}
