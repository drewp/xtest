
""" use XTest to simulate key presses, including multi-key presses
such as Control-Shift-Alt-space

see http://hoopajoo.net/projects/xautomation.html (gnu) for other examples

see http://homepage3.nifty.com/tsato/xvkbd/events.html for more about
keys with modifiers """

cdef extern from "X11/Xlib.h":
    ctypedef struct Display
    
    Display *XOpenDisplay(char* display_name)
    int XCloseDisplay(Display *display)
    int XFlush(Display* display)

    ctypedef unsigned int XID
    ctypedef XID KeySym

    ctypedef unsigned char KeyCode

    KeySym XStringToKeysym(char* string)
    KeyCode XKeysymToKeycode(Display* display, KeySym keysym)
NoSymbol = 0 
CurrentTime = 0#   /* special Time */

cdef extern from "X11/extensions/XTest.h":
    int XTestFakeKeyEvent(Display* dpy, unsigned int keycode,
                          int is_press, # (actually Bool)
                          unsigned long delay)

cdef keycode(Display *dpy, key_string):
    cdef KeyCode kc
    cdef KeySym ks

    ks = XStringToKeysym(key_string)
    if ks == NoSymbol:
        raise ValueError("no symbol for key %r" % key_string)

    kc = XKeysymToKeycode(dpy, ks)
    return <int>kc

cdef class XTest:
    cdef Display *dpy
    def __init__(self, display=":0.0"):
        self.dpy = XOpenDisplay(display)
        if self.dpy is NULL:
            raise ValueError("unable to open display %r" % display)

    def __dealloc__(self):
        XCloseDisplay(self.dpy)

    def fakeKeyEvent(self, key, down=True, up=True):
        """key is a Tk-style list of modifiers and key name, such as:

        'p'
        'P' # same as 'Shift-p'
        'Shift-p'
        'Alt-Shift-p'
        'space'
        
        """
        cdef Display *d
        d = self.dpy

        if key == '-':
            key = 'minus'
        if key.isupper():
            key = "Shift-%s" % key

        presses = []
        for k in key.split('-'):
            if k in ['Shift','Alt','Control']:
                k = '%s_L' % k
            presses.append(keycode(self.dpy, k))

        if down:
            for k in presses:
                XTestFakeKeyEvent(d, k, True, CurrentTime)
        if up:
            for k in presses[::-1]:
                XTestFakeKeyEvent(d, k, False, CurrentTime)
        XFlush(d)
      
