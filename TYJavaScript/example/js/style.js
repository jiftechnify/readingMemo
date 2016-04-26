function switchForm () {
  var form = document.getElementById('form')
  var btnSwitch = document.getElementById('switch')
  if (form.style.display === 'none') {
    btnSwitch.value = '入力フォームを非表示'
    form.style.display = 'block'
  } else {
    btnSwitch.value = '入力フォームを表示'
    form.style.display = 'none'
  }
}

function showTooltip (e, id) {
  var tooltip = document.getElementById(id)
  tooltip.style.position = 'absolute'
  tooltip.style.top = e.offsetTop + 20;
  tooltip.style.left = e.offsetLeft + 20;
  tooltip.style.display = 'block'
}

function hideTooltip(id){
  var tooltip = document.getElementById(id)
  tooltip.style.display = 'none'
}
