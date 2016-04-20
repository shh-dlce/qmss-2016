import os
import json
import colorsys

def color(val, minval, maxval):
    h = (float(val-minval) / (maxval-minval)) * 120
    rgb = [hex(int(255 * x)) for x in colorsys.hsv_to_rgb(h/360, 1., 1.)]
    return ''.join(x[2:].upper().rjust(2, '0') for x in rgb)

def updated(d):
    precipitation = [float(f['properties']['precipitation']) for f in d['features']]
    for f in d['features']:
        props = f['properties']
        props['marker-size'] = 'small'
        props['marker-symbol'] = min([int(props['tones']), 9])
        props['marker-color'] = '#' + color(float(props['precipitation']), min(precipitation), max(precipitation))
    return d

with open(os.path.join('data', 'dataset.geojson')) as fp:
    d = json.load(fp)
with open(os.path.join('data', 'dataset2.geojson'), 'w') as fp:
    json.dump(updated(d), fp, indent=4)

