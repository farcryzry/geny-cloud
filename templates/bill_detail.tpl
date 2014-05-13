<div>
    <div class="row" style="padding:10px">
        <div class="well col-xs-12 col-sm-12 col-md-12">
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6">
                    <address>
                        <strong>Elf Cafe</strong>
                        <br>
                        2135 Sunset Blvd
                        <br>
                        Los Angeles, CA 90026
                        <br>
                        <abbr title="Phone">P:</abbr> (213) 484-6829
                    </address>
                </div>
                <div class="col-xs-6 col-sm-6 col-md-6 text-right">
                    <p>
                        <em>Date: {{detail['Date']}}</em>
                    </p>

                    <p>
                        <em>Receipt #: 123456</em>
                    </p>
                </div>
            </div>
            <div class="row">
                <div class="text-center">
                    <h1>Receipt</h1>
                </div>

                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Device</th>
                        <th>Plan</th>
                        <th class="text-right">Uptime(Min)</th>
                        <th class="text-right">Price</th>
                        <th class="text-right">Total</th>
                    </tr>
                    </thead>
                    <tbody>
                    % for item in detail['SubItems']:
                    <tr bill_id="{{item['BillId']}}">
                        <td class="col-md-9"><em>{{item['VmName']}}</em></h4></td>
                        <td class="col-md-1" style="text-align: center">
                            <span class="badge alert-success">
                            % if item['Plan']==0:
                            O
                            % else:
                            F
                            % end
                            </span>
                        </td>
                        <td class="col-md-1 text-right">{{item['Uptime']}}</td>
                        <td class="col-md-1 text-right">${{item['UnitPrice']}}</td>
                        <td class="col-md-1 text-right">${{item['Charge']}}</td>
                    </tr>
                    % end

                    <tr>
                        <td>  </td>
                        <td>  </td>
                        <td>  </td>
                        <td class="text-right">
                            <p>
                                <strong>Subtotal: </strong>
                            </p>

                            <p>
                                <strong>Tax: </strong>
                            </p></td>
                        <td class="text-right">
                            <p>
                                <strong>${{detail['Subtotal']}}</strong>
                            </p>

                            <p>
                                <strong>${{detail['Tax']}}</strong>
                            </p></td>
                    </tr>
                    <tr>
                        <td>  </td>
                        <td>  </td>
                        <td>  </td>
                        <td class="text-right"><h4><strong>Total: </strong></h4></td>
                        <td class="text-right text-danger"><h4><strong>${{detail['Total']}}</strong></h4></td>
                    </tr>
                    </tbody>
                </table>
                </td>
        <div style="text-align: left">
            <span class="badge alert-success">F</span>&nbsp; Flat Rate<br/>
            <span class="badge alert-success">O</span>&nbsp; On Demand
            </div>
            </div>
        </div>

    </div>

    <div style="text-align: right">
        % if not detail['IsPaid']:
        <button type="button" class="btn btn-success" id="btnPayBill">
            Pay Now   <span class="glyphicon glyphicon-chevron-right"></span>
        </button>
        <script>
            $(function(){
                $('#btnPayBill').click(function() {
                    var bill_ids = [];
                    $("tr[bill_id]").each(function(){
                        bill_ids.push($(this).attr('bill_id'));
                    });

                    var user_id = 1;
                    var url = '/' + user_id + '/pay_bill';
                    $.post(url, {'bill_ids':bill_ids.join()}, function(result){
                        if(result=='ok') {
                            $('#btnPayBill').hide();
                             $('#btnPayBill').parent().prepend("<span class='alert-success'>Paid successfully, thank you!</span>");
                        } else {
                            alert('Payment Error!');
                        }
                    });
                });
            })
        </script>
        % end
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    </div>
</div>