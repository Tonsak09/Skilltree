# Skilltree
Developed by Narai Risser for IGME 590 in GODOT

## Purpose 
This is a tool to help manage skilltree data outside of GODOT. By creating and communicating with a CSV file users are able to view their skilltree data in a designer first environment.

## How to setup 
In the main scene of this project you will find the case study version of this project. The most important tool built for interacting with the CSV file is the SkillTreeTool. Here you are required to link up the desired trees that make up your system. Attach all trees in the given array and then apply a desired outputpath for the CSV file. 

You can then press the "Generate Tool" button in the debug category in this tool. This will initilialize out file and setup the base metadata the node's will need. Make sure the any node you want affected by this are children of the trees. 

## Features
Spreadhseet Manipulation: Any edits that are done to the CSV can be loaded into the metadata of buttons. 
Hierachy based dependency: Nodes require parent to be unlocked before they can 
Video Demos: Allows user to link videos on nodes to showcase it 
Cost data: Simple xp costs for nodes 

## Recommended workflow 
Working directly with the CSV file in excel or preferred spreadsheet editor is not recommended. This is because it will lock the file and not allow GODOT the proper access it needs when loading in its data to the nodes. Once you have generated you base file I recommend copying its data somewhere else and then exporting files to replace it. 

## What it does not do 
Once again, this is a tool to allow workflows outside of GODOT. In its current state this tool does not supply functionality to save loaded data between runs of the game. Saving data during a playthrough is up to the user but a resonable option would be to update the CSV to accomodate these changes. 
