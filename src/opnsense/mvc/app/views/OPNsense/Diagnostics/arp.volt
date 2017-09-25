{#

OPNsense® is Copyright © 2014 – 2016 by Deciso B.V.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2.  Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED “AS IS” AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

#}

<script type="text/javascript">
    $( document ).ready(function() {
        /**
         * fetch system arp table
         */
        function updateARP() {
            var gridopt = {
                ajax: false,
                selection: false,
                multiSelect: false
            };
            $("#grid-arp").bootgrid('destroy');
            ajaxGet(url = "/api/diagnostics/interface/getArp",
                    sendData = {}, callback = function (data, status) {
                        if (status == "success") {
                            var html = [];
                            $.each(data, function (key, value) {
                                var fields = ["ip", "mac", "manufacturer", "intf", "intf_description", "hostname"];
                                tr_str = '<tr>';
                                for (var i = 0; i < fields.length; i++) {
                                    if (value[fields[i]] != null) {
                                        tr_str += '<td>' + value[fields[i]] + '</td>';
                                    } else {
                                        tr_str += '<td></td>';
                                    }
                                }
                                tr_str += '</tr>';
                                html.push(tr_str);
                            });
                            $("#grid-arp > tbody").html(html.join(''));
                        }
                        $("#grid-arp").bootgrid(gridopt);
                    }
            );
        }
        
        
        function flushARP() {
            ajaxCall(url = "/api/diagnostics/interface/flushArp",
                sendData = {}, callback = function (data, status) {
                    $("#refresh").click();
                });
        }

        $("#flush").click(flushARP);
        
        // initial fetch
        $("#refresh").click(updateARP);
        $("#refresh").click();
    });
</script>

<!-- Modal -->
<div id="flushModal" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
    <h4 class="modal-title">{{ lang._('Flush ARP Table') }}</h4>
      </div>
      <div class="modal-body">
        <p>
            {{ lang._("If you've changed the IP of a host - or setup a new host with the IP of an old one - you've probably got that the host has no network connectivity for a period of time. The router has cached the old MAC address (ethernet hardware address) associated with the host's IP address. This cache will persist on the gateway network device until:") }}
        </p>
        <ul>
            <li>
                {{ lang._('The ARP cache on the gateway network device expires.') }}
            </li>
            <li>
                {{ lang._('You manually flush the ARP cache on the gateway network device.') }}
            </li>
        </ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default btn-close" data-dismiss="modal">{{ lang._('Close') }}</button>
        <button type="button" class="btn btn-default" data-toggle="modal" id="flush">{{ lang._('Flush ARP Table') }}</button>
      </div>
    </div>
  </div>
</div>

<div class="content-box">
    <div class="content-box-main">
        <div class="table-responsive">
            <div  class="col-sm-12">
                <table id="grid-arp" class="table table-condensed table-hover table-striped table-responsive">
                    <thead>
                    <tr>
                        <th data-column-id="ip" data-type="string"  data-identifier="true">{{ lang._('IP') }}</th>
                        <th data-column-id="mac" data-type="string" data-identifier="true">{{ lang._('MAC') }}</th>
                        <th data-column-id="manufacturer" data-type="string" data-css-class="hidden-xs hidden-sm" data-header-css-class="hidden-xs hidden-sm">{{ lang._('Manufacturer') }}</th>
                        <th data-column-id="intf" data-type="string" data-css-class="hidden-xs hidden-sm" data-header-css-class="hidden-xs hidden-sm">{{ lang._('Interface') }}</th>
                        <th data-column-id="intf_description" data-type="string" data-css-class="hidden-xs hidden-sm" data-header-css-class="hidden-xs hidden-sm">{{ lang._('Interface name') }}</th>
                        <th data-column-id="hostname" data-type="string" data-css-class="hidden-xs hidden-sm" data-header-css-class="hidden-xs hidden-sm">{{ lang._('Hostname') }}</th>
                    </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                    <tr>
                        <td colspan="6">{{ lang._('NOTE: Local IPv6 peers use NDP instead of ARP.') }}</td>
                    </tr>
                    </tfoot>
                </table>
            </div>
            <div  class="col-sm-12">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="pull-right">
                            <button type="button" class="btn btn-default" data-toggle="modal" data-target="#flushModal">
                                <span>{{ lang._('Flush') }}</span>
                                <span class="fa fa-eraser"></span>
                            </button>                            
                            <button id="refresh" type="button" class="btn btn-default">
                                <span>{{ lang._('Refresh') }}</span>
                                <span class="fa fa-refresh"></span>
                            </button>
                        </div>
                    </div>
                </div>
                <hr/>
            </div>
        </div>
    </div>
</div>
