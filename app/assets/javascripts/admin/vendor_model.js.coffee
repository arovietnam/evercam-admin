vendor_models_table = null
method = 'POST'
types = ['poe', 'wifi', 'onvif', 'psia', 'audio_io',
         'ptz', 'infrared', 'varifocal', 'sd_card', 'upnp']

sendAJAXRequest = (settings) ->
  token = $('meta[name="csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  xhrRequestChangeMonth = jQuery.ajax(settings)
  true

initializeDataTable = ->
  vendor_models_table = new Datatable
  headers = undefined
  token = $('meta[name="csrf-token"]')

  if token.size() > 0
    headers = 'X-CSRF-Token': token.attr('content')

  vendor_models_table.init
    src: $('#datatable_vendor_models')
    onSuccess: (grid) ->
      # execute some code after table records loaded
      return
    onError: (grid) ->
      # execute some code on network or other general error
      return
    onDataLoad: (grid) ->
      $('.dataTables_info').append ', ' + numberWithCommas($('#total_vendors').val()) + ' vendors'
      $('.dataTables_info').append ', ' + numberWithCommas($('#total_cameras').val()) + ' Cameras'
      return
    loadingMessage: 'Loading...'
    dataTable:
      'bStateSave': false
      'lengthMenu': [
        [ 25, 50, 100, 150 ]
        [ 25, 50, 100, 150 ]
      ]
      'pageLength': 200
      'ajax':
        'method': 'GET'
        'headers': headers
        'url': 'models/load.vendor.model'
      columns: [
        {data: "0", visible: false, 'render': showLogo },
        {data: "1", visible: false},
        {data: "2"},
        {data: "3", 'render': editModel },
        {data: "4"},
        {data: "5"},
        {data: "6"},
        {data: "7"},
        {data: "8"},
        {data: "9"},
        {data: "10"},
        {data: "11"},
        {data: "12", visible: false},
        {data: "13", visible: false, 'render': humanBool},
        {data: "14", visible: false, 'render': humanBool},
        {data: "15", visible: false, 'render': humanBool},
        {data: "16", visible: false, 'render': humanBool},
        {data: "17", visible: false, 'render': humanBool},
        {data: "18", visible: false, 'render': humanBool},
        {data: "19", visible: false, 'render': humanBool},
        {data: "20", visible: false, 'render': humanBool},
        {data: "21", visible: false, 'render': humanBool},
        {data: "22", visible: false, 'render': humanBool},
        {data: "23", visible: false},
        {data: "24", visible: false}

      ],
      'order': [ [ 1, 'asc' ] ]
      initComplete: ->
        $('#vendor-model-list-row').removeClass 'hide'
        $("#div-dropdown-checklist").css('visibility', 'visible')
        $("#datatable_vendor_models_wrapper .row .col-md-8").first().prepend($("#div-dropdown-checklist"))

  vendor_models_table.getTableWrapper().on 'keyup', '.table-group-action-input', (e) ->
    e.preventDefault()
    action = $('.table-group-action-input', vendor_models_table.getTableWrapper())
    vendor_models_table.setAjaxParam 'vendor', action.val()
    vendor_models_table.setAjaxParam 'vendor_model', action.val()
    vendor_models_table.getDataTable().ajax.reload()
    vendor_models_table.clearAjaxParams()
    return

columnsDropdown = ->
  $(".vendor-models-column").on "click", ->
    column = vendor_models_table.getDataTable().column($(this).attr("data-val"))
    column.visible !column.visible()

humanBool = (id, type, row) ->
  if id
    return 'Yes'
  else
    return 'No'

showLogo = (id, type, row) ->
  img = new Image()
  image_url = "http://evercam-public-assets.s3.amazonaws.com/#{id}/#{row[1]}/icon.jpg"
  img.onload = ->

  img.onerror = ->
    $("#image_#{row[1]}").remove()
  img.src = image_url
  return "<img id='image_#{row[1]}' src='#{image_url}'/>"

editModel = (name, type, row) ->
  return "<a style='cursor:pointer;' class='edit-model' val-vendor-id='#{row[0]}' " +
   "val-model-id='#{row[1]}' val-vendor-name='#{row[2]}' val-model-name='#{row[3]}'  " +
   "val-jpg='#{row[4]}' val-h264='#{row[5]}' val-mjpg='#{row[6]}' val-mpeg4='#{row[7]}' " +
   "val-mobile='#{row[8]}' val-lowres='#{row[9]}' val-username='#{row[10]}' val-password='#{row[11]}' " +
   "val-audio='#{row[12]}' val-poe='#{row[13]}' val-wifi='#{row[14]}' val-onvif='#{row[15]}' val-psia='#{row[16]}' " +
   "val-ptz='#{row[17]}' val-infrared='#{row[18]}' val-varifocal='#{row[19]}' val-sd_card='#{row[20]}' " +
   "val-upnp='#{row[21]}' val-audio_io='#{row[22]}' val-shape='#{row[23]}' val-resolution='#{row[24]}'>" +
   "#{name}</a>"

numberWithCommas = (x) ->
  x.toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

sortByKey = (array, key) ->
  array.sort (a, b) ->
    x = a[key]
    y = b[key]
    (if (x < y) then -1 else ((if (x > y) then 1 else 0)))

loadVendors = ->
  data = {}

  onError = (jqXHR, status, error) ->
    false

  onSuccess = (result, status, jqXHR) ->
    vendors = sortByKey(result, "name")
    for vendor in vendors
      if vendor.exid is 'other'
        selected = 'selected="selected"'
        $("#vendor").prepend("<option value='#{vendor.exid}' #{selected}>#{vendor.name}</option>")
      else
        $("#vendor").append("<option value='#{vendor.exid}'>#{vendor.name}</option>")

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    contentType: "application/json; charset=utf-8"
    type: 'GET'
    url: "vendors"

  sendAJAXRequest(settings)
  true

clearForm = ->
  $("#model-id").val('')
  $("#model-id").removeAttr("disabled")
  $("#vendor").val('other')
  $("#name").val('')
  $("#jpg-url").val('')
  $("#mjpg-url").val('')
  $("#mpeg4-url").val('')
  $("#mobile-url").val('')
  $("#h264-url").val('')
  $("#lowres-url").val('')
  $("#default-username").val('')
  $("#default-password").val('')
  $(".thumbnail-img").hide()
  $(".thumbnail-img").attr("src","")
  $("#resolution").val("")
  $("#audio-url").val("")
  $(".center-thumbnail").css("min-height", "160px")
  $(".model-alert").slideUp()
  for type in types
    $("#type-#{type}").prop("checked", false)
    $("#uniform-type-#{type} span").removeClass('checked')
  $("#add-vendor-modal div.caption").text("Add a Model");
  method = 'POST'

handleAddNewModel = ->
  $("#save-model").on 'click', ->

    if $("#model-id").val() is ''
      $(".model-alert").html('Model id can not be empty.')
      $(".model-alert").slideDown()
      return
    if $("#vendor").val() is ''
      $(".model-alert").html('Please select vendor.')
      $(".model-alert").slideDown()
      return
    if $("#name").val() is ''
      $(".model-alert").html('Model name can not be empty.')
      $(".model-alert").slideDown()
      return
    $(".model-alert").slideUp()

    data = {}
    data.name = $("#name").val()
    data.vendor_id = $("#vendor").val()
    data.jpg_url = $("#jpg-url").val() unless $("#jpg-url").val() is ''
    data.mjpg_url = $("#mjpg-url").val() unless $("#mjpg-url").val() is ''
    data.mpeg4_url = $("#mpeg4-url").val() unless $("#mpeg4-url").val() is ''
    data.mobile_url = $("#mobile-url").val() unless $("#mobile-url").val() is ''
    data.h264_url = $("#h264-url").val() unless $("#h264-url").val() is ''
    data.lowres_url = $("#lowres-url").val() unless $("#lowres-url").val() is ''
    data.default_username = $("#default-username").val() unless $("#default-username").val() is ''
    data.default_password = $("#default-password").val() unless $("#default-password").val() is ''

    data.audio_url = $("#audio-url").val() unless $("#audio-url").val() is ''
    data.poe = $("#type-poe").is(":checked")
    data.wifi = $("#type-wifi").is(":checked")
    data.onvif = $("#type-onvif").is(":checked")
    data.psia = $("#type-psia").is(":checked")
    data.audio_io = $("#type-audio_io").is(":checked")
    data.ptz = $("#type-ptz").is(":checked")
    data.infrared = $("#type-infrared").is(":checked")
    data.varifocal = $("#type-varifocal").is(":checked")
    data.sd_card = $("#type-sd_card").is(":checked")
    data.upnp = $("#type-upnp").is(":checked")
    data.resolution = $("#resolution").val() unless $("#resolution").val() is ''

    onError = (jqXHR, status, error) ->
      $(".model-alert").html(jqXHR.responseJSON[0])
      $(".model-alert").slideDown()
      false

    onSuccess = (result, status, jqXHR) ->
      vendor_models_table.getDataTable().ajax.reload()
      $("#close-dialog").click()
      clearForm()
      true
    model_id = ''
    if method is 'POST'
      data.id = $("#model-id").val()
    else
      model_id = "/#{$("#model-id").val()}"

    settings =
      cache: false
      data: data
      dataType: 'json'
      error: onError
      success: onSuccess
      contentType: "application/x-www-form-urlencoded"
      type: method
      url: "models#{model_id}"

    sendAJAXRequest(settings)

onModelClose = ->
  $(".modal").on "hide.bs.modal", ->
    clearForm()

onEditModel = ->
  $("#datatable_vendor_models").on 'click', '.edit-model', ->
    $("#model-id").val($(this).attr("val-model-id"))
    $("#model-id").attr("disabled", true)
    $("#vendor").val($(this).attr("val-vendor-id"))
    $("#name").val($(this).attr("val-model-name"))
    $("#jpg-url").val($(this).attr("val-jpg"))
    $("#mjpg-url").val($(this).attr("val-mjpg"))
    $("#mpeg4-url").val($(this).attr("val-mpeg4"))
    $("#mobile-url").val($(this).attr("val-mobile"))
    $("#h264-url").val($(this).attr("val-h264"))
    $("#audio-url").val($(this).attr("val-audio")) unless $(this).attr("val-audio") is 'null'
    $("#lowres-url").val($(this).attr("val-lowres"))
    $("#default-username").val($(this).attr("val-username"))
    $("#default-password").val($(this).attr("val-password"))
    $("#resolution").val($(this).attr("val-resolution")) unless $(this).attr("val-resolution") is 'null'
    $(".thumbnail-img").attr("src", "http://evercam-public-assets.s3.amazonaws.com/#{$(this).attr("val-vendor-id")}/#{$(this).attr("val-model-id")}/thumbnail.jpg")
    $(".thumbnail-img").show()
    $(".center-thumbnail").css("min-height", "30px")
    $('#add-vendor-modal').modal('show')
    for type in types
      if $(this).attr("val-#{type}") is "true"
        $("#type-#{type}").prop("checked", $(this).attr("val-#{type}"))
        $("#uniform-type-#{type} span").addClass('checked')
    $("#add-vendor-modal div.caption").text("Edit Model");
    method = 'PATCH'

window.initializeVendorModel = ->
  initializeDataTable()
  columnsDropdown()
  loadVendors()
  handleAddNewModel()
  onModelClose()
  onEditModel()