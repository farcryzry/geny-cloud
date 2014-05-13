<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>GenyCloud</title>

    % include('templates/csslinks.tpl', title='CSS Links')

</head>

<body>

    <div id="wrapper">

        % include('templates/header.tpl', title='Page header and navigation')

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Usage</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-bar-chart-o fa-fw"></i> Hourly Usage
                            <div class="pull-right">
                                <div class="btn-group">
                                    <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                                        Actions
                                        <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu pull-right" role="menu">
                                        <li><a href="#" id="btnRefreshUsage">Refresh</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div id="hourly_usage"></div>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->

            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-bar-chart-o fa-fw"></i> Hourly Cost
                            <div class="pull-right">
                                <div class="btn-group">
                                    <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                                        Actions
                                        <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu pull-right" role="menu">
                                        <li><a href="#" id="btnRefreshCost">Refresh</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div id="hourly_cost"></div>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    % include('templates/jslinks.tpl', title='Javascript Links')
    <script src="{{get_url('/static/<filename:path>',filename='js/raphael-min.js')}}"></script>
    <script src="{{get_url('/static/<filename:path>',filename='js/morris-0.4.1.min.js')}}"></script>
    <script>
        $(function(){

            $('#btnRefreshUsage').click(function(){

                $('#hourly_usage').html('');
                var user_id = 1;
                var url = "/" + user_id + "/hourly_usage";
                $.get(url, function(data){
                    Morris.Bar({
                      element: 'hourly_usage',
                      data: JSON.parse(data),
                      xkey: 'Date',
                      ykeys: ['Uptime'],
                      labels: ['Uptime(Min)']
                    });
                });
            });

            $('#btnRefreshCost').click(function(){

                $('#hourly_cost').html('');
                var user_id = 1;
                var url = "/" + user_id + "/hourly_cost";
                $.get(url, function(data){
                    Morris.Bar({
                      element: 'hourly_cost',
                      data: JSON.parse(data),
                      xkey: 'Date',
                      ykeys: ['Amount'],
                      labels: ['Amount($)']
                    });
                });
            });

            $('#btnRefreshUsage').click();
            $('#btnRefreshCost').click();

        });

    </script>
</body>

</html>
