/*global $ */
/*jshint browser: true */

$(function()
{
    if (/^\/login/.test(window.location.pathname) && window.contactlab)
    {
        $('input[name=username]').val(window.contactlab.username);
        $('input[type=password]').val(window.contactlab.password);
        $('input[type=submit]').trigger('click');
    }
});
