Imports System.Diagnostics
Imports System.IO
Imports System.Threading

Public Class MainForm
    Private Sub MainForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Me.Text = "PCTools - Version 0.5 beta"
        lblDeveloper.Text = "Developer: WaqWaq.sa"
        lblContact.Text = "Contact: info@WaqWaq.sa | +966-11-2210799 | Riyadh, Saudi Arabia"
    End Sub

    Private Sub btnSetInterval_Click(sender As Object, e As EventArgs) Handles btnSetInterval.Click
        Dim interval As Integer

        If Not Integer.TryParse(txtInterval.Text, interval) OrElse interval < 1 Then
            MessageBox.Show("Please enter a valid interval in minutes.", "Invalid Input", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim intervalSeconds = interval * 60
        Dim taskName = "RAMCacheCleaner"

        Try
            ' Delete existing task
            Process.Start("schtasks", $"/delete /tn {taskName} /f").WaitForExit()

            ' Create new task
            Dim taskCommand = $"/create /tn {taskName} /tr \"{Application.ExecutablePath}\" /sc minute /mo {interval} /rl highest /f"
            Process.Start("schtasks", taskCommand).WaitForExit()

            MessageBox.Show($"Task created successfully to clean cache every {interval} minute(s).", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("Failed to create the task. Ensure you have administrative privileges.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnCancelTask_Click(sender As Object, e As EventArgs) Handles btnCancelTask.Click
        Dim taskName = "RAMCacheCleaner"

        Try
            Process.Start("schtasks", $"/delete /tn {taskName} /f").WaitForExit()
            MessageBox.Show("Scheduled cleaning task successfully canceled.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show("No task found to cancel or insufficient permissions.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub btnExit_Click(sender As Object, e As EventArgs) Handles btnExit.Click
        Application.Exit()
    End Sub
End Class
