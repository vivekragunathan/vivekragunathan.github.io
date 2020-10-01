---
title: 'jqGrid: Handling array data !!!'
author: vivekragunathan
layout: post
date: 2014-05-23T01:43:15+00:00
url: /2014/05/23/jqgrid-handling-array-data/
categories:
  - JavaScript
  - jqGrid
  - jQuery
  - Programming
  - Uncategorized
tags:
  - array data
  - javascript
  - jqgrid
  - programming
  - stackoverflow

---
This post is primarily a personal reference. I also consider this a tribute to [Oleg][1], who played a big role in improving my understanding of the jqGrid internals – the way it handles source data types, which, if I may say, led him in discovering a bug in jqGrid.

<!--more-->

If you are working with local array data as the source for jqGrid, meaning you will get the data from the server but want the jqGrid not to talk to the server anymore, and want to have custom handling of the edit functionality/form and delete functionality, it is not going to be straightforward – you need to have a decent understanding of how jqGrid works, and you should be aware of the bug Oleg pointed in our discussion. I repeat this is all about using jqGrid to manage array data locally, no posting to server when you edit or delete, which is where the bug is.

[code lang=javascript]
  
$('#grid').jqGrid('navGrid',
      
'#pager', {
          
recreateForm: true,

add: false,
          
search: false,
          
refresh: false,

edit: true,
          
edittext: 'Edit',
          
editicon: 'ui-icon-tag',
          
editurl: 'clientArray',

del: true,
          
deltext: 'Delete'
      
}, { // edit options
          
editCaption: 'Fix Error Record',
          
url: 'clientArray',
          
recreateForm: true,
          
closeAfterEdit: true,
          
reloadAfterSubmit: false,
          
beforeShowForm: function (form) {
              
$('#editmod' + gridId).addClass('grid-dialog');
              
// You can disable or alter certain fields in the form if you need.
          
},
          
processing: true, // very important or the custom handling will not work!

// Edit &#8211; Custom handling of submit button in the edit form
          
onclicksubmit: function (options, postdata) {
              
var gridId = 'grid';

var idInPostdata = this.id + "_id";
              
if (postdata[COL\_MODEL\_ROW_NO] == undefined && postdata[idInPostdata] != undefined) {
                  
postdata[COL\_MODEL\_ROW_NO] = postdata[idInPostdata];
              
}

var clone = jQuery.extend(true, {}, postdata);
              
$(gridSelector).jqGrid('setRowData', postdata[COL\_MODEL\_ROW_NO], clone);

for (var d\_index = 0, d\_length = this.p.data.length; d\_index & lt; d\_length;
                  
++d_index) {
                  
var p\_data\_row = this.p.data[d_index];

if (p\_data\_row[INDEX\_ROW] == postdata[COL\_MODEL\_ROW\_NO]) {
                      
var dataObject = this.p.data[d_index];
                      
dataObject[INDEX\_NAME] = postdata[COL\_MODEL_NAME];
                      
dataObject[INDEX\_AGE] = postdata[COL\_MODEL_AGE];
                      
dataObject[INDEX\_STATE] = postdata[COL\_MODEL_STATE];
                      
break;
                  
}
              
}

if (options.closeAfterEdit) {
                  
$.jgrid.hideModal('#editmod' + gridId, {
                      
gb: '#gbox_' + gridId,
                      
jqm: options.jqModal,
                      
onClose: options.onClose
                  
});
              
}

options.processing = true;
              
return {};
          
}
      
}, {}, // add options,
      
{ // delete options
          
processing: true, // very important, else the custom handling will not work!

// Custom handling of the delete functionality.
          
// Prevents posting to the server but handles everything locally.
          
onclickSubmit: function (options, id) {
              
var grid = $('#grid');
              
var gridData = this.p.data;
              
var selectedRows = this.p.multiselect ? this.p.selarrrow : [this.p.selrow];

for (var index = 0, length = selectedRows.length; index & lt; length; ++index) {
                  
var rowId = selectedRows[index];

for (var pd\_index = 0, pd\_length = gridData.length; pd\_index & lt; pd\_length;
                      
++pd_index) {
                      
var gd\_row = gridData[pd\_index];
                      
if (gd\_row[INDEX\_ROW_NO] == rowId) {
                          
gridData.splice(pd_index, 1);
                          
break;
                      
}
                  
}
              
}

// Refresh grid to previous page if the current page is the
              
// last page in the grid; so that when all records of the
              
// last page are deleted, we show the previous page.
              
if (this.p.page === this.p.lastpage) {
                  
grid.jqGrid('setGridParam', {
                      
page: this.p.page &#8211; 1
                  
});
              
}

// Refresh the grid to load the changes
              
grid.trigger('reloadGrid');

$.jgrid.hideModal('#delmod' + gridId, {
                  
gb: '#gbox_' + gridId,
                  
jqm: options.jqModal,
                  
onClose: options.onClose
              
});

options.processing = true;
              
return {};
          
}
      
}, {} // search options
  
);
  
[/code]

Hope this post helps any poor soul battling the same or similar problem. You should definitely check out the [question][2] I had originally raised at [StackOverflow.com][3], and the interesting discussion thereon.

 [1]: http://stackoverflow.com/users/315935/oleg
 [2]: http://stackoverflow.com/questions/21194964/jqgrid-form-edits-saved-to-row-but-all-changes-lost-when-paging-back-or-forth
 [3]: https:www.stackoverflow.com