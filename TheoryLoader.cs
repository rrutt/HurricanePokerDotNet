using System;
using System.IO;
using System.Text;

namespace Com.Live.RRutt.HurricanePokerDotNet
{
  public class TheoryLoader
  {
    private static readonly string TheoryFolderPath = @".";

    private static readonly string[] TheoryResourceNames = {
		"HurricanePoker.pl",
  };

    public string Load()
    {
      var sb = new StringBuilder();

      foreach (var resourceName in TheoryResourceNames)
      {
        appendResource(resourceName, sb);
      }

      var theoryString = sb.ToString();

      return theoryString;
    }

    private void appendResource(string resourceName, StringBuilder sb)
    {
      System.Console.Out.WriteLine("Loading " + resourceName);

      var theoryFileRelativePath = Path.Combine(TheoryFolderPath, resourceName);
      var theoryFileAbsolutePath = Path.GetFullPath(theoryFileRelativePath);

      try
      {
        var theoryText = File.ReadAllText(theoryFileAbsolutePath);
        sb.Append(theoryText);
      }
      catch (Exception e)
      {
        var s = string.Format(
          "Could not load resource [{0}]\n  {1}: {2}\n",
          theoryFileAbsolutePath, e.GetType().Name, e.Message);
        System.Console.Out.Write(s);
      }
    }
  }
}
