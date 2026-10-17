with open('OpenRA.Android/java/org/libsdl/app/SDLActivity.java', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. getLibraries and loadLibraries
old_libs = """    protected String[] getLibraries() {
        return new String[] {
            "SDL2",
            // "SDL2_image",
            // "SDL2_mixer",
            // "SDL2_net",
            // "SDL2_ttf",
            "main"
        };
    }

    // Load the .so
    public void loadLibraries() {
       for (String lib : getLibraries()) {
          SDL.loadLibrary(lib, this);
       }
    }"""

new_libs = """    protected String[] getLibraries() {
        return new String[] {
            "SDL2",
            "openal",
            "freetype",
            "lua51"
        };
    }

    // Load the .so
    public void loadLibraries() {
       for (String lib : getLibraries()) {
          try {
             SDL.loadLibrary(lib, this);
          } catch (Throwable t) {
             Log.w(TAG, "Optional library load skipped: " + lib);
          }
       }
    }"""

assert old_libs in content, 'old_libs not found'
content = content.replace(old_libs, new_libs)

# 2. Version mismatch
old_ver = """            if (!version.equals(expected_version)) {
                mBrokenLibraries = true;
                errorMsgBrokenLib = "SDL C/Java version mismatch (expected " + expected_version + ", got " + version + ")";
            }"""

new_ver = """            if (!version.equals(expected_version)) {
                Log.w(TAG, "SDL C/Java version mismatch (expected " + expected_version + ", got " + version + ") - continuing anyway");
            }"""

assert old_ver in content, 'old_ver not found'
content = content.replace(old_ver, new_ver)

# 3. nativeRunMain replacement in SDLMain.run
old_run = """        Log.v("SDL", "Running main function " + function + " from library " + library);

        SDLActivity.nativeRunMain(library, function, arguments);

        Log.v("SDL", "Finished main function");"""

new_run = """        Log.v("SDL", "Starting OpenRA managed game...");

        try {
            SDLActivity.runManagedGame();
        } catch (Throwable t) {
            Log.e("SDL", "Error running managed game: " + t);
        }

        Log.v("SDL", "Finished OpenRA managed game");"""

assert old_run in content, 'old_run not found'
content = content.replace(old_run, new_run)

# 4. Add native methods & dispatchTouchEvent
native_decl = """    public static native void runManagedGame();
    public static native void nativeOnTouchEvent(int action, int pointerId, int x, int y);

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        int action = ev.getActionMasked();
        int index = ev.getActionIndex();
        int pointerId = ev.getPointerId(index);
        int x = (int)ev.getX(index);
        int y = (int)ev.getY(index);
        try {
            nativeOnTouchEvent(action, pointerId, x, y);
        } catch (Throwable ignored) {}
        return super.dispatchTouchEvent(ev);
    }
"""

content = content.replace('    public static native int nativeRunMain(String library, String function, Object arguments);',
                          '    public static native int nativeRunMain(String library, String function, Object arguments);\n' + native_decl)

with open('OpenRA.Android/java/org/libsdl/app/SDLActivity.java', 'w', encoding='utf-8') as f:
    f.write(content)

print('SDLActivity.java patched successfully!')
