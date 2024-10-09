from setuptools import setup

setup(name='human_feedback_api',
    version='0.0.1',
    install_requires=[
        'Django==1.10',
        'dj_database_url==0.5.0',
        'gunicorn',
        'whitenoise==3.0',
        'ipython',
        'flask',
    ]
)
