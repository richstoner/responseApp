#!/usr/bin/python
### Rich Stoner, UCSD 2011
# --------------------
import json, os, glob, datetime, time, pprint

# List of all scenes to be viewed
scene_list = []

### Scene - Rest
# --------------------
# Scene settings
scene = {}
scene['name'] = 'Rest'
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

### Scene - Fixation
# --------------------
# Scene settings
scene = {}
scene['name'] = 'Preparation'
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

### Scene 2..n - Movement 
# --------------------
# Scene settings
scene = {}
scene['name'] = 'Movement'
scene['base_time'] = 200.0
scene['flex_time'] = 0.0
scene['trigger'] = 'touch'
scene_items = []

# Scene items
scene_item = {}
scene_item['shape'] = 'circle'
scene_item['id'] = 'touch target'
scene_item['color'] = 'blue'
scene_item['location'] = 'alternateHorizontalMidline'
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

### Generate file
# --------------------
# Settings for generated file
filename = 'example_trial.json'
foutput = open(filename,'w')
# Write file
foutput.write(json.dumps(scene_list))
foutput.close()

# Print console output
pprint.pprint(scene_list)

