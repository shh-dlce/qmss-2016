import os
import re


def sub(c): 
    return re.sub(' href\="(?P<name>[^\.]+)\.md"', lambda m: ' href="%s.html"' % m.group('name'), c)


def main(f):
    html = f.replace('.md', '.html')
    name = f.split('.')[0]
    if name == 'README':
        name = ''
    else:
        name = ': ' + name.replace('-', ' ')
    os.system('grip --title="QMSS 2016 - SQL Tutorial%s" --export %s' % (name, f))
    c = open(html).read()
    with open(html, 'w') as fp:
        fp.write(sub(c))


if __name__ == '__main__':
    for f in os.listdir('.'):
        if f.endswith('.md'):
            main(f)

