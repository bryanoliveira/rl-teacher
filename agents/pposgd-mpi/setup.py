import sys

from setuptools import setup

if sys.version_info.major != 3:
    print("This module is only compatible with Python 3, but you are running "
          "Python {}. The installation will likely fail.".format(sys.version_info.major))

setup(name='pposgd_mpi',
    version='0.0.1',
    install_requires=[
        'mujoco-py ~=0.5.7',
        'gym[mujoco]==0.9.2',
        'pillow<8.0',
        'scipy==1.4.1',
        'tqdm==4.64.1',
        'joblib==0.14.1',
        'zmq==0.0.0',
        'dill==0.3.4',
        'progressbar2==3.55.0',
        'mpi4py==2.0.0'
    ],
    # https://github.com/tensorflow/tensorflow/issues/7166#issuecomment-280881808
    extras_require={
        "tf": ["tensorflow == 1.2"],
        "tf_gpu": ["tensorflow-gpu >= 1.1"],
    }
)
