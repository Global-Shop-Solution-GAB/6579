<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Custom.aspx.vb" Inherits="GSMobile.Custom" %>

<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="GSMobile" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Custom Transaction</title>
</head>
<body onload="Javascript:CustomTrans.Ctrl1.focus();">
    <form id="CustomTrans" runat="server">
    <script type="text/javascript">
        function stopRKey(evt) 
        {
            var evt = (evt) ? evt : ((event) ? event : null);
            var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
            if ((evt.keyCode == 13) && (node.type == "text")) { return false; }
        }
        document.onkeypress = stopRKey;
    </script>
    <%  Dim uDBFns As New DBFns
        Dim sError = "", sTXID, sCNAME, sSERIAL, sLID, sLabel, sCtrlType, sStyle, sDefaultText, sName, sFieldLength, sOptions(), sTemp As String
        Dim cmdDBComm As OleDbCommand
        Dim drDBComm As OleDbDataReader
        Dim bStatus = False, bReturn As Boolean
        Dim iCtrl = 0, iCt As Integer

        If uDBFns.ConDBComm.State <> 1 Then
            uDBFns.OpenCommonDBConnection(sError, bReturn)
            If bReturn = False Then
                uDBFns.ConDBComm.Open()
            End If
        End If
        
        sTXID=Request.Params("sTXID")
		sCNAME=Request.Params("sCNAME")
		sSERIAL=Request.Params("sSERIAL")
		
		
        uDBFns.GetDBFieldValueComm("TName","Mobile_Custom_Trans","TXID='"+ cStr(sTXID) +"'",,,lblTransName.Text)
        
        cmdDBComm = uDBFns.ConDBComm.CreateCommand
        cmdDBComm.CommandText = "select * from Mobile_Custom_Labels where TXID='" + sTXID + "' Order by OrderNo, Label"
    %>
    <div>
        <table align="center">
            <tr><td align="center"><asp:ImageButton ID="ImgGSLogo" runat="server" SkinID="GSLogoButton"  CausesValidation="False" PostBackUrl="~/Pages/MainMenu.aspx"/></td></tr>
            <tr><td>
                <table  align="center">
                    <tr><td align="center" colspan="2" style=" background-color:#95C26C;"><asp:Label ID="lblTransName" runat="server" CssClass="TransName"></asp:Label></td></tr>
                    <%  Try
                            drDBComm = cmdDBComm.ExecuteReader
                            
                            Do While drDBComm.Read
                                iCtrl = iCtrl + 1
                                sName = "Ctrl" + CStr(iCtrl)
                                sCtrlType = Trim(CStr(drDBComm("ControlType")))
                                sLID = CStr(drDBComm("LID"))
                                sLabel = CStr(drDBComm("Label"))
                                sDefaultText = CStr(drDBComm("DefaultText"))
                                sFieldLength = CStr(drDBComm("FieldLength"))
                    %>          <tr>

                                <%  'Dropdown list
                                    If sCtrlType = "4" Then
                                        sTemp = uDBFns.GetAllDBValuesComm("Option", "select distinct Option from Mobile_Custom_Option where TXID='" + sTXID + "' and LID='" + sLID + "' Order by Option")
                                        sOptions = Split(sTemp, "*!*")
                                %>      <td><%=sLabel%></td>
				                        <td><%  Response.Write("<SELECT class=""DropDown"" id=" + sName + " name=" + sName + ">")
				                                For iCt = 1 To UBound(sOptions) Step 1
				                                    If Trim(sDefaultText) = sOptions(iCt) Then
				                                        Response.Write("<OPTION selected value=""" + sDefaultText + """>" + sDefaultText + "</OPTION>")
				                                    Else
				                                        Response.Write("<OPTION value=""" + sOptions(iCt) + """>" + sOptions(iCt) + "</OPTION>")
				                                    End If
				                                Next
				                                Response.Write("</SELECT>")
                                            %></td>
                                <%  End If%>

                                <%  'Check Box
                                    If sCtrlType = "2" Then
                                %>      <td>&nbsp;</td>
                                        <td><% If UCase(sDefaultText) = "CHECKED" Then
                                                    Response.Write("<INPUT class=""CheckBox"" type=""checkbox"" name=""" + sName + """ checked>" + sLabel)
                                                Else
                                                    Response.Write("<INPUT class=""CheckBox"" type=""checkbox"" name=""" + sName + """>" + sLabel)
                                                End If
                                            %></td>
                                <%  End If%>

                                <%  'Text Box
                                    If sCtrlType = "16" Then
                                %>      <td><%=sLabel%></td>
										<td><% If sLabel = "Serial Number *required" Then
											        Response.Write("<INPUT class=""TextBox"" type=""text"" id=" + sName + " name=" + sName + " value=""" + sSERIAL + """ maxlength=" + sFieldLength + ">")
											   Else
											       If sLabel = "Customer" Then
												        Response.Write("<INPUT class=""TextBox"" type=""text"" id=" + sName + " name=" + sName + " value=""" + sCNAME + """ maxlength=" + sFieldLength + ">")
											       Else
												        Response.Write("<INPUT class=""TextBox"" type=""text"" id=" + sName + " name=" + sName + " value=""" + sDefaultText + """ maxlength=" + sFieldLength + ">")
											       End If
										       End If
									    %></td>
                                <%  End If%>
                                
                                <%  'Label
                                    If sCtrlType = "1" Then
                                        sStyle = "color:" + sDefaultText
                                %>      <td colspan="2" align="left" style=<%=sStyle%>><%=sLabel%></td>
                                <%  End If%>
                                
                                <%  'Radio-Button
                                    If sCtrlType = "8" Then
                                        sTemp = uDBFns.GetAllDBValuesComm("Option", "select distinct Option from Mobile_Custom_Option where TXID='" + sTXID + "' and LID='" + sLID + "' Order by Option")
                                        sOptions = Split(sTemp, "*!*")
                                %>      <td><%=sLabel%></td>
				                        <td><%  For iCt = 1 To UBound(sOptions) Step 1
				                                    If iCt <> LBound(sOptions) Then Response.Write("<br>")
				                                    If Trim(sDefaultText) = "" And iCt = LBound(sOptions) Then
				                                        Response.Write("<Input class=""RadioButton"" type=radio checked id=""" + sName + """ name=""" + sName + """ value=""" + sOptions(iCt) + """>" + sOptions(iCt) + "</input>")
				                                    ElseIf sDefaultText = sOptions(iCt) Then
				                                        Response.Write("<Input class=""RadioButton"" type=radio checked id=""" + sName + """ name=""" + sName + """ value=""" + sOptions(iCt) + """>" + sOptions(iCt) + "</input>")
				                                    Else
				                                        Response.Write("<Input class=""RadioButton"" type=radio id=""" + sName + """ name=""" + sName + """ value=""" + sOptions(iCt) + """>" + sOptions(iCt) + "</input>")
				                                    End If
				                                Next
                                        %></td>
                                <%  End If%>
                                </tr>
                    <%      loop
                        Catch ex As Exception
                            ex.ToString()
                    End Try
                    
                    If iCtrl = 0 Then
                        Submit.Style.Add("Display","None")
                    %>
                        <tr><td align="center" colspan="2">Controls were not set up for this transaction.</td></tr>
                        <tr><td align="center" colspan="2">Use 'GS Mobile Custom Transaction' to assign Controls and labels.</td></tr>
                    <%End If %>
                </table>
            </td></tr>
            <tr><td >&nbsp;</td></tr>
            <tr id="Submit" runat="server"><td align="center" ><asp:Button ID="cmdSubmit" runat="server" Text="Submit" CssClass="cmdButton"/></td></tr>
            <tr><td align="center" ><br /><br /><asp:ImageButton ID="imgBtnHome" runat="server" CausesValidation="False" 
                    SkinID="HomeLogo" PostBackUrl="~/Pages/MainMenu.aspx"/></td></tr>
        </table>   
    </div>
    </form>
</body>
</html>
