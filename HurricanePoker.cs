using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using alice.tuprolog;
using alice.tuprolog.@event;

using Com.Live.RRutt.TuProlog.Lib;
using Com.Live.RRutt.TuProlog.Util;

namespace Com.Live.RRutt.HurricanePokerDotNet
{
  public partial class HurricanePoker : Form, IMainWindow, OutputListener, SpyListener
  {
    public Prolog engine;

    private static String TheoryResourceName = "HurricanePoker.pl";

    private String theoryFilePath = null;

    public HurricanePoker(string[] args)
    {
      System.Console.Out.WriteLine(
          "Rick Rutt's Hurricane Poker - Using the tuProlog system "
          + Prolog.getVersion()
          );

      foreach (var arg in args)
      {
        if ((arg.Length > 1) && (arg[0] == '-'))
        {
          if (arg.Equals("-peek", StringComparison.CurrentCultureIgnoreCase))
          {
            PrologPredicatesAndFunctors.enablePeeking = true;
            System.Console.Out.WriteLine("Peek output enabled.");
          }
          else if (arg.Equals("-spy", StringComparison.CurrentCultureIgnoreCase))
          {
            PrologPredicatesAndFunctors.enableSpying = true;
            System.Console.Out.WriteLine("Spy output enabled.");
          }
          else
          {
            System.Console.Out.WriteLine("Unknown command argument ignored: " + arg);
          }
        }
        else
        {
          theoryFilePath = arg;
          System.Console.Out.WriteLine("Processing theory file: " + arg);
        }
      }

      InitializeComponent();

      engine = new Prolog();
      try
      {
        var library = new PrologPredicatesAndFunctors(this);
        engine.loadLibrary(library);
      }
      catch (Exception e)
      {
        var s = string.Format(
          "*****\n{0}: {1}\n-----\n{2}\n",
          e.GetType().Name, e.Message, e.StackTrace);
        System.Console.Out.Write(s);
      }
      engine.addOutputListener(this);
      engine.addSpyListener(this);
      engine.setSpy(PrologPredicatesAndFunctors.enableSpying);

      try
      {
        TheoryLoader loader = new TheoryLoader();
        String theoryText = loader.Load();
        var t = new Theory(theoryText);
        //				t = new Theory(theoryInputStream);
        engine.setTheory(t);

        SolveInfo info = engine.solve("x.");
        //			System.Console.Out.Write(info);
      }
      catch (Exception e)
      {
        var s = string.Format(
          "*****\n{0}: {1}\n-----\n{2}\n",
          e.GetType().Name, e.Message, e.StackTrace);
        System.Console.Out.Write(s);
      }

      System.Environment.Exit(0);
    }

    public void SetTextTitle(string title)
    {
      textAreaTitle.Text = title;
    }

    public void ClearText()
    {
      textArea.Text = string.Empty;
    }

    public void onOutput(OutputEvent ev)
    {
      String s = Utilities.stripQuotes(ev.getMsg());
      outputArea.Text += s;
      outputArea.SelectionStart = outputArea.TextLength;
      outputArea.SelectionLength = 0;
    }

    public void onSpy(SpyEvent ev)
    {
      String s = Utilities.stripQuotes(ev.getMsg());
      System.Console.Out.Write(" {Spy: ");
      System.Console.Out.Write(s);
      System.Console.Out.Write("}\n");
    }
  }
}
