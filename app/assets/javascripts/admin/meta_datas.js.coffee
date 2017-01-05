meta_data_table = undefined

initializeDataTable = ->
  meta_data_table = $("#meta_datatables").DataTable
    aaSorting: [1, "asc"]
    aLengthMenu: [
      [25, 50, 100, 200, -1]
      [25, 50, 100, 200, "All"]
    ]
    columns: [
      {data: "0", sWidth: "100px", visible: false },
      {data: "1", sWidth: "100px" },
      {data: "2", sWidth: "50px" },
      {data: "3", sWidth: "280px" },
      {data: "4", sWidth: "80px" },
      {data: "5", sWidth: "90px" }
    ],
    iDisplayLength: 500
    columnDefs: [
      type: "date-uk"
      targets: 'datatable-date'
    ],
    "oLanguage": {
      "sSearch": "Filter:"
    },
    initComplete: ->
      $("#meta_datatables_length").hide()

appendMe = ->
  options = $(".lic-col-box")
  row = $("#meta_datatables_wrapper").children().first()
  row.children().first().prepend($("#meta_datatables_filter"))
  row.css("margin-bottom", "-11px")
  $("#meta_datatables_filter").removeClass("dataTables_filter")

initNotify = ->
  Notification.init(".bb-alert")

formatDate = (date) ->
  date = new Date(date)
  date.toUTCString()

window.initializeMetaDatas = ->
  initializeDataTable()
  appendMe()
