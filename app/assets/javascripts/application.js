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
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require infinite-scroll.pkgd.min
//= require_tree .

// Prefectureセレクトボックスに連動してCityセレクトボックスを変更する
$(document).on('change', '#post_prefecture_id', function() {
  return $.ajax({
    type: 'GET',
    url: '/posts/cities_select',
    data: {
      prefecture_id: $(this).val()
    }
  }).done(function(data) {
    return $('#cities_select').html(data);
  });
});

// 無限スクロール
$(document).on('turbolinks:load', function() {
  $('.post-cards').infiniteScroll({
    path: 'nav ul.pagination a[rel=next]',
    append: '.post-cards .post-card',
    history: false,
    status: '.page-load-status',
    hideNav: 'nav ul.pagination',
    button: '.view-more-button',
    scrollThreshold: false
  });
});

// 無限スクロール(user)
$(document).on('turbolinks:load', function() {
  $('.user-cards').infiniteScroll({
    path: 'nav ul.pagination a[rel=next]',
    append: '.user-cards .user-card',
    history: false,
    status: '.page-load-status',
    hideNav: 'nav ul.pagination',
    button: '.view-more-button',
    scrollThreshold: false
  });
});