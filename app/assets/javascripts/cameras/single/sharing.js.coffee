showError = (message) ->
  Notification.show(message)
  true

showFeedback = (message) ->
  Notification.show(message)
  true

sendAJAXRequest = (settings) ->
  token = $('meta[name="csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  jQuery.ajax(settings)
  true

addSharingCameraRow = (details) ->
  row = $('<tr id="row-share-'+details['share_id']+'">')
  if details.type == "share_request"
    row.attr("share-request-email", details['email'])
  else
    row.attr("share-username", details['user_id'])
    $("#new_owner_email").append("<option value='#{details['user_id']}'>#{details['user_id']}</option>")

  cell = $('<td>', {class: "col-lg-4"})
  cell.append(document.createTextNode(" " + (if details.type == "share_request" then details['email'] else details['user_id'])))
  if details.type == "share_request"
    suffix = $('<small>', {class: "blue"})
    suffix.text(" ...pending")
    cell.append(suffix)
  row.append(cell)

  cell = $('<td>', {class: "col-lg-2"})
  div = $('<div>', {class: "input-group"})
  select = $('<select>', {class: "form-control reveal", "show-class": "show-save"})
  select.focus(onPermissionsFocus)
  option = $('<option>', {value: "minimal"})
  if details.permissions != "full"
    option.attr("selected", "selected")
  option.text("Read Only")
  select.append(option)
  option = $('<option>', {value: "full"})
  if details.permissions == "full"
    option.attr("selected", "selected")
  option.text("Full Rights")
  select.append(option)
  div.append(select)
  cell.append(div)
  row.append(cell)

  cell = $('<td>', {class: "col-lg-2"})
  button = $('<button>', {class: "save show-save btn btn-primary"})
  button.text("Save")
  if details.type == "share"
    button.click(onSaveShareClicked)
  else
    button.click(onSaveShareRequestClicked)
  cell.append(button)
  row.append(cell)

  cell = $('<td>', {class: "col-lg-2"})
  div = $('<div>', {class: "form-group"})
  divPopup =$('<div>', {class: "popbox"})
  span = $('<span>', {class: "open"})
  span.append($('<span>', {class: "remove"}))
  if details.type == "share"
    span.append($(document.createTextNode("Remove")))
    divPopup.append(span)
    divCollapsePopup = $('<div>', {class: "collapse-popup"})
    divBox2 = $('<div>', {class: "box-new"})
    divBox2.append($('<div>', {class: "arrow"}))
    divBox2.append($('<div>', {class: "arrow-border"}))
    divMessage = $('<div>', {class: "margin-bottom-10"})
    divMessage.append($(document.createTextNode("Are you sure?")))
    divBox2.append(divMessage)
    divButtons = $('<div>', {class: "margin-bottom-10"})
    inputDelete = $('<input type="button" value="Yes, Remove">')
    inputDelete.addClass("btn btn-primary delete-btn delete-share")
    inputDelete.attr("camera_id", details["camera_id"])
    inputDelete.attr("share_id", details["share_id"])
    inputDelete.click(onDeleteShareClicked)
    divButtons.append(inputDelete)
    divButtons.append('<div class="btn delete-btn closepopup grey"><div class="text-center" fit>CANCEL</div></div>')
    divBox2.append(divButtons)
    divCollapsePopup.append(divBox2)
    divPopup.append(divCollapsePopup)
    div.append(divPopup)
  else
    span.append($(document.createTextNode("Revoke")))
    divPopup.append(span)
    spanLinkSeperator = $('<span>')
    spanLinkSeperator.append($(document.createTextNode(" | ")))
    divPopup.append(spanLinkSeperator)
    spanResend = $('<span>', {class: "resend-share-request"})
    spanResend.append($(document.createTextNode("Resend")))
    spanResend.attr("camera_id", details["camera_id"])
    spanResend.attr("share_request_id", details["share_id"])
    spanResend.attr("email", details["email"])
    spanResend.click(resendCameraShareRequest)
    divPopup.append(spanResend)
    divCollapsePopup = $('<div>', {class: "collapse-popup"})
    divBox2 = $('<div>', {class: "box-new"})
    divBox2.append($('<div>', {class: "arrow"}))
    divBox2.append($('<div>', {class: "arrow-border"}))
    divMessage = $('<div>', {class: "margin-bottom-10"})
    divMessage.append($(document.createTextNode("Are you sure?")))
    divBox2.append(divMessage)
    divButtons = $('<div>', {class: "margin-bottom-10"})
    inputDelete = $('<input type="button" value="Yes, Revoke">')
    inputDelete.addClass("btn btn-primary delete-btn delete-share-request-control")
    inputDelete.attr("camera_id", details["camera_id"])
    inputDelete.attr("share_request_id", details["share_id"])
    inputDelete.attr("email", details["email"])
    inputDelete.click(onDeleteShareRequestClicked)
    divButtons.append(inputDelete)
    divButtons.append('<div class="btn delete-btn closepopup grey"><div class="text-center" fit>CANCEL</div></div>')
    divBox2.append(divButtons)
    divCollapsePopup.append(divBox2)
    divPopup.append(divCollapsePopup)
    div.append(divPopup)

  cell.append(div)
  row.append(cell)

  row.hide()
  $('#sharing_list_table tbody').append(row)
  row.find('.save').hide()
  row.fadeIn()
  $(".popbox").popbox()
  true

resendCameraShareRequest = ->
  control = $(this)
  data =
    camera_id: control.attr("camera_id")
    email: control.attr("email")
    share_request_id: control.attr("share_request_id")
    user_name: $("#user_name").val()

  onError = (jqXHR, status, error) ->
    showError("Failed to resend camera share request.")
    true
  onSuccess = (data, status, jqXHR) ->
    if data.success
      showFeedback("A notification email has been sent to the specified email address.")
    else
      showFeedback(data.message)
    true

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    type: 'POST'
    url: '/share/request/resend'
  sendAJAXRequest(settings)
  true

onSetCameraAccessClicked = (event) ->
  event.preventDefault()
  selected = $('input[name=sharingOptionRadios]:checked').val()
  button = $('#set_permissions_submit')
  divText = $('#Sharespublic_discoverable')
  cameraId = Evercam.Camera.id

  data = {}
  switch selected
    when "public_discoverable"
      data.public = true
      data.discoverable = true
      $('.show-on-public').show()
      $('.show-on-private').hide()
      divText = $('#Sharespublic_discoverable')
    when "public_undiscoverable"
      data.public = true
      data.discoverable = false
      $('.show-on-public').show()
      $('.show-on-private').hide()
      divText = $('#Sharespublic_undiscoverable')
    else
      data.public = false
      data.discoverable = false
      $('.show-on-public').hide()
      $('.show-on-private').show()
      divText = $('#Sharesprivate')

  onError = (jqXHR, status, error) ->
    showError("Update of camera permissions failed. Please contact support.")
    button.removeAttr('disabled')
    false

  onSuccess = (data, status, jqXHR) ->
    if data.success
      showFeedback("Camera permissions successfully updated.")
      $('.desc').hide()
      divText.show()
    else
      showError("Update of camera permissions failed. Please contact support.")
    button.removeAttr('disabled')
    true

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    type: 'POST'
    url: '/share/camera/' + cameraId

  button.attr('disabled', 'disabled')
  sendAJAXRequest(settings)
  true

getTransferFromUrl = ->
  is_transfer = window.Evercam.request.subpath.
  replace(RegExp("shares", "g"), "").
  replace(RegExp("/", "g"), "")
  if is_transfer is 'transfer'
    $('#change_owner2').modal('show')

onDeleteShareClicked = (event) ->
  event.preventDefault()
  control = $(event.currentTarget)
  row = control.closest('tr')
  data =
    camera_id: control.attr("camera_id")
    email: row.attr('share-username')
  onError = (jqXHR, status, error) ->
    showError("Delete of camera shared failed. Please contact support.")
    false
  onSuccess = (data, status, jqXHR) ->
    if data.success
      onComplete = ->
        row.remove()
      row.fadeOut(onComplete)
      showError("Camera share deleted successfully.")
      if $("#user_name").val() is row.attr('share-username')
        window.location = '/'
    else
      showError("Delete of camera shared failed. Please contact support.")
    true

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    type: 'DELETE'
    url: '/share'
  sendAJAXRequest(settings)
  true

onDeleteShareRequestClicked = (event) ->
  event.preventDefault()
  control = $(event.currentTarget)
  row = control.closest('tr')
  data =
    camera_id: control.attr("camera_id")
    email: row.attr("share-request-email")
  onError = (jqXHR, status, error) ->
    showError("Delete of share request failed. Please contact support.")
    false
  onSuccess = (data, success, jqXHR) ->
    if data.success
      onComplete = ->
        row.remove()
      row.fadeOut(onComplete)
      showError("Camera share request deleted successfully.")
    else
      showError("Delete of share request failed. Please contact support.")
    true
  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    type: 'DELETE'
    url: '/share/request'
  sendAJAXRequest(settings)
  true

onAddSharingUserClicked = (event) ->
  event.preventDefault()
  emailAddress = $('#sharing-user-email').val()
  emailbodyMsg = $('#sharing-message').val()
  if $('#sharingPermissionLevel').val() != "Full Rights"
    permissions = "minimal"
  else
    permissions = "full"
  onError = (jqXHR, status, error) ->
    showError("Failed to share camera.")
    false
  onSuccess = (data, status, jqXHR) ->
    if data.success
      if data.type == "share"
        addSharingCameraRow(data)
        showFeedback("Camera successfully shared with user")
      else
        data.type == "share_request"
        addSharingCameraRow(data)
        showFeedback("A notification email has been sent to the specified email address.")
      $('#sharing-user-email').val("")
      $('#sharing-message').val("")

    else
      message = "Adding a camera share failed."
      switch data.code
        when "camera_not_found_error"
          message = "Unable to locate details for the camera in the system. Please refresh your view and try again."
        when "duplicate_share_error"
          message = "The camera has already been shared with the specified user."
        when "duplicate_share_request_error"
          message = "A share request for that email address already exists for this camera."
        when "share_grantor_not_found_error"
          message = "Unable to locate details for the user granting the share in the system."
        when "invalid_parameters"
          message = "Invalid rights specified for share creation request."
        else
          message = data.message
      showError(message)
    true
  createShare(Evercam.Camera.id, emailAddress, emailbodyMsg, permissions, onSuccess, onError)
  true

onSaveShareClicked = (event) ->
  event.preventDefault()
  button = $(this)
  row = button.closest('tr')
  control = row.find('select')
  data =
    permissions: control.val()
    camera_id: Evercam.Camera.id
    email: row.attr('share-username')
  onError = (jqXHR, status, error) ->
    showError("Update of share failed. Please contact support.")
    false
  onSuccess = (data, success, jqXHR) ->
    if data.success
      showFeedback("Share successfully updated.")
      button.fadeOut()
    else
      showError("Update of share failed. Please contact support.")
    true
  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    type: 'PATCH'
    url: '/share/' + Evercam.Camera.id
  sendAJAXRequest(settings)
  true

onSaveShareRequestClicked = (event) ->
  event.preventDefault()
  button = $(this)
  row = button.closest('tr')
  control = row.find('select')
  data =
    permissions: control.val()
    camera_id: Evercam.Camera.id
    email: row.attr('share-request-email')
  onError = (jqXHR, status, error) ->
    showError("Update of share request failed. Please contact support.")
    false
  onSuccess = (data, success, jqXHR) ->
    if data.success
      showFeedback("Share request successfully updated.")
      button.fadeOut()
    else
      showError("Update of share request failed. Please contact support.")
    true
  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    type: 'PATCH'
    url: '/share/request/'
  sendAJAXRequest(settings)
  true

createShare = (cameraID, email, bodyMessage, permissions, onSuccess, onError) ->
  data =
    camera_id: cameraID
    email: email
    message: bodyMessage
    permissions: permissions

  settings =
    cache: false
    data: data
    dataType: 'json'
    error: onError
    success: onSuccess
    type: 'POST'
    url: '/share'
  sendAJAXRequest(settings)

onPermissionsFocus = (event) ->
  $(this).parent().parent().parent().find("td:eq(2) button").fadeIn()

onSharingOptionsClicked = (event) ->
  test = $(this).val();
  $("div.desc").hide();
  $("#Shares" + test).show();

centerModal = ->
  $(this).css "display", "block"
  $dialog = $(this).find(".modal-dialog")
  offset = ($(window).height() - $dialog.height()) / 2
  # Center modal vertically in window
  $dialog.css "margin-top", offset

initializePopup = ->
  $(".popbox2").popbox
    open: ".open2"
    box: ".box2"
    arrow: ".arrow2"
    arrow_border: ".arrow-border2"
    close: ".closepopup2"

window.initializeSharingTab = ->
  $('#set_permissions_submit').click(onSetCameraAccessClicked)
  $('.delete-share').click(onDeleteShareClicked)
  $('.delete-share-request-control').click(onDeleteShareRequestClicked)
  $('#submit_share_button').click(onAddSharingUserClicked)
  $('.update-share-button').click(onSaveShareClicked)
  $('.update-share-request-button').click(onSaveShareRequestClicked)
  $('.resend-share-request').click(resendCameraShareRequest)
  $('.save').hide()
  $('.reveal').focus(onPermissionsFocus);
  $("input[name$='sharingOptionRadios']").click(onSharingOptionsClicked);
  initializePopup()
  $(".modal").on "show.bs.modal", centerModal
  $(window).on "resize", ->
    $(".modal:visible").each centerModal
  Notification.init(".bb-alert")
  getTransferFromUrl()

window.Evercam.Share.createShare = createShare
