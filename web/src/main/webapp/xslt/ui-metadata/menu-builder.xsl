<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon"
  exclude-result-prefixes="#all">

  <!--
    Build the menu on top of the metadata  
  to switch view mode and tabs in a view. 
  -->
  <xsl:template name="menu-builder">
    <xsl:param name="config" as="node()"/>

    <xsl:variable name="currentView" select="$config/editor/views/view[tab/@id = $tab]"/>

    <div class="gn-scroll-spy"
      data-gn-scroll-spy="gn-editor-{$metadataId}"
      data-watch=""
      data-all-depth="{if ($isFlatMode) then 'true' else 'false'}"/>

    <ul class="nav nav-tabs">
      <!-- Make a drop down choice to swith to one view to another -->
      <li class="dropdown" id="gn-view-menu-{$metadataId}">
        <a class="dropdown-toggle" data-toggle="dropdown" href="" 
          title="{$i18n/selectView}">
          <i class="fa fa-eye"></i>
          <b class="caret"/>
        </a>
        <ul class="dropdown-menu dropdown-menu-right">
          <!-- links -->
          <xsl:choose>
            <xsl:when test="$isTemplate = 's'">
              <li>
                <xsl:if test="'simple' = $currentView/@name">
                  <xsl:attribute name="class">disabled</xsl:attribute>
                </xsl:if>
                <a data-ng-click="switchToTab('simple', '')" href="">
                  <xsl:value-of select="$strings/*[name() = 'simple']"/>
                </a>
              </li>
              <li>
                <xsl:if test="'xml' = $currentView/@name">
                  <xsl:attribute name="class">disabled</xsl:attribute>
                </xsl:if>
                <a data-ng-click="switchToTab('xml', '')" href="">
                  <xsl:value-of select="$strings/*[name() = 'xml']"/>
                </a>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <xsl:for-each select="$config/editor/views/view[not(@disabled='true')]">

                <xsl:variable name="isViewDisplayed"
                              as="xs:boolean"
                              select="gn-fn-metadata:check-viewtab-visibility(
                                        $schema, $metadata, $serviceInfo,
                                        @displayIfRecord,
                                        @displayIfServiceInfo)"/>


                <xsl:if test="$isViewDisplayed">
                  <li>
                    <xsl:if test="@name = $currentView/@name">
                      <xsl:attribute name="class">disabled</xsl:attribute>
                    </xsl:if>
                    <!-- When a view contains multiple tab, the one with
                  the default attribute is the one to open -->
                    <a data-ng-click="switchToTab('{tab[@default]/@id}', '{tab[@default]/@mode}')" href="">
                      <xsl:variable name="viewName" select="@name"/>
                      <xsl:value-of select="$strings/*[name() = $viewName]"/>
                    </a>
                  </li>
                </xsl:if>
              </xsl:for-each>
              
              <li class="divider"/>
              <li>
                <a data-ng-click="toggleAttributes(true)" href="">
                  <i class="fa"
                    data-ng-class="gnCurrentEdit.displayAttributes ? 'fa-check-square-o' : 'fa-square-o'"/>
                  &#160;<span data-translate="">toggleAttributes</span>
                </a>
              </li>
              <li>
                <a data-ng-click="toggleTooltips(true)" href="">
                  <i class="fa"
                    data-ng-class="gnCurrentEdit.displayTooltips ? 'fa-check-square-o' : 'fa-square-o'"/>
                  &#160;<span data-translate="">toggleTooltips</span>
                </a>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </ul>
      </li>
      
      
      <!-- Make a tab switcher for all tabs of the current view -->
      <xsl:if test="count($currentView/tab) > 1">
        <xsl:apply-templates mode="menu-builder"
          select="$config/editor/views/view[tab/@id = $tab]/tab[not(@toggle)]"/>


        <!-- Some views may define tab to be grouped in an extra button -->
        <xsl:if test="count($config/editor/views/view[tab/@id = $tab]/tab[@toggle]) > 0">
          <li class="dropdown">
            <a class="dropdown-toggle" data-toggle="dropdown" href="" 
              title="{$i18n/moreTabs}">
              <i class="fa fa-ellipsis-h"></i>
              <b class="caret"/>
            </a>
            <ul class="dropdown-menu">
              <!-- links -->
              <xsl:for-each select="$config/editor/views/view[tab/@id = $tab]/tab[@toggle]">
                <li>
                  <xsl:if test="$tab = @id">
                    <xsl:attribute name="class">disabled</xsl:attribute>
                  </xsl:if>
                  <a href="">
                    <xsl:if test="$tab != @id">
                      <xsl:attribute name="data-ng-click" 
                        select="concat('switchToTab(''', @id, ''', ''', @mode, ''')')"/>
                    </xsl:if>
                    <xsl:variable name="tabId" select="@id"/>
                    <xsl:value-of select="$strings/*[name() = $tabId]"/>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </li>
        </xsl:if>
      </xsl:if>
      
    </ul>
  </xsl:template>


  <!-- Create a link to a tab based on its identifier -->
  <xsl:template mode="menu-builder" match="tab">
    <xsl:variable name="isTabDisplayed"
                  as="xs:boolean"
                  select="gn-fn-metadata:check-viewtab-visibility(
                                        $schema, $metadata, $serviceInfo,
                                        @displayIfRecord,
                                        @displayIfServiceInfo)"/>
    <!-- When tab displayIf filter return false, the tab is disabled.
     Another option would be to completely hide it:
    <xsl:if test="$isTabDisplayed">
    </xsl:if>
    -->
    <li class="{if ($tab = @id) then 'active' else ''} {if ($isTabDisplayed) then '' else 'disabled'}">
      <a href="">
        <xsl:if test="$tab != @id and $isTabDisplayed">
          <xsl:attribute name="data-ng-click"
            select="concat('switchToTab(''', @id, ''', ''', @mode, ''')')"/>
        </xsl:if>
        <xsl:variable name="tabId" select="@id"/>
        <xsl:value-of select="$strings/*[name() = $tabId]"/>
      </a>
    </li>

  </xsl:template>
</xsl:stylesheet>
