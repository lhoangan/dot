import plotex as ptx # must always be imported before matplotlib

import numpy as np
import matplotlib.pyplot as plt



def data_1():
    '''
        Baseline results of SegNet trained on RGB gardynM
        Date: Sep 18, 2017
    '''

    vals = dict()
    vals['clear'] = [73.01,  42.97, 32.64]
    vals['overcast'] = [69.27, 45.85, 33.31]
    vals['sunset'] = [58.52, 34.60, 21.73]
    vals['fall'] = [74.28, 46.83, 35.26]

    cats = vals.keys()
    groups = ['Global', 'Class', 'mIOU']
    xlabel = 'Metrics'
    ylabel = 'Accuracy (%)'

    return (vals, cats, groups, xlabel, ylabel)

def data_2():
    '''
        Baseline results of SegNet between Albedo and RGB gardynM
        Date: Sep 18, 2017
    '''

    vals = dict()
    vals['using Reflectance image'] = [78.56, 55.82, 43.79]
    vals['using RGB image'] = [68.86, 42.31, 30.91]

    cats = vals.keys()
    groups = ['Global', 'Class', 'mIOU']
    xlabel = 'Metrics'
    ylabel = 'Accuracy (%)'

    return (vals, cats, groups, xlabel, ylabel)

def data_3():
    '''
        Baseline results of SegNet on 3DRMS val set
        Date: Sep 18, 2017
    '''

    vals = dict()
    vals['without'] = [59.05, 20.24, 13.09]
    vals['with finetuning'] = [77.10, 54.90, 38.37]

    cats = ['with finetuning', 'without']
    groups = ['Global', 'Class', 'mIOU']
    xlabel = 'Metrics'
    ylabel = 'Accuracy (%)'

    return (vals, cats, groups, xlabel, ylabel)

def bar_plot(filename, vals, cats, groups, xlabel, ylabel, title=None, ygrid=True):

    bar_width = .35
    space_bar = .05
    space_grp = 2 * bar_width
    grp_width = bar_width * len(cats) + space_grp
    bar_locs = np.arange(len(groups)) * grp_width

    # create new figure
    fig, ax = ptx.newfig(.85)

    for i, c in enumerate(cats):
        plt.bar(bar_locs + i * (bar_width + space_bar), vals[c], bar_width, label=c)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.xticks(bar_locs + (grp_width - space_grp - space_bar) /2, groups)
    plt.legend()
    if title is not None:
        plt.title(title)
    if ygrid:
        ax.yaxis.grid(True, linewidth=0.5)
        ax.set_axisbelow(True)


    ptx.savefig(filename)

bar_plot('/home/hale/test_real', *data_3())
