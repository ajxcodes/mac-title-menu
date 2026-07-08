#!/usr/bin/env python3
import sys
import dbus


def find_about(item_tuple):
    item_id, properties, children = item_tuple
    
    label = str(properties.get("label", "")).lower()
    icon_name = str(properties.get("icon-name", "")).lower()
    
    # Strip accelerators like &About
    label = label.replace("&", "").replace("_", "")
    
    # Check if this item is exactly "about" or starts with "about " (e.g. "About KDE")
    if "about" in label or "about" in icon_name:
        return item_id
        
    for child in children:
        found = find_about(child)
        if found is not None:
            return found
            
    return None

def main():
    if len(sys.argv) < 3:
        sys.exit(1)
        
    service = sys.argv[1]
    path = sys.argv[2]
    
    try:
        bus = dbus.SessionBus()
        obj = bus.get_object(service, path)
        interface = dbus.Interface(obj, 'com.canonical.dbusmenu')
        
        # Get full layout: parentId=0, recursionDepth=-1, propertyNames=["label", "icon-name"]
        revision, layout = interface.GetLayout(0, -1, ["label", "icon-name"])
        
        about_id = find_about(layout)
        if about_id is not None:
            # Event takes: id (int32), eventId (string), data (variant), timestamp (uint32)
            try:
                interface.Event(about_id, "clicked", dbus.String("", variant_level=1), 0)
            except Exception as e:
                # Some legacy apps might reject the standard variant_level=1 signature
                interface.Event(about_id, "clicked", "", 0)
            print("SUCCESS")
            sys.exit(0)
        else:
            print("NOT_FOUND")
            sys.exit(1)
    except Exception as e:
        print("ERROR")
        sys.exit(2)

if __name__ == "__main__":
    main()
