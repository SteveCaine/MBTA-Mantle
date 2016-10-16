MBTA-Mantle
===========

This repository compares two different approaches to parsing JSON data files into custom objects. 

One uses key-value coding to translate the deserialized JSON's data tree into a matching object tree, using simple name-matching to map the data nodes to their equivalent objects and properties.

The other uses the popular Objective-C model framework Mantle to provide more fine-grained control over this mapping, including options to pre-process the JSON data as it populates objects. 

The example data for this project is JSON responses from the Boston MBTA's new [RESTful web service](http://www.mbta.com/rider_tools/developers/) that provides information about the public transit agency's routes and services.

When launched, the app presents a table with two sections -- 'Mantle' and 'KV-Coding' -- each listing the half-dozen sample JSON files stored in the app's bundle. 

Tapping a file name in either section parses that file and creates its matching object tree using the approach represented by that section. The contents of this object tree is logged to Xcode's debugger console, while a simple status message appears briefly underneath the file's name in the table. 

This project uses code from several of my other repositories on GitHub, to provide debug-build logging that falls silent in release builds, and to provide some simple file utilities to manage the JSON files stored in the app bundle. This requires those repositories be cloned into the same directory as this repo. 

To simplify this, my [unix-scripts](https://github.com/SteveCaine/unix-scripts) repository includes a 'cloneall' script to download all my public repositories to the current folder; the script contains detailed instructions on its use. 

This code is distributed under the terms of the MIT license. See file "LICENSE" in this repository for details.

Copyright (c) 2015-16 Steve Caine.<br>
@SteveCaine on github.com
