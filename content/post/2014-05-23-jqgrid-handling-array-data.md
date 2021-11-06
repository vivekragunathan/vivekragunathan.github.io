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
This post is primarily a personal reference. I also consider this a tribute to [Oleg](http://stackoverflow.com/users/315935/oleg), who played a big role in improving my understanding of the jqGrid internals – the way it handles source data types, which, if I may say, led him in discovering a bug in jqGrid.

<!--more-->

If you are working with local array data as the source for jqGrid, meaning you will get the data from the server but want the jqGrid not to talk to the server anymore, and want to have custom handling of the edit functionality/form and delete functionality, it is not going to be straightforward – you need to have a decent understanding of how jqGrid works, and you should be aware of the bug Oleg pointed in our discussion. I repeat this is all about using jqGrid to manage array data locally, no posting to server when you edit or delete, which is where the bug is.

```javascript
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

        // Edit - Custom handling of submit button in the edit form
        onclicksubmit: function (options, postdata) {
            var gridId = 'grid';

            var idInPostdata = this.id + "_id";
            if (postdata[COL_MODEL_ROW_NO] == undefined && postdata[idInPostdata] != undefined) {
                postdata[COL_MODEL_ROW_NO] = postdata[idInPostdata];
            }

            var clone = jQuery.extend(true, {}, postdata);
            $(gridSelector).jqGrid('setRowData', postdata[COL_MODEL_ROW_NO], clone);

            for (var d_index = 0, d_length = this.p.data.length; d_index & lt; d_length;
                ++d_index) {
                var p_data_row = this.p.data[d_index];

                if (p_data_row[INDEX_ROW] == postdata[COL_MODEL_ROW_NO]) {
                    var dataObject = this.p.data[d_index];
                    dataObject[INDEX_NAME] = postdata[COL_MODEL_NAME];
                    dataObject[INDEX_AGE] = postdata[COL_MODEL_AGE];
                    dataObject[INDEX_STATE] = postdata[COL_MODEL_STATE];
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

                for (var pd_index = 0, pd_length = gridData.length; pd_index & lt; pd_length;
                    ++pd_index) {
                    var gd_row = gridData[pd_index];
                    if (gd_row[INDEX_ROW_NO] == rowId) {
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
                    page: this.p.page - 1
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
```


Hope this post helps any poor soul battling the same or similar problem. You should definitely check out the [question](http://stackoverflow.com/questions/21194964/jqgrid-form-edits-saved-to-row-but-all-changes-lost-when-paging-back-or-forth) I had originally raised at [StackOverflow.com](https:www.stackoverflow.com), and the interesting discussion thereon.
