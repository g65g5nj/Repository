#!/usr/bin/python
#!coding=utf-8

from xml.dom import minidom
import os

localDir = os.path.split(os.path.realpath(__file__))[0]

def getOrCreateElement(doc,node,name):
    lists = doc.getElementsByTagName(name)
    if len(lists) == 0:
        # print(doc.toxml())
        element = doc.createElement(name)
        node.appendChild(element)
    else:
        element = lists[0]
    return element

def setOrCreateTextNode(doc,node,text):
    lists = node.childNodes
    if len(lists) == 0:
        element = doc.createTextNode(text)
        node.appendChild(element)
    else:
        lists[0].data = text
    return node

def fixed_writexml(self, writer, indent="", addindent="", newl=""): 
    # indent = current indentation 
    # addindent = indentation to add to higher levels 
    # newl = newline string 
    writer.write(indent+"<" + self.tagName) 
 
    attrs = self._get_attributes() 
    a_names = attrs.keys() 
    # a_names.sort() 
 
    for a_name in a_names: 
        writer.write(" %s=\"" % a_name) 
        minidom._write_data(writer, attrs[a_name].value) 
        writer.write("\"") 
    if self.childNodes: 
        if len(self.childNodes) == 1 and self.childNodes[0].nodeType == minidom.Node.TEXT_NODE: 
            writer.write(">") 
            self.childNodes[0].writexml(writer, "", "", "") 
            writer.write("</%s>%s" % (self.tagName, newl)) 
            return 
        writer.write(">%s"%(newl)) 
        for node in self.childNodes: 
            if node.nodeType is not minidom.Node.TEXT_NODE: 
                node.writexml(writer,indent+addindent,addindent,newl) 
        writer.write("%s</%s>%s" % (indent,self.tagName,newl)) 
    else: 
        writer.write("/>%s"%(newl)) 
 
minidom.Element.writexml = fixed_writexml

home = os.path.expanduser('~')
settingPath = os.path.join(home,".m2","settings.xml")
if not os.path.exists(settingPath):
    i = settingPath.rfind('/')
    if i < 0:
        i = settingPath.rfind('\\')
    dirPath = settingPath[:i]
    if not os.path.exists(dirPath):
        os.makedirs(dirPath)
    doc = minidom.Document()
else:
    doc = minidom.parse(settingPath)

settings = getOrCreateElement(doc,doc,'settings')
localRepository = getOrCreateElement(doc,settings,'localRepository')

setOrCreateTextNode(doc,localRepository,os.path.join(localDir,'jcenter'))
settings.setAttribute("xmlns","http://maven.apache.org/SETTINGS/1.2.0")
settings.setAttribute("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance")
settings.setAttribute("xsi:schemaLocation","http://maven.apache.org/SETTINGS/1.2.0 https://maven.apache.org/xsd/settings-1.2.0.xsd")

with open(settingPath,mode='w+') as f:
    doc.writexml(f,indent='',addindent='\t',newl='\n',encoding='UTF-8')
    f.close()