# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Toggle description field visibility
@toggleDescription = ->
  descriptionField = document.getElementById('description-field')
  toggleText = document.getElementById('toggle-text')
  
  if descriptionField.style.display == 'none'
    descriptionField.style.display = 'block'
    toggleText.textContent = '- Hide Description'
  else
    descriptionField.style.display = 'none'
    toggleText.textContent = '+ Add Description'

# Show description field if it has content on edit pages
document.addEventListener 'turbolinks:load', ->
  descriptionField = document.getElementById('description-field')
  toggleText = document.getElementById('toggle-text')
  descriptionTextarea = document.querySelector('.description-textarea')
  
  if descriptionTextarea && descriptionTextarea.value.trim() != ''
    descriptionField.style.display = 'block'
    toggleText.textContent = '- Hide Description' if toggleText
