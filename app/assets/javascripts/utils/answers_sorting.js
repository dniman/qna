$(document).on('turbolinks:load', theBestFirst );

function theBestFirst() {
  var item = $('.best-answer')[0];
  
  if (item) {
    var table = $('.answers');
    var header = $('.answers tr:first-child')[0];
    var rows = $('tr[class^="row-answer-"]');
    var sortedRows = [];
    sortedRows.push(item);

    for (var i = 0; i < rows.length; i++){
      if (rows[i] == item) { continue; }
      sortedRows.push(rows[i]);
    };

    var sortedTable = $(document.createElement('table'));
    sortedTable.addClass('answers');
    sortedTable.append(header);

    for(var i = 0; i < sortedRows.length; i++){
      sortedTable.append(sortedRows[i]);
    };
    
    table.replaceWith(sortedTable[0]); 
  };
};
