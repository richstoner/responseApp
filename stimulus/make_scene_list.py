#!/usr/bin/python
### Rich Stoner, UCSD 2011
# --------------------
import json, os, glob, datetime, time, pprint

# List of all scenes to be viewed
scene_list = []

### Scene 0 - Rest
# --------------------
# Scene settings
scene = {}
scene['name'] = '0 - Rest'
scene['base_time'] = 5.0
scene['flex_time'] = 0.0
scene['trigger'] = 'timer'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'fixation target'
scene_item['color'] = 'red'
scene_item['location'] = 'center'
scene_item['touchable'] = False
scene_item['hidden'] = False
scene_items.append(scene_item)

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['color'] = 'blue'
scene_item['location'] = 'randomHorizontalMidline'
scene_item['hidden'] = True
scene_item['touchable'] = True
scene_items.append(scene_item)


scene['items'] = scene_items
scene_list.append(scene)

### Scene 1 - Fixation
# --------------------
# Scene settings
scene = {}
scene['name'] = '1 - Preparation'
scene['base_time'] = 3.0
scene['flex_time'] = 2.0
scene['trigger'] = 'timer'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['color'] = 'blue'
scene_item['location'] = 'sameHorizontalMidline'
scene_item['hidden'] = False
scene_item['touchable'] = False
scene_items.append(scene_item)

scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'fixation target'
scene_item['location'] = 'center'
scene_item['color'] = 'red'
scene_item['hidden'] = False
scene_item['touchable'] = False
scene_items.append(scene_item)

scene['items'] = scene_items
scene_list.append(scene)

### Scene 2 - Movement 0
# --------------------
# Scene settings
scene = {}
scene['name'] = '2 - Movement 0'
scene['base_time'] = 200.0
scene['flex_time'] = 0.0
scene['trigger'] = 'touch'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['color'] = 'blue'
scene_item['location'] = 'sameHorizontalMidline'
scene_item['touchable'] = True
scene_item['hidden'] = False
scene_items.append(scene_item)

scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'fixation target'
scene_item['location'] = 'center'
scene_item['color'] = 'green'
scene_item['touchable'] = False
scene_item['hidden'] = False
scene_items.append(scene_item)

scene['items'] = scene_items
scene_list.append(scene)

### Scene 3 - Movement 1
# --------------------
# Scene settings
scene = {}
scene['name'] = '3 - Movement 1'
scene['base_time'] = 200.0
scene['flex_time'] = 0.0
scene['trigger'] = 'touch'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['color'] = 'blue'
scene_item['location'] = 'oppositeHorizontalMidline'
scene_item['touchable'] = True
scene_item['hidden'] = False
scene_items.append(scene_item)

scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'fixation target'
scene_item['location'] = 'center'
scene_item['color'] = 'green'
scene_item['touchable'] = False
scene_item['hidden'] = False
scene_items.append(scene_item)

scene['items'] = scene_items
scene_list.append(scene)

### Scene 4 - Movement 2
# --------------------
# Scene settings
scene = {}
scene['name'] = '4 - Movement 2'
scene['base_time'] = 200.0
scene['flex_time'] = 0.0
scene['trigger'] = 'touch'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['location'] = 'oppositeHorizontalMidline'
scene_item['color'] = 'blue'
scene_item['touchable'] = True
scene_item['hidden'] = False
scene_items.append(scene_item)

scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'fixation target'
scene_item['location'] = 'center'
scene_item['color'] = 'green'
scene_item['touchable'] = False
scene_item['hidden'] = False
scene_items.append(scene_item)

scene['items'] = scene_items
scene_list.append(scene)

### Scene 5 - Movement 3
# --------------------
# Scene settings
scene = {}
scene['name'] = '5 - Movement 3'
scene['base_time'] = 200.0
scene['flex_time'] = 0.0
scene['trigger'] = 'touch'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['location'] = 'oppositeHorizontalMidline'
scene_item['color'] = 'blue'
scene_item['touchable'] = True
scene_item['hidden'] = False
scene_items.append(scene_item)

scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'fixation target'
scene_item['location'] = 'center'
scene_item['color'] = 'green'
scene_item['touchable'] = False
scene_item['hidden'] = False
scene_items.append(scene_item)

scene['items'] = scene_items
scene_list.append(scene)

### Scene 6 - Movement 4
# --------------------
# Scene settings
scene = {}
scene['name'] = '6 - Movement 4'
scene['base_time'] = 200.0
scene['flex_time'] = 0.0
scene['trigger'] = 'touch'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['location'] = 'oppositeHorizontalMidline'
scene_item['color'] = 'blue'
scene_item['touchable'] = True
scene_item['hidden'] = False
scene_items.append(scene_item)

scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'fixation target'
scene_item['location'] = 'center'
scene_item['color'] = 'green'
scene_item['touchable'] = False
scene_item['hidden'] = False
scene_items.append(scene_item)

scene['items'] = scene_items
scene_list.append(scene)

### Scene 7 - Rest
# --------------------
# Scene settings
scene = {}
scene['name'] = '7 - Rest'
scene['base_time'] = 5.0
scene['flex_time'] = 0.0
scene['trigger'] = 'timer'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'fixation target'
scene_item['color'] = 'red'
scene_item['location'] = 'center'
scene_item['touchable'] = False
scene_item['hidden'] = False
scene_items.append(scene_item)

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['color'] = 'blue'
scene_item['location'] = 'randomHorizontalMidline'
scene_item['hidden'] = True
scene_item['touchable'] = True
scene_items.append(scene_item)


scene['items'] = scene_items
scene_list.append(scene)


### Generate file
# --------------------
# Settings for generated file
filename = 'exampled_trial.json'
foutput = open(filename,'w')
# Write file
foutput.write(json.dumps(scene_list))
foutput.close()

# Print console output
pprint.pprint(scene_list)

