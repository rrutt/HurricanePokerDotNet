using System;
using System.Collections.Generic;
using System.IO;

using alice.tuprolog;

using Com.Live.RRutt.TuProlog.Util;

namespace Com.Live.RRutt.TuProlog.Lib
{
  public class PrologPredicatesAndFunctors : Library
  {
    public static bool enableSpying = false;
    public static bool enablePeeking = false;    
    public static bool enableTrace = false;

    private IMainWindow _mainWindow;

    private Random _random = new Random();

    public PrologPredicatesAndFunctors(IMainWindow mainWindow)
    {
      _mainWindow = mainWindow;
    }

    public bool text_title_1(Struct g)
    {
      //		Term arg0 = g.getTerm(0);
      String title = Utilities.stripQuotes(g.getName()); //arg0.toString());
      _mainWindow.SetTextTitle(title);
      // logMsg("text_title " + title);
      return true;
    }

    public bool text_close_0()
    {
      _mainWindow.ClearText();

      return true;
    }

    public bool text_clear_0()
    {
      _mainWindow.ClearText();

      return true;
    }

    public bool text_cursor_2(Term rowTerm, Term colTerm)
    {
      int row = intValueFromTerm(rowTerm);
      int col = intValueFromTerm(colTerm);
      // logMsg("text_cursor " + row + " " + col);

      _mainWindow.SetTextCursorRowCol(row, col);
      return true;
    }

    private int intValueFromTerm(Term t)
    {
      int result = 0;

      Term tt = t.getTerm();
      if (tt is Int)
      {
        result = ((Int)tt).intValue();
      }
      else if (tt is Number)
      {
        Number n = (Number)tt;
        if (n is Int)
        {
          result = n.intValue();
        }
      }

      return result;
    }

    private String stringValueFromTerm(Term t)
    {
      String result = "";

      Term tt = t.getTerm();
      if (tt is Struct)
      {
        result = ((Struct)tt).getName();
      }
      else if (tt is Number)
      {
        Number n = (Number)tt;
        if (n is Int)
        {
          result = new java.lang.Integer(n.intValue()).toString();
        }
        else
        {
          result = n.toString();
        }
      }

      return result;
    }

    public bool text_write_1(Term arg0)
    {
      String text = stringValueFromTerm(arg0);
      _mainWindow.WriteText(text);
      // logMsg("text_write " + text);
      return true;
    }

    public bool text_nl_0()
    {
      _mainWindow.TextNewLine();
      // logMsg("text_nl");
      return true;
    }

    public bool peek_enabled_0()
    {
      return enablePeeking;
    }

    public bool peek_write_1(Term arg0)
    {
      String text = stringValueFromTerm(arg0);
      System.Console.Out.Write(text);
      return true;
    }

    public bool peek_nl_0()
    {
      System.Console.Out.Write("\n");
      return true;
    }

    public bool spy_enabled_0()
    {
      return enableSpying;
    }

    public bool spy_write_1(Term arg0)
    {
      String text = stringValueFromTerm(arg0);
      System.Console.Out.Write(text);
      return true;
    }

    public bool spy_nl_0()
    {
      System.Console.Out.Write("\n");
      return true;
    }

    public bool menu_3(Term arg0, Term arg1, Term arg2)
    {
      String menuCaption = stringValueFromTerm(arg0);
      Struct choices = (Struct)arg1;
      Term choiceResultTerm = arg2;

      var choicesList = new List<string>();
		  var iter = choices.listIterator();
      while (iter.hasNext())
      {
        Term choiceTerm = (Term)(iter.next());
        var choiceText = Utilities.stripQuotes(stringValueFromTerm(choiceTerm));
        if (choiceText.Length > 0)
        {
          choicesList.Add(choiceText);
        }
      }

      int choice = _mainWindow.MenuDialog(menuCaption, choicesList);

      return unify(choiceResultTerm, new alice.tuprolog.Int(choice));
    }

    public Term random_int_1(Term val0)
    {
      Term result = new Var();

      if (!(val0 is Number))
      {
        throw new Exception(
            "random_int requires a bound integer parameter.");
      }
      int n = ((alice.tuprolog.Number)val0).intValue();

      java.lang.Double d = new java.lang.Double(1 + (_random.NextDouble() * n));
      unify(result, new alice.tuprolog.Int(d.intValue()));

      return result;
    }

