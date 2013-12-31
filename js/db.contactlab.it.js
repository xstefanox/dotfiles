/*global $ */
/*jshint browser: true */

$(function()
{
    // mark the for fields as read-only
    $('#input_username, #input_password').attr('readonly','readonly');
    $('#input_username, #input_password').css({'color' : 'darkgrey'});
    
    // create a function used to set the login credentials
    var setCredentials = function()
    {
        if (/slave/.test($('#select_server').find('option:selected').text()))
        {
            // login with a readonly user
            $('#input_username').val(window.contactlab.db.ro.username);
            $('#input_password').val(window.contactlab.db.ro.password);
        }
        else
        {
            // login with a read/write user
            $('#input_username').val(window.contactlab.db.rw.username);
            $('#input_password').val(window.contactlab.db.rw.password);
        }
    };
    
    // set the credentials for the db selected on page load
    setCredentials();
    
    // set the credentials for the db selected on combobox select
    $('#select_server').on('change', setCredentials);
});
