using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
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
    private PrologPredicatesAndFunctors library;

    public const String DefaultTheoryFilePath = @".\HurricanePoker.pl";

    private const int OneSecond = 1000;

    private String theoryFilePath = DefaultTheoryFilePath;

    private int textCursorRow = 0;
    private int textCursorCol = 0;

    private bool waitingForUser = false;

    private int dialogResult = 0;

    public HurricanePoker(string[] args)
    {
      System.Console.Out.WriteLine(
          "Rick Rutt's Hurricane Poker - Using the tuProlog system "
          + Prolog.getVersion()
          );

      bool enablePeeking = false;
      bool enableSpying = false;
      bool enableTrace = false;

      foreach (var arg in args)
      {
        if ((arg.Length > 1) && (arg[0] == '-'))
        {
          if (arg.Equals("-peek", StringComparison.CurrentCultureIgnoreCase))
          {
            enablePeeking = true;
            System.Console.Out.WriteLine("Peek output enabled.");
          }
          else if (arg.Equals("-spy", StringComparison.CurrentCultureIgnoreCase))
          {
            enableSpying = true;
            System.Console.Out.WriteLine("Spy output enabled.");
          }
          else if (arg.Equals("-trace", StringComparison.CurrentCultureIgnoreCase))
          {
            enableTrace = true;
            System.Console.Out.WriteLine("Trace output enabled.");
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

      this.Visible = true;

      Application.DoEvents();

      engine = new Prolog();
      try
      {
        library = new PrologPredicatesAndFunctors(this);
        library.enablePeeking = enablePeeking;
        library.enableSpying = enableSpying;
        library.enableTrace = enableTrace;

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
      engine.setSpy(enableSpying);

      try
      {
        TheoryLoader loader = new TheoryLoader();
        String theoryText = loader.Load(theoryFilePath);
        var t = new Theory(theoryText);
        //				t = new Theory(theoryInputStream);
        engine.setTheory(t);

        Application.DoEvents();

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
      SetTextCursorRowCol(0, 0);

      Application.DoEvents();
    }

    public void SetTextCursorRowCol(int row, int col)
    {
      textCursorRow = row;
      textCursorCol = col;
    }

    public void TextNewLine()
    {
      textCursorRow++;
      textCursorCol = 0;
    }

    public void WriteText(string text)
    {
      if (!string.IsNullOrEmpty(text))
      {
        var s = Utilities.stripQuotes(text);

        var textLines = new List<string>();
        foreach (var line in textArea.Lines)
        {
          textLines.Add(line);
        }

        while (textCursorRow >= textLines.Count)
        {
          textLines.Add(string.Empty);
        }

        var textLine = textLines[textCursorRow];
        var lineLength = textLine.Length;

        if (textCursorCol < lineLength)
        {
          var newTextLine = textLine.Substring(0, textCursorCol);
          newTextLine += text;

          var newCol = newTextLine.Length;
          if (newCol < lineLength)
          {
            newTextLine += textLine.Substring(newCol);
          }

          textLine = newTextLine;
          lineLength = textLine.Length;
        }
        else
        {
          if (textCursorCol > lineLength)
          {
            textLine += new string(' ', (textCursorCol - lineLength));
            lineLength = textLine.Length;
          }
          textLine += text;
        }

        textLines[textCursorRow] = textLine;

        var sb = new StringBuilder();
        foreach (var line in textLines)
        {
          sb.Append(line).Append("\r\n");
        }

        textArea.Text = sb.ToString();

        textCursorCol += text.Length;

        Application.DoEvents();
      }
    }

    public int MenuDialog(string caption, List<string> choiceList)
    {
      var buttonLocation = this.menuButton.Location;

      var buttonList = new List<System.Windows.Forms.Button>();

      int choiceIndex = 0;
      foreach (var choiceText in choiceList)
      {
        choiceIndex++;
        var choiceTag = choiceIndex.ToString();

        var button = new System.Windows.Forms.Button();

        button.Location = buttonLocation;
        button.Name = "menuButton" + choiceTag;
        button.Size = this.menuButton.Size;
        button.TabIndex = 1 + choiceIndex;
        button.Tag = choiceTag;
        button.Text = choiceText;
        button.UseVisualStyleBackColor = true;
        button.Visible = (choiceText.Length > 0);
        button.Click += new System.EventHandler(this.menuButton_Click);

        buttonLocation = new Point(
          buttonLocation.X,
          buttonLocation.Y + this.menuButton.Size.Height
          );

        buttonList.Add(button);
        this.menuDialog.Controls.Add(button);
      }

      menuText.Text = caption;

      this.menuDialog.Visible = true;

      Application.DoEvents();

      waitingForUser = true;
      while (waitingForUser)
      {
        Thread.Sleep(OneSecond);
        Application.DoEvents();
      }

      this.menuDialog.Visible = false;

      foreach (var b in buttonList)
      {
        this.menuDialog.Controls.Remove(b);
      }

      Application.DoEvents();

      return dialogResult;
    }

    private void menuButton_Click(object sender, EventArgs e)
    {
      var button = sender as System.Windows.Forms.Button;
      if (button != null)
      {
        var tag = button.Tag as string;
        var parseOk = int.TryParse(tag, out dialogResult);
        if (parseOk)
        {
          waitingForUser = false;
        }
      }
    }

    public bool OkDialog(string caption)
    {
      okText.Text = caption;

      this.okDialog.Visible = true;

      Application.DoEvents();

      waitingForUser = true;
      while (waitingForUser)
      {
        Thread.Sleep(OneSecond);
        Application.DoEvents();
      }

      this.okDialog.Visible = false;

      Application.DoEvents();

      return true;
    }

    private void okButton_Click(object sender, EventArgs e)
    {
      waitingForUser = false;
    }

    public bool YesNoDialog(string caption)
    {
      yesNoText.Text = caption;

      this.yesNoDialog.Visible = true;

      Application.DoEvents();

      waitingForUser = true;
      while (waitingForUser)
      {
        Thread.Sleep(OneSecond);
        Application.DoEvents();
      }

      this.yesNoDialog.Visible = false;

      Application.DoEvents();

      var isYes = (dialogResult == 1);

      return isYes;
    }

    private void yesButton_Click(object sender, EventArgs e)
    {
      dialogResult = 1;
      waitingForUser = false;
    }

    private void noButton_Click(object sender, EventArgs e)
    {
      dialogResult = 2;
      waitingForUser = false;
    }

    public void onOutput(OutputEvent ev)
    {
      String s = Utilities.stripQuotes(ev.getMsg());
      s = s.Replace("\n", "\r\n");
      outputArea.Text += s;
      outputArea.SelectionStart = outputArea.TextLength;
      outputArea.SelectionLength = 0;
      outputArea.ScrollToCaret();

      Application.DoEvents();

      if (library.enableTrace)
      {
        System.Console.Out.Write(s);
      }
    }

    public void onSpy(SpyEvent ev)
    {
      String s = Utilities.stripQuotes(ev.getMsg());
      System.Console.Out.Write(" {Spy: ");
      System.Console.Out.Write(s);
      System.Console.Out.WriteLine("}");
    }

    private void HurricanePoker_FormClosing(object sender, FormClosingEventArgs e)
    {
      Application.DoEvents();
    }

    private void HurricanePoker_FormClosed(object sender, FormClosedEventArgs e)
    {
      System.Environment.Exit(0);
    }
  }
}
