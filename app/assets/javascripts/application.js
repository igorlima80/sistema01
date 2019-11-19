// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require activestorage/app/assets/javascripts/activestorage

//= require bootstrap3/dist/js/bootstrap
//= require admin-lte/dist/js/adminlte

//= require datatables.net/js/jquery.dataTables
//= require datatables.net-bs/js/dataTables.bootstrap
//= require datatables.net-responsive/js/dataTables.responsive
//= require datatables.net-responsive-bs/js/responsive.bootstrap

//= require cocoon

//= require fileinput
//= require bootstrap-fileinput/js/locales/pt-BR
//= require bootstrap-fileinput/themes/fa/theme

//= require select2/dist/js/select2
//= require select2/dist/js/i18n/pt-BR
//= require jquery.maskMoney.js
//= require jquery.mask.min.js




function via_cep(input) {
  form = input.parent().parent().parent();
  $.post("/utils/zipcode", { zipcode: input.val() }, function(data) {
    form.find('input[id$=street]').val(data.response.logradouro);
    form.find('input[id$=district]').val(data.response.bairro);
    form.find('input[id$=complement]').val(data.response.complemento);
    select = form.find('select[id$=city_id]');
    select.val(select.find('[data-ibge=' + data.response.ibge + ']').val());
  });
}



function money() {
  $('.currency').maskMoney({
    prefix: 'R$ ',
    thousands: '.',
    decimal: ','
  });
}







$(document).ready(function(){
  initializeMasks();
  $('[data-toggle="tooltip"]').tooltip({ placement: 'top' });

  $(".select2").select2({
    theme: "bootstrap",
    language: 'pt-BR'
  });

  $('#cpf').inputmask("999.999.999-99");
 

  $('.datatables').DataTable({
    paging: false,
    searching: false,
    ordering: false,
    info: false,
    responsive: true,
    language: {
      "sEmptyTable": "Nenhum registro encontrado",
      "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
      "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
      "sInfoFiltered": "(Filtrados de _MAX_ registros)",
      "sInfoPostFix": "",
      "sInfoThousands": ".",
      "sLengthMenu": "_MENU_ resultados por página",
      "sLoadingRecords": "Carregando...",
      "sProcessing": "Processando...",
      "sZeroRecords": "Nenhum registro encontrado",
      "sSearch": "Pesquisar",
      "oPaginate": {
        "sNext": "Próximo",
        "sPrevious": "Anterior",
        "sFirst": "Primeiro",
        "sLast": "Último"
      },
      "oAria": {
        "sSortAscending": ": Ordenar colunas de forma ascendente",
        "sSortDescending": ": Ordenar colunas de forma descendente"
      }
    }
  });

  $('.datatables_paginate_and_search').DataTable({
    paging: true,
    searching: true,
    ordering: false,
    info: true,
    responsive: true,
    language: {
      "sEmptyTable": "Nenhum registro encontrado",
      "sInfo": "Mostrando de _START_ até _END_ de _TOTAL_ registros",
      "sInfoEmpty": "Mostrando 0 até 0 de 0 registros",
      "sInfoFiltered": "(Filtrados de _MAX_ registros)",
      "sInfoPostFix": "",
      "sInfoThousands": ".",
      "sLengthMenu": "_MENU_ resultados por página",
      "sLoadingRecords": "Carregando...",
      "sProcessing": "Processando...",
      "sZeroRecords": "Nenhum registro encontrado",
      "sSearch": "Pesquisar",
      "oPaginate": {
        "sNext": "Próximo",
        "sPrevious": "Anterior",
        "sFirst": "Primeiro",
        "sLast": "Último"
      },
      "oAria": {
        "sSortAscending": ": Ordenar colunas de forma ascendente",
        "sSortDescending": ": Ordenar colunas de forma descendente"
      }
    }
  });

  $('input[id$=zipcode]').blur(function(){
    via_cep($(this));
  });

  var $input = $('.fileinput');
  if ($input.length) {
    $input.fileinput({
      theme: 'fa',
      language: 'pt-BR',
      'previewFileType': 'any',
      allowedFileExtensions: ['jpg', 'jpeg', 'png'],
      showRemove: false,
      showClose: false,
      showUpload: false
    });
  }

  $('#setups_variable').on('cocoon:after-insert', function (e, insertedItem) {
    insertedItem.find('.convenience_fields').on('cocoon:after-insert', function (e, insertedItem) {
      insertedItem.parent().parent().parent().find('.accommodation_setups_convenience').hide();
      insertedItem.parent().parent().parent().find('.remove_convenience').hide();
      insertedItem.parent().parent().parent().find('.btn_add_convenience').hide();
    });
    insertedItem.find('.convenience_fields').on('cocoon:before-remove', function (e, insertedItem) {
      insertedItem.parent().parent().parent().find('.accommodation_setups_convenience').show();
      insertedItem.parent().parent().parent().find('.remove_convenience').show();
      insertedItem.parent().parent().parent().find('.btn_add_convenience').show();
    });
  });

  $("#add_photo").
    data("association-insertion-method", 'append').
    data("association-insertion-node", function (link) {
      return link.parent().parent().parent().find('.row:first');
    });

  $('#photos').on('cocoon:after-insert', function (e, insertedItem) {
    $("input[id$=_image]:last").fileinput({
      theme: 'fa',
      language: 'pt-BR',
      'previewFileType': 'any',
      allowedFileExtensions: ['jpg', 'jpeg', 'png'],
      showRemove: false,
      showClose: false,
      showUpload: false
    });
  });
});
