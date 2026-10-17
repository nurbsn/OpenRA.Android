using System;
using System.Reflection;
using System.Runtime.InteropServices;

namespace OpenRA.Android
{
	public static class NativeLibraryResolver
	{
		static bool initialized;

		public static void Initialize()
		{
			if (initialized)
				return;

			initialized = true;

			// Register resolver for all current and future assemblies
			AppDomain.CurrentDomain.AssemblyLoad += (_, e) => RegisterForAssembly(e.LoadedAssembly);

			foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
				RegisterForAssembly(assembly);
		}

		public static void RegisterForAssembly(Assembly assembly)
		{
			try
			{
				NativeLibrary.SetDllImportResolver(assembly, ResolveLibrary);
			}
			catch (InvalidOperationException)
			{
				// Resolver already set for this assembly
			}
			catch (Exception ex)
			{
				Console.WriteLine($"[NativeLibraryResolver] Error setting resolver for {assembly.FullName}: {ex.Message}");
			}
		}

		static IntPtr ResolveLibrary(string libraryName, Assembly assembly, DllImportSearchPath? searchPath)
		{
			var name = libraryName;

			if (name.EndsWith(".dll", StringComparison.OrdinalIgnoreCase))
				name = name[..^4];

			string candidate = name switch
			{
				"SDL2" => "libSDL2.so",
				"soft_oal" or "openal" or "OpenAL32" => "libopenal.so",
				"freetype6" or "freetype" => "libfreetype.so",
				"lua51" or "lua5.1" or "lua" => "liblua51.so",
				_ => null
			};

			if (candidate != null)
			{
				if (NativeLibrary.TryLoad(candidate, assembly, searchPath, out var handle))
					return handle;

				if (NativeLibrary.TryLoad(candidate, out handle))
					return handle;
			}

			if (NativeLibrary.TryLoad(libraryName, assembly, searchPath, out var defaultHandle))
				return defaultHandle;

			return IntPtr.Zero;
		}
	}
}
