import plotex as ptx

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
from PIL import Image




def make_colorbar(colors, names):
    #fig, ax = ptx.newfig(.7)
    fig = plt.figure(figsize=(8, 1))
    ax = fig.add_axes([0.05, 0.15, 0.9, 0.15])
    cmap = mpl.colors.ListedColormap(colors[:9])
    cmap.set_over(colors[9])

    bounds = np.array(range(10))
    ticks = np.array(range(10)) - 0.5
    norm = mpl.colors.BoundaryNorm(bounds, cmap.N)
    cb = mpl.colorbar.ColorbarBase(ax, cmap=cmap,
                                    norm=norm,
                                    extend='max',
                                    ticks = ticks,
                                    extendfrac=None, #'auto',
                                    orientation='horizontal')
    cb.ax.set_xticklabels(names)

    ptx.savefig('/home/hale/colorbar')
    #plt.show()

names = ['grass', 'ground', 'pavement', 'hedge', 'topiary', 'rose', 'obstacle', 'tree', 'background', 'unknown']
im = Image.open('/home/hale/Datasets/3DRMS/cropped/training/train_boxwood_row/uvc_camera_cam_0/uvc_camera_cam_0_f00090_gtr.png')
palette = im.getpalette()

colors = []
for i in range(10):
    colors.append([palette[i*3] / 255.0, palette[i*3+1] / 255.0, palette[i*3+2] / 255.0])

make_colorbar(colors, names)
