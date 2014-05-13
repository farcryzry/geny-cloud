<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
   <!-- <meta name="viewport" content="width=device-width, initial-scale=1.0" />-->
    <title>GenyCloud</title>
    % include('templates/csslinks.tpl', title='CSS Links')
</head>

<body>
    <div id="wrapper">
        % include('templates/header.tpl', title='Page header and navigation')
        <div id="page-wrapper">
            % if launch:
            <div id="chooseImage" class = "row">
            % else:
            <div id="chooseImage" class = "row" style="display:none">
            % end
                <div class="col-lg-12">
                    <h1 class="page-header">Choose Image</h1>
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <div class="row">
                        <div class="col-lg-6">
                            <div class="cuadro_intro_hover " style="background-color:#cccccc;">
                                <p style="text-align:center; ">
                                    <img src="../static/img/LG-Optimus-L3.jpg" class="img-responsive" alt=""/>
                                </p>
                                <div class="caption">
                                    <div class="blur"></div>
                                    <div class="caption-text">
                                        <div style="display: none;">LG Optimus L3 II - 4.1.1 - API 16 - 240x320</div>
                                        <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">LG Optimus L3 II</h3>
                                        <p>Android Version : 4.1.1</p>
                                        <p>Screen Size : 240x320</p>
                                        <p>Memory / Storge : 512M / 4096M</p>
                                        <a class=" btn btn-default select" data-toggle="modal" data-target="#myModal" href="#" vmName="LG Optimus L3 II - 4.1.1 - API 16 - 240x320"><span class="glyphicon glyphicon-plus"> SELECT</span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="cuadro_intro_hover " style="background-color:#cccccc;">
                                <p style="text-align:center; ">
                                    <img src="../static/img/HTC-Evo.jpg" class="img-responsive" alt="" />
                                </p>
                                <div class="caption">
                                    <div class="blur"></div>
                                    <div class="caption-text">
                                        <div style="display: none;">HTC Evo - 4.2.2 - API 17 - 720x1280</div>
                                        <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">HTC Evo</h3>
                                        <p>Android Version : 4.2.2</p>
                                        <p>Screen Size : 720 X 1280</p>
                                        <p>Memory / Storge : 2048M / 16384M</p>
                                        <a class=" btn btn-default select" data-toggle="modal" data-target="#myModal" href="#" vmName="HTC Evo - 4.2.2 - API 17 - 720x1280"><span class="glyphicon glyphicon-plus"> SELECT</span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="cuadro_intro_hover " style="background-color:#cccccc;">
                                <p style="text-align:center;">
                                    <img src="../static/img/Samsung-Galaxy-S3.jpg" class="img-responsive" alt="" />
                                </p>
                                <div class="caption">
                                    <div class="blur"></div>
                                    <div class="caption-text">
                                        <div style="display: none;">Samsung Galaxy S3 - 4.3 - API 18 - 720x1280</div>
                                        <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">Samsung Galaxy S3</h3>
                                        <p>Android Version : 4.3</p>
                                        <p>Screen Size : 720 X 1280</p>
                                        <p>Memory / Storge : 1024M / 32768M</p>
                                        <a class=" btn btn-default select" data-toggle="modal" data-target="#myModal" href="#" vmName="Samsung Galaxy S3 - 4.3 - API 18 - 720x1280"><span class="glyphicon glyphicon-plus"> SELECT</span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="cuadro_intro_hover " style="background-color:#cccccc;">
                                <p style="text-align:center;">
                                    <img src="../static/img/google-nexus-10.png" class="img-responsive" alt="" />
                                </p>
                                <div class="caption">
                                    <div class="blur"></div>
                                    <div class="caption-text">
                                        <div style="display: none;">Google Nexus 10 - 4.4.2 - API 19 - 2560x1600</div>
                                        <h3 style="border-top:2px solid white; border-bottom:2px solid white; padding:10px;">Google Nexus 10</h3>
                                        <p>Android Version : 4.4.2</p>
                                        <p>Screen Size : 2560x1600</p>
                                        <p>Memory / Storge : 2048M / 16384M</p>
                                        <a class="btn btn-default select" data-toggle="modal" data-target="#myModal" href="#" vmName="Google Nexus 10 - 4.4.2 - API 19 - 2560x1600" ><span class="glyphicon glyphicon-plus"> SELECT</span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                        </div>
                    </div>
                </div>
            </div>

            % if launch:
            <div id="instancesTable" class = "row" style="display:none">
            % else:
            <div id="instancesTable" class = "row">
            % end
                   <div class="col-lg-12">
                        <h1 class="page-header">Instance</h1>
                        <div class="panel panel-default">
                        <div class="panel-heading">
                           <i class="fa fa-android fa-fw"></i> Your Reserved Instances
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="table-responsive">
                                <div id="dataTables-example_wrapper" class="dataTables_wrapper form-inline" role="grid">
                                    <div class="row" style="margin-bottom: 7px;">
                                        <div class="col-sm-6">
                                            <div class="dataTables_length" id="dataTables-example_length">
                                                <span><button class="btn btn-primary" id="launchInstance" >Launch</button></span>
                                                <div class="btn-group">
                                                   <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown">Action <span class="caret"></span></button>
                                                   <ul class="dropdown-menu" role="menu">
                                                      <li><a id="powerOff" class="btn disabled vmOperation"  href="#">Power Off</a></li>
                                                      <li><a id="powerOn" class="btn disabled vmOperation" href="#">Power On</a></li>
                                                      <li><a id="terminate" class="btn disabled vmOperation" href="#">Terminate</a></li>
                                                   </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <table class="table table-striped table-bordered table-hover dataTable no-footer" id="dataTables-example" aria-describedby="dataTables-example_info">
                                        <thead>
                                            <tr role="row">
                                                <th tabindex="0" aria-controls="dataTables-example" rowspan="1" colspan="1" style="width: 30px;"><input class="checkbox"  id="checkAll" type="checkbox" name="checkbox"/></th>
                                                <th class="sorting" tabindex="0" aria-controls="dataTables-example" rowspan="1" colspan="1" aria-label="Browser: activate to sort column ascending" style="width: 390px;">name</th>
                                                <th class="sorting" tabindex="0" aria-controls="dataTables-example" rowspan="1" colspan="1" aria-label="Platform(s): activate to sort column ascending" style="width: 110px;">Instance ID</th>
                                                <th tabindex="0" aria-controls="dataTables-example" rowspan="1" colspan="1" aria-label="Engine version: activate to sort column ascending" style="width: 158px;">Instance State</th>
                                                <th class="sorting" tabindex="0" aria-controls="dataTables-example" rowspan="1" colspan="1" aria-label="CSS grade: activate to sort column ascending" style="width: 200px;">Launch Time</th>
                                                <th tabindex="0" aria-controls="dataTables-example" rowspan="1" colspan="1" aria-label="CSS grade: activate to sort column ascending" style="width: 114px;">Rate Plan</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!--<tr class="gradeA odd">-->
                                                <!--<td class="sorting_1">Gecko</td>-->
                                                <!--<td class=" ">Firefox 1.0</td>-->
                                                <!--<td class=" ">Win 98+ / OSX.2+</td>-->
                                                <!--<td class="center ">1.7</td>-->
                                                <!--<td class="center ">A</td>-->
                                            <!--</tr>-->
                                            % for instance in instances:
                                            <tr class="gradeA odd">
                                                <td><input class="checkbox" vmId="{{instance['VmId']}}" type="checkbox" name="checkbox"/></td>
                                                <td>{{instance['VmName']}}</td>
                                                <td style="padding-left: 35px;">{{instance['VmId']}}</td>
                                                <td class="vmStatus" style="padding-left: 40px;">{{instance['VmStatus']}}</td>
                                                <td>{{instance['LastStartTime']}}</td>
                                                <td class="ratePlan">{{instance['RatePlan']}}</td>
                                            </tr>
                                            % end
                                        </tbody>
                                    </table>
                                </div>
                            <!-- /.table-responsive -->
                            <!--<div class="well">-->
                                <!--<h4>DataTables Usage Information</h4>-->
                                <!--<p>DataTables is a very flexible, advanced tables plugin for jQuery. In SB Admin, we are using a specialized version of DataTables built for Bootstrap 3. We have also customized the table headings to use Font Awesome icons in place of images. For complete documentation on DataTables, visit their website at <a target="_blank" href="https://datatables.net/">https://datatables.net/</a>.</p>-->
                                <!--<a class="btn btn-default btn-lg btn-block" target="_blank" href="https://datatables.net/">View DataTables Documentation</a>-->
                            <!--</div>-->
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    </div>
                    </div>
            </div>
    </div>

   <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h2 class="modal-title" id="myModalLabel" style="text-align: center;">Select a Plan</h2>
                </div>
                <div class="modal-body">

                    <form id="lauchInstanceForm" >
                         <div class="span1 col-md-6">
                            <div id="wellOnDemand" class="well">
                                <h2 class="text-warning">On Demond</h2>

                                <p><span class="label label-success">POPULAR</span></p>
                                <ul>
                                    <li>Scalable</li>
                                    <li>Count as Minute, pay less</li>
                                    <li>Pay as you go</li>
                                </ul>
                                <p>Pay as you go. Cheap!!</p>
                                <hr/>
                                <h3>$0.25 / minute</h3>
                                <hr/>
                                <p><button id="onDemond" class="btn btn-success btn-large"><i class="icon-ok"></i>Select plan</button></p>
                            </div>
                        </div>
                        <div class="span1 col-md-6">
                            <div id="wellFlatRate" class="well">
                                <h2 class="text-warning">Flat Rate</h2>

                                <p><span class="label label-success">POPULAR</span></p>
                                <ul>
                                    <li>Scalable</li>
                                    <li>Unlimited access</li>
                                    <li>24 hours</li>
                                </ul>
                                <p>Cheap As Well!!</p>
                                <hr/>
                                <h3>$250 / month</h3>
                                <hr/>
                                <p>
                                    <button id="flatRate" class="btn btn-success btn-large"><i class="icon-ok"></i> Select plan</button>
                                </p>
                            </div>
                        </div>
                        <div class="form-group" style="margin-left: 15px;">
                            <label>Choose How Many You Want : </label>
                            <select name="number">
                                <option>1</option>
                                <option>2</option>
                            </select>
                            <input type="text" style="display: none"  id="plan" name="plan"/>
                            <input type="text" style="display: none" id="vmName" name="vmName"/>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <input id="launch" type="submit" value="Launch" class="btn btn-primary"/>
                        </div>
                    </form>
                </div>
            </div>
        </div>-
    </div>
</div>
</div>
    </div>
  % include('templates/jslinks.tpl', title='Javascript Links')
</body>
</html>
