using System;
using System.IO;
using System.Text;

namespace Com.Live.RRutt.HurricanePokerDotNet
{
  public class TheoryLoader
  {
    public string Load(string theoryPath)
    {
      var sb = new StringBuilder();

      appendResource(theoryPath, sb);
      var theoryString = sb.ToString();

      return theoryString;
    }

    private void appendResource(string resourcePath, StringBuilder sb)
    {
      System.Console.Out.WriteLine("Loading " + resourcePath);

      var resourceAbsolutePath = Path.GetFullPath(resourcePath);

      try
      {
        var resourceText = File.ReadAllText(resourceAbsolutePath);
        sb.Append(resourceText);
      }
      catch (Exception e)
      {
        var s = string.Format(
          "Could not load resource [{0}]\n  {1}: {2}\n",
          resourceAbsolutePath, e.GetType().Name, e.Message);
        System.Console.Out.Write(s);
      }
    }
  }
}
