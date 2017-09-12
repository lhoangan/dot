import os, sys
import re
import matplotlib

# check if having display
have_display = 'DISPLAY' in os.environ
if not have_display:
    exitval = os.system('python -c "import matplotlib.pyplot as plt; plt.figure()"')
    havedisplay = (exitval == 0)
if not have_display:
    matplotlib.use('Agg')

import matplotlib.pyplot as plt

regex_iter = re.compile('Iteration (\d+), loss = (\d+[.]*\d*)')
regex_acc = re.compile('Train net output #0: accuracy = (\d+[.]*\d*)')

def parse_log(log_file):
    niter = []
    loss = []
    acc = []

    with open(log_file) as lf:
        for line in lf.readlines():
            iter_match = regex_iter.search(line)
            if iter_match:
                niter.append(int(iter_match.group(1)))
                loss.append(float(iter_match.group(2)))
            acc_match = regex_acc.search(line)
            if acc_match:
                acc.append(float(acc_match.group(1)))

    if len(acc) == 0:
        acc = None

    # sanity check
    while acc is not None and len(niter) != len(acc):
        min_len = min(len(niter), len(acc))
        for i in range(min_len, len(niter)):
            niter.pop()
            loss.pop()
        for i in range(min_len, len(acc)):
            acc.pop()

    return (niter, loss, acc)


def plot_log(niter, loss=None, acc=None, path=None):

    import pdb
    pdb.set_trace()
    if loss is None and acc is None:
        return

    _, ax1 = plt.subplots()
    ax1.set_xlabel('iteration')
    if loss is not None:
        loss_plot, = ax1.plot(niter, loss, 'b', label='Loss (blue)')
        ax1.set_ylabel('train loss (blue)')
        if acc is not None:
            ax2 = ax1.twinx()
            acc_plot, = ax2.plot(niter, acc, 'r', label='Accuracy (red)')
            ax2.set_ylabel('train accuracy (red)')
            plt.legend(handles=[loss_plot, acc_plot])
        else:
            plt.legend(handles=[loss_plot])

    else:
        acc_plot, = ax1.plot(niter, acc, 'r', label='Accuracy (red)')
        ax1.set_ylabel('train accuracy (red)')
        plt.legend(handels=[acc_plot])

    if path is None:
        plt.show()
    else:
        plt.savefig(path, bbox_inches='tight')


if __name__ == '__main__':
    if len(sys.argv) == 2:
        assert have_display, 'No display found, cannot plot on screen'
        (niter, loss, acc) = parse_log(sys.argv[1])
        plot_log(niter, loss, acc)
    if len(sys.argv) == 3:
        (niter, loss, acc) = parse_log(sys.argv[1])
        plot_log(niter, loss, acc, sys.argv[2])