    public Term random_double_0()
    {
      Term result = new Var();

      unify(result, new alice.tuprolog.Double(_random.NextDouble()));

      return result;
    }

    public bool str_int_2(Term arg0, Term arg1)
    {
      if (arg0 is Var)
      {
        Term val1 = evalExpression(arg1);
        alice.tuprolog.Number n = (alice.tuprolog.Number)val1;
        String s = null;
        if (n.isInteger())
        {
          s = new java.lang.Integer(n.intValue()).toString();
        }
        else
        {
          return false;
        }
        return (unify(arg0, new Struct(s)));
      }
      else
      {
        if (!arg0.isAtom())
        {
          return false;
        }
        String s = ((Struct)arg0).getName();
        int n = s.Length;
        if (n > 2)
        {
          if ((s[0] == '\'') && (s[n - 1] == '\''))
          {
            s = s.Substring(1, n - 2);
          }
        }
        Term term = null;
        try
        {
          term = new alice.tuprolog.Int(java.lang.Integer.parseInt(s));
        }
        catch (Exception ex)
        {
          // Ignore
          var msg = ex.Message;
        }
        if (term == null)
        {
          return false;
        }
        return (unify(arg1, term));
      }
    }

    public bool str_char_2(Term arg0, Term arg1)
    {
      if ((arg0 is Var) && (!((Var)arg0).isBound()))
      {
        String s = stringValueFromTerm(arg1);
        int n = s.Length;
        if (n > 2)
        {
          if ((s[0] == '\'') && (s[n - 1] == '\''))
          {
            s = s.Substring(1, n - 2);
          }
        }
        return (unify(arg0, new Struct(s)));
      }
      else if ((arg1 is Var) && (!((Var)arg1).isBound()))
      {
        String s = stringValueFromTerm(arg0);
        int n = s.Length;
        if (n > 2)
        {
          if ((s[0] == '\'') && (s[n - 1] == '\''))
          {
            s = s.Substring(1, n - 2);
          }
        }
        return (unify(arg1, new Struct(s)));
      }
      return false;
    }

    public bool ask_ok_0()
    {
      String msg = "Click to proceed.";
      bool ok = _mainWindow.OkDialog(msg);

      return ok;
    }

    public bool ask_ok_1(Term arg0)
    {
      String text = stringValueFromTerm(arg0);
      bool ok = _mainWindow.OkDialog(text);

      return ok;
    }

    public bool ask_ok_2(Term arg0, Term arg1)
    {
      String text0 = stringValueFromTerm(arg0);
      String text1 = stringValueFromTerm(arg1);
      String msg = Utilities.stripQuotes(text0) + Utilities.stripQuotes(text1);
      bool ok = _mainWindow.OkDialog(msg);

      return ok;
    }

    public bool ask_yes_no_0()
    {
      String msg = "Click to proceed.";
      bool ok = _mainWindow.YesNoDialog(msg);

      return ok;
    }

    public bool ask_yes_no_1(Term arg0)
    {
      String text = stringValueFromTerm(arg0);
      bool ok = _mainWindow.YesNoDialog(text);

      return ok;
    }

    public bool ask_yes_no_2(Term arg0, Term arg1)
    {
      String text0 = stringValueFromTerm(arg0);
      String text1 = stringValueFromTerm(arg1);
      String msg = Utilities.stripQuotes(text0) + Utilities.stripQuotes(text1);
      bool ok = _mainWindow.YesNoDialog(msg);

      return ok;
    }

    public bool break_point_0()
    {
      System.Console.Out.WriteLine(" {break_point}");
      return true;
    }

    public bool break_point_1(Term arg0)
    {
      String text = stringValueFromTerm(arg0);
      System.Console.Out.WriteLine(" {break_point: " + text + "}");
      return true;
    }

    public bool trace_enabled_0()
    {
      return enableTrace;
    }

    public bool enable_trace_0()
    {
      enableTrace = true;
      System.Console.Out.WriteLine("+++ enable_trace.");
      return true;
    }

    public bool disable_trace_0()
    {
      enableTrace = false;
      System.Console.Out.WriteLine("--- disable_trace.");
      return true;
    }

    public bool trace_1(Term arg0)
    {
      if (enableTrace)
      {
        String text = stringValueFromTerm(arg0);
        System.Console.Out.Write(text);
      }
      return true;
    }

    public bool trace_nl_0()
    {
      if (enableTrace)
      {
        System.Console.Out.WriteLine();
      }
      return true;
    }
  }
}
