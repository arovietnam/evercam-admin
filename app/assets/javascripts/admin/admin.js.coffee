#= require metronic/jquery-1.11.0.min.js
#= require metronic/jquery-migrate-1.2.1.min.js
#= require metronic/jquery-ui-1.10.3.custom.min.js
#= require metronic/bootstrap.min.js
#= require metronic/bootstrap-hover-dropdown.min.js
#= require metronic/jquery.slimscroll.min.js
#= require metronic/jquery.blockui.min.js
#= require metronic/jquery.cokie.min.js
#= require metronic/jquery.uniform.min.js
#= require metronic/jquery.flot.js
#= require metronic/jquery.flot.categories.min.js
#= require metronic/jquery.flot.pie.min.js
#= require metronic/bootstrap-switch.min.js
#= require metronic/select2.min.js
#= require metronic/jquery.dataTables.min.js
#= require metronic/dataTables.bootstrap.js
#= require metronic/bootstrap-datepicker.js
#= require metronic/metronic.js
#= require metronic/datatable.js
#= require metronic/layout.js
#= require metronic/quick-sidebar.js
#= require lib/underscore-min.js
#= require alerts.js
#= require admin/vendor_model.js
#= require admin/vendor.js
#= require admin/cameras.js
#= require admin/snapshots.js
#= require admin/users.js
#= require admin/share_requests.js
#= require admin/merges.js
#= require admin/snapshot_reports.js
#= require admin/archives.js
#= require admin/admins.js
#= require admin/snapshot_extractors.js
#= require admin/snapshot_ex_list.js
#= require admin/dashboard.js
#= require admin/licence_reports.js
#= require admin/timelapse_report.js
#= require admin/meta_datas.js
#= require admin/jquery.datetimepicker.min.js
#= require admin/chosen.jquery.min.js
#= require admin/moment.min.js
#= require admin/file-size.js
#= require admin/fullcalendar.min.js
#= require admin/natural.js
#= require admin/jquery.numericupdown.js

$ ->
  Metronic.init()
  Layout.init()
  QuickSidebar.init()
  $(".table-datatable").dataTable
    aaSorting: [1, "asc"]
    aLengthMenu: [
      [25, 50, 100, 200, -1]
      [25, 50, 100, 200, "All"]
    ]
    iDisplayLength: 50
    columnDefs: [
      type: "date-uk"
      targets: 'datatable-date'
    ]
  handleModelEvents()

$.extend $.fn.dataTableExt.oSort,
  "date-uk-pre": (a) ->
    ukDatea = a.split("/")
    (ukDatea[2] + ukDatea[1] + ukDatea[0]) * 1

  "date-uk-asc": (a, b) ->
    (if (a < b) then -1 else ((if (a > b) then 1 else 0)))

  "date-uk-desc": (a, b) ->
    (if (a < b) then 1 else ((if (a > b) then -1 else 0)))

handleModelEvents = ->
  $(".modal").on "show.bs.modal", centerModal
  $(window).on "resize", ->
    $(".modal:visible").each centerModal

  $(".modal").on "hidden.bs.modal", ->
    #$(this).closest("form")[0].reset()

centerModal = ->
  $(this).css "display", "block"
  $dialog = $(this).find(".modal-dialog")
  offset = ($(window).height() - $dialog.height()) / 2
  if $(window).height() > $dialog.height()
    $dialog.css "margin-top", offset

window.adjustHorizontalScroll = ->
  $('.top-scrollbar').on 'scroll', (e) ->
    $('div.table-scrollable').scrollLeft $('.top-scrollbar').scrollLeft()
  $('div.table-scrollable').on 'scroll', (e) ->
    $('.top-scrollbar').scrollLeft $('div.table-scrollable').scrollLeft()

  $('.top-horizontal-scroll').width $('.table').width()
  $('.top-scrollbar').width $('.table-scrollable').width()

  setTimeout (->
    if $('.top-horizontal-scroll').width() == $('.top-scrollbar').width()
      $('.top-scrollbar').hide()
    else
      $('.top-scrollbar').show()
  ), 500
