import sys

from setuptools import setup

if sys.version_info.major != 3:
    print("This module is only compatible with Python 3, but you are running "
          "Python {}. The installation will likely fail.".format(sys.version_info.major))

setup(name='rl_teacher',
    version='0.0.1',
    install_requires=[
        'numpy==1.18.5',
        'protobuf == 3.6.1',
        'mujoco-py ~=0.5.7',
        'gym[mujoco]==0.9.2',
        'pillow<=8.0',
        'imageio==2.9.0',
        'tqdm==4.64.1',
        'matplotlib==3.0.3',
        'ipython==7.9.0',
        'scipy==1.4.1',
        'ipdb==0.13.13',
        'keras==2.0.8',
        'netifaces==0.11.0'
    ],
    # https://github.com/tensorflow/tensorflow/issues/7166#issuecomment-280881808
    extras_require={
        "tf": ["tensorflow == 1.2"],
        "tf_gpu": ["tensorflow-gpu >= 1.1"],
    }
)
