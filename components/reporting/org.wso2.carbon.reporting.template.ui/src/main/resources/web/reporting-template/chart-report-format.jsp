<!--
~ Copyright (c) 2005-2010, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
~
~ WSO2 Inc. licenses this file to you under the Apache License,
~ Version 2.0 (the "License"); you may not use this file except
~ in compliance with the License.
~ You may obtain a copy of the License at
~
~ http://www.apache.org/licenses/LICENSE-2.0
~
~ Unless required by applicable law or agreed to in writing,
~ software distributed under the License is distributed on an
~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
~ KIND, either express or implied. See the License for the
~ specific language governing permissions and limitations
~ under the License.
-->

<%@ page import="org.apache.axis2.context.ConfigurationContext" %>
<%@ page import="org.wso2.carbon.CarbonConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIUtil" %>
<%@ page import="org.wso2.carbon.utils.ServerConstants" %>
<%@ page import="org.wso2.carbon.ui.CarbonUIMessage" %>
<%@ page import="org.wso2.carbon.reporting.template.stub.ReportTemplateAdminStub.*" %>
<%@ page import="org.wso2.carbon.reporting.template.ui.client.ReportTemplateClient" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://wso2.org/projects/carbon/taglibs/carbontags.jar" prefix="carbon" %>
<fmt:bundle basename="org.wso2.carbon.reporting.template.ui.i18n.Resources">

<carbon:breadcrumb label="add.report.step2"
                   resourceBundle="org.wso2.carbon.reporting.template.ui.i18n.Resources"
                   topPage="false" request="<%=request%>"/>

<script type="text/javascript">

    function submitChartReport() {
        document.chartReportFormat.action = '../../fileupload/upload';
        var reportTitle = document.getElementById("reportTitle").value;
        if (reportTitle == '') {
                CARBON.showErrorDialog('Please enter a title for the report.');

            return false;
        }

        var counter = 0,
                i = 0,
                fieldsStr = '',
                input_obj = document.getElementsByTagName('input');

        for (i = 0; i < input_obj.length; i++) {
            if (input_obj[i].type === 'checkbox' && input_obj[i].checked === true) {
                counter++;
                fieldsStr = fieldsStr + ',' + input_obj[i].value;
            }
        }
        if (counter > 0) {
            fieldsStr = fieldsStr.substr(1);
        }
        var msg = checkFontSize();
        if (msg != '') {
                CARBON.showErrorDialog(msg);
            return false;
        }
        document.getElementById('selectedCheckBox').value = fieldsStr;
        var filePath = document.getElementById('logo').value;
        resolveFileName(filePath);
        document.chartReportFormat.submit();
        return true;
    }

    function checkFontSize() {
        var input_obj = document.getElementsByTagName('input');
        var i;
        var msg = '';
        for (i = 0; i < input_obj.length; i++) {
            if (input_obj[i].name.indexOf('size') != -1) {
                if(input_obj[i].value != ''){
                    if (parseInt(input_obj[i].value) != input_obj[i].value) {
                    msg = 'Please enter integer values for font size.';
                    return msg;
                }
                }
                else{
                    msg = 'Font size fields is empty. Please enter a integer value';
                    return msg;
                }

            }
        }
        return msg;
    }

    function cancelChartData() {
        location.href = "../reporting_custom/select-report.jsp";
    }

    function resolveFileName(filepath) {
        if (filename != '') {
            var filename = "";
            if (filepath.indexOf("\\") != -1) {
                filename = filepath.substring(filepath.lastIndexOf('\\') + 1, filepath.length);
            } else {
                filename = filepath.substring(filepath.lastIndexOf('/') + 1, filepath.length);
            }
            document.getElementById('imageName').value = filename;
        }
        else {
            document.getElementById('imageName').value = '';
        }
    }

    function prev(){
        history.go(-1);
    }

</script>

<script>

//$(window).bind("load", function() {
//     $('tbody.columnBody') .toggle();
//});
//
//    $(document).ready(function(){
//	$('table.normal-nopadding tr.columnDiv td.middle-header') .click(
//		function() {
//			$(this) .parents('table.normal-nopadding') .children('tbody.columnBody') .toggle();
//		}
//	)
//});



</script>

