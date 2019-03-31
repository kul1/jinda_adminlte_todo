jQuery ->
    $('#todo').dataTable
        sPaginationType: "full_numbers"
        bJQueryUI: true
    $('#todos').dataTable
        sPaginationType: "full_numbers"
        bJQueryUI: true
        bProcessing: true
        bServerSide: true
        sAjaxSource: $('#todos').data('source')
