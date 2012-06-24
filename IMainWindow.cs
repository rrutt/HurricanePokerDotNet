using System;
using System.Collections.Generic;

namespace Com.Live.RRutt.TuProlog.Lib
{
  public interface IMainWindow
  {
    void SetTextTitle(string title);

    void ClearText();

    void SetTextCursorRowCol(int row, int col);

    void TextNewLine();

    void WriteText(string text);

    int MenuDialog(string caption, List<string> choiceList);

    bool OkDialog(string caption);

    bool YesNoDialog(string caption);
  }
}