<%
    String serverURL = CarbonUIUtil.getServerURL(config.getServletContext(), session);
    ConfigurationContext configContext =
            (ConfigurationContext) config.getServletContext().getAttribute(CarbonConstants.CONFIGURATION_CONTEXT);
    String cookie = (String) session.getAttribute(ServerConstants.ADMIN_SERVICE_COOKIE);

    String message = "";
    ChartReportDTO report;
    ReportTemplateClient client = null;
    String repType = request.getParameter("reportType");
    String heading = "";
    if(repType != null){
        if(repType.equalsIgnoreCase("bar_chart_type_report"))
            heading = "Bar Chart Report";
        else if(repType.equalsIgnoreCase("line_chart_type_report"))
            heading = "Line Chart Report";
        else if (repType.equalsIgnoreCase("area_chart_type_report"))
            heading = "Area Chart Report";
        else if(repType.equalsIgnoreCase("stacked_bar_chart_type_report"))
            heading = "Stacked Bar Chart Report";
        else if(repType.equalsIgnoreCase("stacked_area_chart_type_report"))
            heading = "Stacked Area Chart Report";
         else if(repType.equalsIgnoreCase("xy_bar_chart_type_report"))
            heading = "XY Bar Chart Report";
         else if(repType.equalsIgnoreCase("xy_line_chart_type_report"))
            heading = "XY Line Chart Report";
        else if(repType.equalsIgnoreCase("xy_area_chart_type_report"))
            heading = "XY Area Chart Report";
        else if(repType.equalsIgnoreCase("pie_chart_type_report"))
            heading = "Pie Chart Report";
    }
    try {
        client = new ReportTemplateClient(configContext, serverURL, cookie);
        report = (ChartReportDTO) session.getAttribute("chart-report");
        message = report.getReportName();
    } catch (Exception e) {
        CarbonUIMessage.sendCarbonUIMessage(e.getMessage(), CarbonUIMessage.ERROR, request, e);
%>
<script type="text/javascript">
    CARBON.showErrorDialog('<%=e.getMessage()%>', function () {
            location.href = "../reporting-template/chart-report-format.jsp";
        });
</script>
<%
    }
    String success = request.getParameter("success");
    if(success != null && success.equalsIgnoreCase("false")){
     %>
      <script type="text/javascript">
            CARBON.showErrorDialog('Only image files can be selected to logo.', function() {
            location.href = "../reporting-template/chart-report-format.jsp";
        }, function () {
            location.href = "../reporting-template/chart-report-format.jsp";
        });
      </script>
<%    }
%>



<%!
    private String includeFontStyle(String elementName, String title, ReportTemplateClient client) {
        String[] fonts = client.getAvailableFontNames();
        String[] aligns = client.getAlignments();
        String htmlFontTable = "" +


                "<tr> \n" +
                "                <th><u>" + title + " Font Style:" +
                "                    </u></th> \n" +
                "                </tr>\n" +
                "            <tr>\n" +
                "                <td width=\"180px\">Font Name <span\n" +
                "                        class=\"required\">*</span></td>\n" +
                "                <td><select name=\"font" + elementName + "style\"\n" +
                "                           id=\"font" + elementName + "style\">\n" +
                getOptionString(fonts, 0) + "</select>\n" +

                "                </td>\n" +
                "            \n" +
                "             <td width=\"180px\">Font Size" + "<span\n" +
                "                        class=\"required\">*</span></td>\n" +
                "                <td><input name=\"font" + elementName + "size\"\n" +
                "                           id=" + "\"font" + elementName + "size\"" + "value=\"12\"/>\n" +
                "                </td>\n" +
                "            \n" +
                "</tr> \n <tr>" +
                "             <td width=\"180px\">Font Color" + "<span\n" +
                "                        class=\"required\">*</span></td>\n" +
                "                <td><input class=\"color\" value=\"000000\" name=\"font" + elementName + "color\"\n" +
                "                           id=" + "\"font" + elementName + "color\"" + "/>\n" +
                "                </td>\n" +
                "             <td width=\"180px\">Background Color" + "<span\n" +
                "                        class=\"required\">*</span></td>\n" +
                "                <td><input class=\"color\" value=\"FAFAFA\" name=\"" + elementName + "BgColor\"\n" +
                "                           id=" + "\"font" + elementName + "size\"" + "/>\n" +
                "                </td>\n" +
                "            \n" +
                "            \n" +
                "\n</tr>\n" +
                "<tr>\n" +
                "                <td width=\"180px\">Bold</td>\n" +
                "                <td><input type=\"checkbox\" name=\"" + elementName + "Bold\"\n" +
                "                           id=\"" + elementName + "Bold\" value=\"" + elementName + "Bold\"/>\n" +
                "                </td>\n" +
                "            \n" +
                "             <td width=\"180px\">Italic" + "</td>\n" +
                "                <td><input type=\"checkbox\" name=\"" + elementName + "Italic\"\n" +
                "                           id=\"" + elementName + "Italic\" value=\"" + elementName + "Italic\"/>\n" +
                "                </td>\n" +
                "</tr> \n <tr>" +
                "            \n" +
                "             <td width=\"180px\">Strike-through" + "</td>\n" +
                "                <td><input type=\"checkbox\" name=\"" + elementName + "Strike\"\n" +
                "                           id=\"" + elementName + "Strike\" value=\"" + elementName + "Strike\"/>\n" +
                "                </td>\n" +
                "             <td width=\"180px\">Underline" + "</td>\n" +
                "                <td><input type=\"checkbox\" name=\"" + elementName + "underline\"\n" +
                "                           id=\"" + elementName + "underline\" value=\"" + elementName + "underline\"/>\n" +
                "                </td>\n" +
                "</tr>\n" + "" +
                " <tr>" +
                "            \n" +
                "             <td width=\"180px\">Text Alignment" + "</td>\n" +
                "                <td><select name=\"" + elementName + "Alignment\"\n" +
                "                           id=\"" + elementName + "Alignment\">\n" +
                getOptionString(aligns, 0) + "</select>\n" +
                "                </td>\n" +
                "</tr>\n";


        return htmlFontTable;
    }


    private String getOptionString(String[] array, int id) {
        String allStr = "";
        for (int i = 0; i < array.length; i++) {
            String aElement = array[i];
            String tempStr = "<option value=\"" + aElement + "\"";
            if (i == id) {
                tempStr = tempStr + "selected=\"selected\"";
            }
            tempStr = tempStr + ">\n" + aElement + "\n" + "</option>\n";
            allStr = allStr + tempStr;
        }
        return allStr;
    }

    private String[] getColumnIndex(int noOfCols) {
        String[] indexes = new String[noOfCols];
        for (int i = 0; i < noOfCols; i++) {
            indexes[i] = String.valueOf(i + 1);
        }
        return indexes;
    }
