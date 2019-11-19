window.$ = window.jQuery = require('jquery');

require('jquery-ujs');
require('activestorage');

require('bootstrap3');
require('admin-lte');

require('datatables.net');
require('datatables.net-bs');
require('datatables.net-responsive');
require('datatables.net-responsive-bs');

require('cocoon-js');

require('bootstrap-fileinput/js/locales/pt-BR');
require('bootstrap-fileinput/themes/fa/theme');
require('select2');

require('jquery-maskmoney/dist/jquery.maskMoney');


import '../src/fileinput.js';

import 'jquery.inputmask'
import 'inputmask';


import { Calendar } from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid';

var calendar;

document.addEventListener('DOMContentLoaded', function () {
  var calendarEl = document.getElementById('accommodation_calendar');

  if (calendarEl) {
    calendar = new Calendar(calendarEl, {
      plugins: [interactionPlugin, dayGridPlugin],
      selectable: true,
      // editable: true,
      height: 518,
      locale: 'pt-br',
      events: '/api/accommodations/' + $('#event_accommodation_id').val() + '/events',
      select: function (info) {
        $.rails.enableFormElements($("#accommodation-event-modal form"));
        var modal = $('#accommodation-event-modal');
        info.end.setDate(info.end.getDate() - 1);
        modal.find('#event_name').val('');
        modal.find('#event_eventable_type').val('');
        modal.find('#event_value').val('');
        modal.find('#event_start_date').val(info.startStr);
        modal.find('#event_final_date').val(info.end.toISOString().slice(0, 10));
        modal.find('#event_name').parent().hide();
        modal.find('#event_value').parent().hide();
        modal.modal();
      },
      // eventClick: function (info) {
      //   info.jsEvent.preventDefault();

      //   alert('Event: ' + info.event.title);
      //   alert('View: ' + info.event.id);
      //   alert('View: ' + info.event.editable);

      //   // change the border color just for fun
      //   // info.el.style.borderColor = 'red';
      // },
      eventRender: function (info) {
        if (info.event.extendedProps.kind != 'Reserva') {
          $(info.el).find('.fc-content').append("<a class='pull-right label label-calendar' href='#'><i class='fa fa-close'></i></a>");
          $(info.el).find('.fc-content a').on('click', function() {
            info.event.end.setDate(info.event.end.getDate() - 1);
            var d = info.event.end;
            d.setDate(d.getDate() - 1);
            if (confirm("Deseja realmente apagar evento " + info.event.id + "? " +
              info.event.extendedProps.kind + " de " + info.event.start.toLocaleDateString() + " a " +
              d.toLocaleDateString())) {
              $.ajax({
                url: '/events/' + info.event.id,
                dataType: 'json',
                type: 'DELETE',
                success: function (result) {
                  calendar.refetchEvents();
                }
              });
            }
          });
        }
      }
    });

    calendar.render();
  }
});

function via_cep(input) {
  var form = input.parent().parent().parent();
  $.post("/utils/zipcode", { zipcode: input.val() }, function (data) {
    form.find('input[id$=street]').val(data.response.logradouro);
    form.find('input[id$=district]').val(data.response.bairro);
    form.find('input[id$=complement]').val(data.response.complemento);
    var select = form.find('select[id$=city_id]');
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



$(document).ready(function () {
  
  $('#cpf').inputmask("999.999.999-99");
  
  money();

  var hash = window.location.hash;
  hash && $('ul.nav a[href="' + hash + '"]').tab('show');

  $('.nav-tabs a').click(function (e) {
    $(this).tab('show');
    var scrollmem = $('body').scrollTop() || $('html').scrollTop();
    window.location.hash = this.hash;
    $('html,body').scrollTop(scrollmem);
  });

  $('#event_eventable_type').on('change', function () {
    if (this.value == 'Unavailability') {
      $("#event_name").parent().hide();
      $("#event_value").parent().hide();
    }
    if (this.value == 'SpecialPeriod') {
      $("#event_name").parent().show();
      $("#event_value").parent().show();
    }
  });

  $("#accommodation-event-modal form").on("submit", function (e) {
    e.preventDefault();
    $("#accommodation-event-modal form").find('.has-error').removeClass('has-error');
    $("#accommodation-event-modal form").find('.help-block').text("");
    $.ajax({
      method: "POST",
      dataType: "json",
      url: $(this).attr("action"),
      data: $(this).serialize(),
      success: function (response) {
        $("#accommodation-event-modal").modal('toggle');
        calendar.refetchEvents();
      },
      error: function (response) {
        $.each(response.responseJSON, function (key, value) {
          $("#accommodation-event-modal form").find(".event_" + key).addClass('has-error');
          if (!($("#accommodation-event-modal form" + " .event_" + key).find('.help-block').length)) {
            $("#accommodation-event-modal form").find(".event_" + key).append("<p class='help-block'></p>");
          }
          $("#accommodation-event-modal form").find(".event_" + key).find('.help-block').text(value);
        });
        $.rails.enableFormElements($("#accommodation-event-modal form"));
      }
    });
  });

  $('[data-toggle="tooltip"]').tooltip({ placement: 'top' });

  $(".select2").select2({
    theme: "bootstrap",
    language: 'pt-BR'
  });

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

  $('input[id$=zipcode]').blur(function () {
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
    // $("input[id$=_image]:last").attr('type', 'file');
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
