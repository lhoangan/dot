import os
if 'FIGSIZE' not in os.environ:
    os.environ['FIGSIZE'] = '496.7855'
print ('Default Figure size is set to ', os.environ['FIGSIZE'])
print ('Check your number by running \\the\\linewidth or \\the\\textwidth in LaTeX')
print ('Apply the new number by overwrite it to os.environ[\'FIGSIZE\'] and reload')
print ('the module with reload(plotex)')
print ('Some useful textwidth numbers can be found below')
print ('\\the\\textwidth for CVPR : 496.85625 \t for ECCV : 347.12361')
print ('\\the\\linewidth for CVPR : 237.135594')
import numpy as np
import matplotlib as mpl
mpl.use('pgf')

# Get fig_width_pt from LaTeX using \the\textwidth
def figsize(scale):
    fig_width_pt = float(os.environ['FIGSIZE'])
    inches_per_pt = 1.0/72.27                       # Convert pt to inch
    golden_mean = (np.sqrt(5.0)-1.0)/2.0            # Aesthetic ratio (you could change this)
    fig_width = fig_width_pt*inches_per_pt*scale    # width in inches
    fig_height = fig_width*golden_mean              # height in inches
    fig_size = [fig_width,fig_height]
    return fig_size

pgf_with_latex = {                      # setup matplotlib to use latex for output
    "pgf.texsystem": "pdflatex",        # change this if using xetex or lautex
    "text.usetex": True,                # use LaTeX to write all text
    "font.family": "serif",
    "font.serif": [],                   # blank entries should cause plots to inherit fonts from the document
    "font.sans-serif": [],
    "font.monospace": [],
    "font.size": 12,
    "axes.labelsize": 12,               # LaTeX default is 10pt font.
    "legend.fontsize": 10,              # Make the legend/label fonts a little smaller
    "xtick.labelsize": 10,
    "ytick.labelsize": 10,
    "figure.figsize": figsize(0.95),     # default fig size of 0.9 textwidth
    "pgf.preamble": [
        r"\usepackage[utf8x]{inputenc}",    # use utf8 fonts becasue your computer can handle it :)
        r"\usepackage[T1]{fontenc}",        # plots will be generated using this preamble
        ]
    }
mpl.rcParams.update(pgf_with_latex)

import matplotlib.pyplot as plt

def newfig(width=1.0):
    plt.clf()
    fig = plt.figure(figsize=figsize(width))
    ax = fig.add_subplot(111)
    plt.tight_layout()
    return fig, ax

def savefig(filename):
    plt.savefig('{}.png'.format(filename), bbox_inches='tight')
    plt.savefig('{}.pgf'.format(filename), bbox_inches='tight')
    plt.savefig('{}.pdf'.format(filename), bbox_inches='tight')

    print ('\n------\nImages saved at', os.path.join(os.getcwd(), filename))

if __name__ == '__main__':
    # Simple test plot
    fig, ax  = newfig(0.6)

    def ema(y, a):
        s = []
        s.append(y[0])
        for t in range(1, len(y)):
            s.append(a * y[t] + (1-a) * s[t-1])
        return np.array(s)

    y = [0]*200
    y.extend([20]*(1000-len(y)))
    s = ema(y, 0.01)

    ax.plot(s)
    ax.set_xlabel('X Label')
    ax.set_ylabel('EMA')

    savefig('ema')
