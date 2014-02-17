/*global $ */
/*jshint browser: true */

$(function()
{
    jQuery.expr[':'].regex = function(elem, index, match) {
        var matchParams = match[3].split(','),
            validLabels = /^(data|css):/,
            attr = {
                method: matchParams[0].match(validLabels) ? 
                            matchParams[0].split(':')[0] : 'attr',
                property: matchParams.shift().replace(validLabels,'')
            },
            regexFlags = 'ig',
            regex = new RegExp(matchParams.join('').replace(/^\s+|\s+$/g,''), regexFlags);
        return regex.test(jQuery(elem)[attr.method](attr.property));
    };
    
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
            $('#input_master_slave').prop('checked', true);
        }
        else
        {
            // login with a read/write user
            $('#input_username').val(window.contactlab.db.rw.username);
            $('#input_password').val(window.contactlab.db.rw.password);
            $('#input_master_slave').prop('checked', false);
        }
    };
    
    // create a checkbox used to ease master/slave selection
    //$('div.item:last-child').after('<div class="item"><label for="input_master_slave">Slave:</label><input type="checkbox" id="input_master_slave" value="master_slave"></div>');
    
    // set the credentials for the db selected on page load
    setCredentials();
    
    // set the credentials for the db selected on combobox select
    $('#select_server').on('change', setCredentials);
    
    // /db(\d+)-?.*(slave).*/.test($('#select_server').find('option:selected').text()))
    
    /*
    $('#input_master_slave').on('change', function() {
        
        // extract the server number
        var n = $('#select_server option:selected').text().replace(/(db(\d+|sys)(-slave)?.*)|(db1(master|slave)-(.*))/, function(str, g1, g2)
        {
            return g2;
        });
        
        alert(n);
        
        if ($(this).is(':checked'))
        {
            
            
            
            // select the slave
            $('#select_server option').each(function(idx, el) {
                
                //new RegExp('db(' + ')-?.*(slave).*')
                //if (/db(\d+)-?.*(slave).* /.test(el.text()))
                //{
                //}
            });
        }
        else
        {
            // select the master
        }
    });
    */
});
