from distutils.core import setup
from distutils.extension import Extension
from Pyrex.Distutils import build_ext

setup(name="xtest",
      version="1.21",
      description="pyrex interface to XTest including faking multi-key presses such as Control-Shift-s",
      author="Drew Perttula",
      author_email="drewp@bigasterisk.com",
      url="http://bigasterisk.com/darcs/?r=xtest",
      download_url="http://projects.bigasterisk.com/xtest-1.21.tar.gz",
      classifiers=[
          "Development Status :: 5 - Production/Stable",
          "Environment :: X11 Applications",
          "License :: OSI Approved :: GNU General Public License (GPL)",
          "Operating System :: POSIX :: Linux",
          "Programming Language :: Python",
          "Topic :: Software Development :: Libraries :: Python Modules",
          ],
      ext_modules=[
        Extension("xtest",
                  ["xtest.pyx"],
                  library_dirs=['/usr/X11R6/lib'],
                  libraries=["X11","Xtst"]),
        ],  
      cmdclass={'build_ext':build_ext})

