using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

using alice.tuprolog;

using Com.Live.RRutt.TuProlog.Util;

namespace Com.Live.RRutt.TuProlog.Lib
{
  public class PrologPredicatesAndFunctors : Library
  {
    public bool enableSpying = false;
    public bool enablePeeking = false;    
    public bool enableTrace = false;

    private IMainWindow _mainWindow;

    private Random _random = new Random();

    private Dictionary<String, List<String>> cardDecks = null;

    public PrologPredicatesAndFunctors(IMainWindow mainWindow)
    {
      _mainWindow = mainWindow;
    }

    public bool no_op_0()
    {
      return true;
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

    private List<String> getCardDeck(String deckName)
    {
      if (cardDecks == null)
      {
        cardDecks = new Dictionary<string, List<string>>();
      }

      List<String> cardDeck = null;
      if (cardDecks.ContainsKey(deckName))
      {
        cardDeck = cardDecks[deckName];
      }
      else
      {
        cardDeck = new List<string>();
        cardDecks.Add(deckName, cardDeck);
      }

      return cardDeck;
    }

    public bool clear_all_card_decks_0()
    {
      cardDecks = null;

      return true;
    }

    public bool add_card_to_top_of_deck_2(Term arg0, Term arg1)
    {
      String deckName = stringValueFromTerm(arg0);
      String card = stringValueFromTerm(arg1);

      List<String> cardDeck = getCardDeck(deckName);
      cardDeck.Insert(0, card);

      return true;
    }

    public bool add_card_to_bottom_of_deck_2(Term arg0, Term arg1)
    {
      String deckName = stringValueFromTerm(arg0);
      String card = stringValueFromTerm(arg1);

      List<String> cardDeck = getCardDeck(deckName);
      cardDeck.Add(card);

      return true;
    }

    public bool deal_card_from_deck_2(Term arg0, Term arg1)
    {
      String deckName = stringValueFromTerm(arg0);

      List<String> cardDeck = getCardDeck(deckName);
      String card = null;

      if (cardDeck.Count > 0)
      {
        card = cardDeck[0];
        cardDeck.RemoveAt(0);
      }

      bool foundCard = (card != null);
      if (foundCard)
      {
        unify(arg1, new Struct(card));
      }

      return foundCard;
    }

    public bool fetch_card_deck_2(Term arg0, Term arg1)
    {
      String deckName = stringValueFromTerm(arg0);

      List<String> cardDeck = getCardDeck(deckName);
      StringBuilder cards = new StringBuilder();

      foreach (String card in cardDeck)
      {
        cards.Append(card);
      }

      String deckCards = cards.ToString();

      unify(arg1, new Struct(deckCards));

      return true;
    }

    public bool move_cards_between_decks_2(Term arg0, Term arg1)
    {
      String fromDeckName = stringValueFromTerm(arg0);
      String toDeckName = stringValueFromTerm(arg1);

      List<String> fromCardDeck = getCardDeck(fromDeckName);
      List<String> toCardDeck = getCardDeck(toDeckName);

      foreach (String card in fromCardDeck)
      {
        toCardDeck.Add(card);
      }

      fromCardDeck.Clear();

      return true;
    }

    public bool split_card_decks_randomly_3(Term arg0, Term arg1, Term arg2)
    {
      String fromDeckName = stringValueFromTerm(arg0);
      String toDeckName1 = stringValueFromTerm(arg1);
      String toDeckName2 = stringValueFromTerm(arg2);

      List<String> fromCardDeck = getCardDeck(fromDeckName);
      List<String> toCardDeck1 = getCardDeck(toDeckName1);
      List<String> toCardDeck2 = getCardDeck(toDeckName2);

      foreach (String card in fromCardDeck)
      {
        double r = _random.NextDouble();
        if (r < 0.5)
        {
          toCardDeck1.Add(card);
        }
        else
        {
          toCardDeck2.Add(card);
        }
      }

      fromCardDeck.Clear();

      return true;
    }
  }
}
