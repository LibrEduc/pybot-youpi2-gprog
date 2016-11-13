% include("ui_prolog.tpl", title="Youpi 2")

<style>
    .blocklyTreeLabel {
        font-size: 10pt !important;
        font-weight: bold !important;
        color: #7a8288;
    }

    .blocklyText {
        font-size: 10pt !important;
    }

    .btn-command {
        width: 20%;
    }
</style>

<div class="page-header"><h1>Programmation graphique</h1></div>

<div id="blocklyDiv" class="well" style="height:600px"></div>

<div class="row text-center">
    <button id="btn_execute" class="btn btn-command btn-default disabled">Exécuter</button>
    <button id="btn_stop" class="btn btn-command btn-default disabled">STOP</button>
    <button id="btn_clear" class="btn btn-command btn-default disabled">Effacer</button>
</div>

<div id="toolbox-wrapper" style="display: none"></div>

<script src="/static/js/jquery-3.1.1.min.js"></script>
<script src="/static/js/blockly_compressed.js"></script>
<script src="/static/js/blocks_compressed.js"></script>
<script src="/static/js/python_compressed.js"></script>
<script src="/static/js/fr.js"></script>
<script src="/static/js/blocks_youpi.js"></script>

<script>
    $(function () {
        var workspace = null;
        var python_code = $('#python_code');
        var xml_code = $('#xml_code');
        var btn_execute = $('#btn_execute');
        var btn_stop = $('#btn_stop');
        var btn_clear = $('#btn_clear');

        function btn_execute_enabled(enabled) {
            if (enabled) {
                btn_execute.removeClass('disabled btn-default').addClass('btn-success').removeAttr('disabled');
            } else {
                btn_execute.addClass('disabled btn-default').removeClass('btn-success').attr('disabled', 'disabled');
            }
        }

        function btn_stop_enabled(enabled) {
            if (enabled) {
                btn_stop.removeClass('disabled btn-default').addClass('btn-danger').removeAttr('disabled');
            } else {
                btn_stop.addClass('disabled btn-default').removeClass('btn-danger').attr('disabled', 'disabled');
            }
        }

        function btn_clear_enabled(enabled) {
            if (enabled) {
                btn_clear.removeClass('disabled btn-default').addClass('btn-info').removeAttr('disabled');
            } else {
                btn_clear.addClass('disabled btn-default').removeClass('btn-info').attr('disabled', 'disabled');
            }
        }

        function analyze_code(event) {
            var blocks = workspace.getTopBlocks();

            if (blocks.length == 0) {
                btn_execute_enabled(false);
                btn_clear_enabled(false);

            } else {
                btn_clear_enabled(true);
                btn_execute_enabled(Blockly.Python.workspaceToCode(workspace) != '');
            }
        }

        btn_clear.click(function () {
            workspace.clear();
        });

        btn_execute.click(function () {
            var code = Blockly.Python.workspaceToCode(workspace);
            $.ajax({
                url: "/api/v1/exec",
                method: 'POST',
                data: code,
                beforeSend: function () {
                    btn_execute_enabled(false);
                    btn_stop_enabled(true);
                    btn_clear_enabled(false);
                }
            }).always(function () {
                btn_execute_enabled(true);
                btn_stop_enabled(false);
                btn_clear_enabled(true);
            });
        });

        function setup_toolbox() {
            var elt_toolbox = $("#toolbox")[0];
            var categ_youpi = $('#categ_youpi');

            workspace = Blockly.inject('blocklyDiv', {toolbox: elt_toolbox});

            $.getJSON("../static/js/blocks_youpi.json", function (data) {
                $.map(data, function (blkdef) {
                    categ_youpi.append("<block type=\"" + blkdef.type + "\"></block>");
                    Blockly.Blocks[blkdef.type] = {
                        init: function () {
                            this.jsonInit(blkdef);
                        }
                    };
                });
                workspace.updateToolbox(elt_toolbox);

            }).fail(function (jqxhr, textStatus, error) {
                var err = textStatus + ", " + error;
                console.log(err);
            });

            workspace.addChangeListener(analyze_code);
        }

        $("#btn_export_xml").click(function() {
            var dom = Blockly.Xml.workspaceToDom(workspace);
            var xml = Blockly.Xml.domToText(dom);
            xml_code.val(xml);

            var wksp = new Blockly.Workspace();
            dom = Blockly.Xml.textToDom(xml);
            Blockly.Xml.domToWorkspace(dom, wksp);
            var gen_code = Blockly.Python.workspaceToCode(wksp);
            $("#regen_python").val(gen_code);
        });

        python_code.val('');

        $("#toolbox-wrapper").load("../static/xml/toolbox.xml", setup_toolbox);
    });
</script>

% include("epilog.tpl", version=version, ui_app=True)
