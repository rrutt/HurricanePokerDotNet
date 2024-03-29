﻿namespace Com.Live.RRutt.HurricanePokerDotNet
{
  partial class HurricanePoker
  {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing && (components != null))
      {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
      this.textArea = new System.Windows.Forms.TextBox();
      this.outputArea = new System.Windows.Forms.TextBox();
      this.yesNoDialog = new System.Windows.Forms.FlowLayoutPanel();
      this.yesNoText = new System.Windows.Forms.TextBox();
      this.yesButton = new System.Windows.Forms.Button();
      this.noButton = new System.Windows.Forms.Button();
      this.okDialog = new System.Windows.Forms.FlowLayoutPanel();
      this.okText = new System.Windows.Forms.TextBox();
      this.okButton = new System.Windows.Forms.Button();
      this.menuDialog = new System.Windows.Forms.FlowLayoutPanel();
      this.menuText = new System.Windows.Forms.TextBox();
      this.menuButton = new System.Windows.Forms.Button();
      this.textAreaTitle = new System.Windows.Forms.Label();
      this.yesNoDialog.SuspendLayout();
      this.okDialog.SuspendLayout();
      this.menuDialog.SuspendLayout();
      this.SuspendLayout();
      // 
      // textArea
      // 
      this.textArea.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                  | System.Windows.Forms.AnchorStyles.Right)));
      this.textArea.BackColor = System.Drawing.SystemColors.Window;
      this.textArea.Font = new System.Drawing.Font("Courier New", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.textArea.Location = new System.Drawing.Point(8, 38);
      this.textArea.Multiline = true;
      this.textArea.Name = "textArea";
      this.textArea.ReadOnly = true;
      this.textArea.Size = new System.Drawing.Size(539, 307);
      this.textArea.TabIndex = 0;
      this.textArea.TabStop = false;
      this.textArea.WordWrap = false;
      // 
      // outputArea
      // 
      this.outputArea.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
                  | System.Windows.Forms.AnchorStyles.Right)));
      this.outputArea.BackColor = System.Drawing.SystemColors.Window;
      this.outputArea.Font = new System.Drawing.Font("Courier New", 10.2F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.outputArea.Location = new System.Drawing.Point(8, 351);
      this.outputArea.Multiline = true;
      this.outputArea.Name = "outputArea";
      this.outputArea.ReadOnly = true;
      this.outputArea.ScrollBars = System.Windows.Forms.ScrollBars.Both;
      this.outputArea.Size = new System.Drawing.Size(539, 148);
      this.outputArea.TabIndex = 5;
      this.outputArea.TabStop = false;
      // 
      // yesNoDialog
      // 
      this.yesNoDialog.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
      this.yesNoDialog.Controls.Add(this.yesNoText);
      this.yesNoDialog.Controls.Add(this.yesButton);
      this.yesNoDialog.Controls.Add(this.noButton);
      this.yesNoDialog.Location = new System.Drawing.Point(554, 84);
      this.yesNoDialog.Name = "yesNoDialog";
      this.yesNoDialog.Size = new System.Drawing.Size(170, 110);
      this.yesNoDialog.TabIndex = 3;
      this.yesNoDialog.Visible = false;
      // 
      // yesNoText
      // 
      this.yesNoText.Location = new System.Drawing.Point(3, 3);
      this.yesNoText.Name = "yesNoText";
      this.yesNoText.ReadOnly = true;
      this.yesNoText.Size = new System.Drawing.Size(165, 22);
      this.yesNoText.TabIndex = 0;
      this.yesNoText.TabStop = false;
      this.yesNoText.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
      // 
      // yesButton
      // 
      this.yesButton.Location = new System.Drawing.Point(3, 31);
      this.yesButton.Name = "yesButton";
      this.yesButton.Size = new System.Drawing.Size(165, 32);
      this.yesButton.TabIndex = 1;
      this.yesButton.Text = "Yes";
      this.yesButton.UseVisualStyleBackColor = true;
      this.yesButton.Click += new System.EventHandler(this.yesButton_Click);
      // 
      // noButton
      // 
      this.noButton.Location = new System.Drawing.Point(3, 69);
      this.noButton.Name = "noButton";
      this.noButton.Size = new System.Drawing.Size(165, 32);
      this.noButton.TabIndex = 2;
      this.noButton.Text = "No";
      this.noButton.UseVisualStyleBackColor = true;
      this.noButton.Click += new System.EventHandler(this.noButton_Click);
      // 
      // okDialog
      // 
      this.okDialog.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
      this.okDialog.Controls.Add(this.okText);
      this.okDialog.Controls.Add(this.okButton);
      this.okDialog.Location = new System.Drawing.Point(553, 7);
      this.okDialog.Name = "okDialog";
      this.okDialog.Size = new System.Drawing.Size(171, 70);
      this.okDialog.TabIndex = 2;
      this.okDialog.Visible = false;
      // 
      // okText
      // 
      this.okText.Location = new System.Drawing.Point(3, 3);
      this.okText.Name = "okText";
      this.okText.ReadOnly = true;
      this.okText.Size = new System.Drawing.Size(165, 22);
      this.okText.TabIndex = 0;
      this.okText.TabStop = false;
      this.okText.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
      // 
      // okButton
      // 
      this.okButton.Location = new System.Drawing.Point(3, 31);
      this.okButton.Name = "okButton";
      this.okButton.Size = new System.Drawing.Size(165, 32);
      this.okButton.TabIndex = 1;
      this.okButton.Text = "OK";
      this.okButton.UseVisualStyleBackColor = true;
      this.okButton.Click += new System.EventHandler(this.okButton_Click);
      // 
      // menuDialog
      // 
      this.menuDialog.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
      this.menuDialog.Controls.Add(this.menuText);
      this.menuDialog.Controls.Add(this.menuButton);
      this.menuDialog.Location = new System.Drawing.Point(553, 197);
      this.menuDialog.Name = "menuDialog";
      this.menuDialog.Size = new System.Drawing.Size(171, 302);
      this.menuDialog.TabIndex = 4;
      this.menuDialog.Visible = false;
      // 
      // menuText
      // 
      this.menuText.Location = new System.Drawing.Point(3, 3);
      this.menuText.Name = "menuText";
      this.menuText.ReadOnly = true;
      this.menuText.Size = new System.Drawing.Size(165, 22);
      this.menuText.TabIndex = 0;
      this.menuText.TabStop = false;
      this.menuText.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
      // 
      // menuButton
      // 
      this.menuButton.Location = new System.Drawing.Point(3, 31);
      this.menuButton.Name = "menuButton";
      this.menuButton.Size = new System.Drawing.Size(165, 32);
      this.menuButton.TabIndex = 1;
      this.menuButton.Tag = "0";
      this.menuButton.Text = "(menuButton)";
      this.menuButton.UseVisualStyleBackColor = true;
      this.menuButton.Visible = false;
      this.menuButton.Click += new System.EventHandler(this.menuButton_Click);
      // 
      // textAreaTitle
      // 
      this.textAreaTitle.AutoSize = true;
      this.textAreaTitle.Location = new System.Drawing.Point(5, 7);
      this.textAreaTitle.Name = "textAreaTitle";
      this.textAreaTitle.Size = new System.Drawing.Size(97, 17);
      this.textAreaTitle.TabIndex = 6;
      this.textAreaTitle.Text = "(textAreaTitle)";
      // 
      // HurricanePoker
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(732, 505);
      this.Controls.Add(this.textAreaTitle);
      this.Controls.Add(this.menuDialog);
      this.Controls.Add(this.okDialog);
      this.Controls.Add(this.yesNoDialog);
      this.Controls.Add(this.outputArea);
      this.Controls.Add(this.textArea);
      this.Name = "HurricanePoker";
      this.Text = "Hurricane Poker - Using tuProlog";
      this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.HurricanePoker_FormClosed);
      this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.HurricanePoker_FormClosing);
      this.yesNoDialog.ResumeLayout(false);
      this.yesNoDialog.PerformLayout();
      this.okDialog.ResumeLayout(false);
      this.okDialog.PerformLayout();
      this.menuDialog.ResumeLayout(false);
      this.menuDialog.PerformLayout();
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.TextBox textArea;
    private System.Windows.Forms.TextBox outputArea;
    private System.Windows.Forms.FlowLayoutPanel yesNoDialog;
    private System.Windows.Forms.TextBox yesNoText;
    private System.Windows.Forms.Button yesButton;
    private System.Windows.Forms.Button noButton;
    private System.Windows.Forms.FlowLayoutPanel okDialog;
    private System.Windows.Forms.TextBox okText;
    private System.Windows.Forms.Button okButton;
    private System.Windows.Forms.FlowLayoutPanel menuDialog;
    private System.Windows.Forms.TextBox menuText;
    private System.Windows.Forms.Button menuButton;
    private System.Windows.Forms.Label textAreaTitle;
  }
}