<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>GenyCloud</title>

    % include('templates/csslinks.tpl', title='CSS Links')
    <link href="{{ get_url('/static/<filename:path>', filename='css/overview.css')}}" rel="stylesheet" />

</head>

<body>

    <div id="wrapper">

        % include('templates/header.tpl', title='Page header and navigation')

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Overview</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-8">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-dashboard fa-fw"></i> Resource

                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-sm-4">
                                    <div class="hero-widget well well-sm">
                                        <div class="icon">
                                             <i class="glyphicon glyphicon-phone"></i>
                                        </div>
                                        <div class="text">
                                            <var>{{running}} / {{total}}</var>
                                            <label class="text-muted">Running Instances</label>
                                        </div>
                                        <a class="btn btn-primary btn-lg btn3d btn-block" id="launchInstance" href="\1\instances?launch=1"><span class="glyphicon"></span>Launch Instance</a>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="hero-widget well well-sm">
                                        <div class="icon">
                                             <i class="glyphicon glyphicon-usd"></i>
                                        </div>
                                        <div class="text">
                                            <var>{{balance['amount']}}</var>
                                            <label class="text-muted">Current Balance</label>
                                        </div>
                                        <a class="btn btn-info btn-lg btn3d btn-block" id="showBilling" href="\1\billing"><span class="glyphicon"></span>Show Billing</a>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="hero-widget well well-sm">
                                        <div class="icon">
                                             <i class="glyphicon glyphicon-bell"></i>
                                        </div>
                                        <div class="text">
                                            <var>0</var>
                                            <label class="text-muted">System Alerts</label>
                                        </div>
                                        <button class="btn btn-success btn-lg btn3d btn-block" id="viewAlert"><span class="glyphicon"></span>View Alerts</button>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <div class="col-lg-4">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            Notice
                        </div>
                        <div class="panel-body">
                            <p>Any question please call 800-000-0000 or email service@genycloud.com</p>
                            <div class="span1 col-md-12">
                            <div class="well">
                                <h4 class="text-warning">On Demond</h4>$0.25 / minute
                                </div>
                        </div>
                        <div class="span1 col-md-12">
                            <div class="well">
                                <h4 class="text-warning">Flat Rate</h4>$250 / month
                            </div>
                        </div>
                        </div>
                        <div class="panel-footer">
                            May 12, 2014
                        </div>
                    </div>
                </div>
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <i class="fa fa-clock-o fa-fw"></i> Timeline
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <ul class="timeline">
                                % for event in events:

                                    %if event['Event'] == 'Power On':
                                        <li>
                                        <div class="timeline-badge success"><i class="fa fa-rocket"></i></div>
                                    %else:
                                        <li class="timeline-inverted">
                                        <div class="timeline-badge danger"><i class="fa fa-square"></i></div>
                                    %end
                                    <div class="timeline-panel">
                                        <div class="timeline-heading">
                                            <h4 class="timeline-title">{{event['VMName']}}</h4>
                                            <p>
                                                %if event['Event'] == 'Power On':
                                                    <span class="badge alert-success">{{event['Event']}}</span>
                                                %else:
                                                    <span class="badge alert-danger">{{event['Event']}}</span>
                                                %end
                                                <small class="text-muted"><i class="fa fa-time"></i> {{event['Time']}} </small>
                                            </p>
                                        </div>
                                        <div class="timeline-body">
                                            <p>Instance ID: {{event['VMId']}}</p>
                                        </div>
                                    </div>
                                </li>
                                % end
                            </ul>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                </div>
                    <!-- /.panel -->
                <!-- /.col-lg-8 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    % include('templates/jslinks.tpl', title='Javascript Links')
</body>

</html>