%>
<script type="text/javascript" src="js/jscolor.js"></script>


<div id="middle">
    <h2>Add <%=heading%> - Step 2</h2>

    <div id="workArea">

        <form id="chartReportFormat" name="chartReportFormat" enctype="multipart/form-data" action="" method="POST">
            <table class="styledLeft">
                <thead>
                <tr>
                    <th><span style="float: left; position: relative; margin-top: 2px;">
                            <fmt:message key="chart.header.style"/></span>
                    </th>
                </tr>
                </thead>
                <tbody>


                <tr>
                    <td>
                        <table class="normal-nopadding">
                            <tbody>

                            <tr>
                                <td width="180px"><fmt:message key="report.title"/> <span
                                        class="required">*</span></td>
                                <td><input name="reportTitle"
                                           id="reportTitle"/>
                                </td>
                            </tr>

                            <tr>
                                <td width="180px"><fmt:message key="report.logo"/></td>
                                <td><input type="file" name="logo"
                                           id="logo"/>
                                </td>
                                <input type="hidden" name="imageName" id="imageName">
                            </tr>

                            <tr>
                                <td width="180px"><fmt:message key="background.color"/> <span
                                        class="required">*</span></td>
                                <td><input class="color" value="FAFAFA" name="reportColor"
                                           id="reportColor"/>
                                </td>
                            </tr>

                            <tr>
                                <input type="hidden" name="selectedCheckBox" id="selectedCheckBox">
                            </tr>

                            <%
                                if(null != client){
                            %>
                            <%=includeFontStyle("reportHeader", "Report Header", client)%>
                            <%
                                }
                            %>
                            </tbody>
                          </table>

                          <table class="normal-nopadding">
                            <thead>
                            <tr class = "columnDiv">
                                <td colspan="6" class="middle-header">
                                    <fmt:message key="chart.body"/>
                                </td>
                            </tr>
                            </thead>
                            <tbody class="columnBody">
                             <tr>
                                <td width="180px"><fmt:message key="chart.title"/></td>
                                <td><input id="chartTitle" name="chartTitle"/>
                                </td>
                            </tr>

                             <tr>
                                <td width="180px"><fmt:message key="chart.subTitle"/></td>
                                <td><input id="chartSubTitle" name="chartSubTitle"/>
                                </td>
                            </tr>

                              <tr>
                                <td width="180px"><fmt:message key="chart.back.color"/></td>
                                <td><input class="color" id="chartBgColor" name="chartBgColor"/>
                                </td>
                            </tr>
                            <%if(repType != null && !repType.equalsIgnoreCase("pie_chart_type_report")){ %>

                             <tr>
                                <td width="180px"><fmt:message key="x.axis.label"/></td>
                                <td><input id="xDataLabel" name="xDataLabel"/>
                                </td>
                            </tr>

                            <tr>
                                <td width="180px"><fmt:message key="y.axis.label"/></td>
                                <td><input id="yDataLabel" name="yDataLabel"/>
                                </td>
                            </tr>
                             <%
                                 }
                             %>
                            <input type="hidden" id="reportType" name=reportType value="<%=request.getParameter("reportType")%>"/>
                            </tbody>
                        </table>
                    </td>
                </tr>

                <table class="normal-nopadding">
                    <tbody>

                    <tr>
                        <td class="buttonRow" colspan="2">
                            <input type="button" value="<fmt:message key="create"/>"
                                   class="button" name="create"
                                   onclick="submitChartReport();"/>
                             <input type="button" value="<fmt:message key="back"/>"
                                   class="button" name="back"
                                   onclick="javascript:prev();"/>
                                <%--<input type="submit" value="submit report"--%>
                                <%--class="button" name="submitButton"/>--%>
                            <input type="button" value="<fmt:message key="cancel"/>"
                                   name="cancel" class="button"
                                   onclick="javascript:cancelChartData();"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
                </tbody>
            </table>
        </form>
    </div>
</div>


</fmt:bundle>
