jQuery ->
	$('#todo').dataTable
		sPaginationType: "full_numbers"
		bJQueryUI: true
	$('#todos').dataTable
		sPaginationType: "full_numbers"
		bJQueryUI: true
		bProcessing: true
		bServerSide: true
		select: true
		sAjaxSource: $('#todos').data('source')
		columnDefs:
		  orderable: false
		  className: 'select-checkbox'
		  targets: 0

