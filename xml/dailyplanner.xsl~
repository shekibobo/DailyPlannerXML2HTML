<?xml version='1.0' encoding='utf-8'?>
<!-- Author: Joshua Kovach
	Date: 29 July 2010
	Instructor: Dr. Robert Adams
	Course: CIS 675 - Compiler Construction
	-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method='html' indent='yes' />
	
	<xsl:template match="/">
	
		<html>
			<head>
				<link rel='stylesheet' type='text/css' href='../style.css' />
			</head>
			<body>
				<table>
					<caption>Daily Planner</caption>
					<tr>
						<td class='label'>Day</td>
						<td class='label'>Morning</td>
						<td class='label'>Afternoon</td>
					</tr>
					<!-- access the child nodes of dailyplanner (unique ids) -->
					<xsl:for-each select='/dailyplanner/*'>
						<tr>
							<td>
								<!-- capitalizing words is ridiculously complicated.
									But, name(.[1]) #=> element_name (the main idea here) -->
								<!-- Output the day / date combo -->
								<xsl:value-of select="concat(translate(substring(name(.[1]),1,1), 
									'smtwf','SMTWF'),substring(name(.[1]),2,
									string-length(name(.[1]))))" />
								<br />
								<span class='time'><xsl:value-of select='@date' /></span>
							</td>
							<!-- output the tasks/times sets -->
							<td>
								<xsl:for-each select='am'>
									<div class='task'><xsl:value-of select='.' />&#160;</div>
									<div class='time'><xsl:value-of select='@time' /></div><br />
								</xsl:for-each>
							</td>
							<td>
								<xsl:for-each select='pm'>
									<div class='task'><xsl:value-of select='.' />&#160;</div>
									<div class='time'><xsl:value-of select='@time' /></div><br />
								</xsl:for-each>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
