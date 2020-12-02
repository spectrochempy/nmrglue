from .fileio import *
from .process import *
from .util import *
from .analysis import *

from pkg_resources import get_distribution, DistributionNotFound

try:
    __version__ = get_distribution("nmrglue").version
except DistributionNotFound:
    # package is not installed
    pass

