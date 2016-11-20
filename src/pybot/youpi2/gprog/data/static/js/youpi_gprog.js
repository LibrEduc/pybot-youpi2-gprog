/**
 * Created by eric on 20/11/16.
 */

$(function () {
    var workspace = null;
    var $btn_execute = $('#btn_execute');
    var $btn_clear = $('#btn_clear');

    var $running_modal = $('#sequence_running_dlg');
    $running_modal.modal();

    var $completion_modal = $('#completion_dlg');
    $completion_modal.modal();
    var completion_status = $("#completion_status");

    function completion_message(status) {
        $("#completion_status").text(status);
        $completion_modal.modal('show');
    }

    $('#completion_ok').click(function () {
        $completion_modal.modal('hide');
    });


    $('#sequence-abort').click(function () {
        $.ajax({
            url: "/api/v1/abort",
            method: 'POST'
        }).then(function () {
            $running_modal.modal('hide');
            btn_execute_enabled(true);
            btn_clear_enabled(true);
        });
    });

    function save_workspace() {
        var dom = Blockly.Xml.workspaceToDom(workspace);
        var xml = Blockly.Xml.domToText(dom);

        $.post("/api/v1/workspace", xml);
    }

    function btn_execute_enabled(enabled) {
        if (enabled) {
            $btn_execute
                    .removeClass('disabled btn-default')
                    .addClass('btn-success')
                    .removeAttr('disabled');
        } else {
            $btn_execute
                    .addClass('disabled btn-default')
                    .removeClass('btn-success')
                    .attr('disabled', 'disabled');
        }
    }

    function btn_clear_enabled(enabled) {
        if (enabled) {
            $btn_clear
                    .removeClass('disabled btn-default')
                    .addClass('btn-info')
                    .removeAttr('disabled');
        } else {
            $btn_clear
                    .addClass('disabled btn-default')
                    .removeClass('btn-info')
                    .attr('disabled', 'disabled');
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

    $btn_clear.click(function () {
        workspace.clear();
    });

    $btn_execute.click(function () {
        save_workspace();

        var code = Blockly.Python.workspaceToCode(workspace);
        $.ajax({
            url: "/api/v1/run",
            method: 'POST',
            data: code
        }).fail(function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 400) {
                error_message("Séquence incorrecte : " + jqXHR.responseText);
            } else {
                error_message("Erreur imprévue : " + jqXHR.responseText);
            }
            $running_modal.modal('hide');

        }).then(function () {
            $running_modal.modal('show');
            btn_execute_enabled(false);
            btn_clear_enabled(false);

            pollRunningStatus();
        });
    });

    function pollRunningStatus() {
        $.get("/api/v1/status").done(function(reply){
            switch (reply.status) {
                case 'terminated':
                    $running_modal.modal('hide');
                    completion_message("Execution terminée.");
                    btn_execute_enabled(true);
                    btn_clear_enabled(true);
                    return;
                case 'aborted':
                    $running_modal.modal('hide');
                    completion_message("Execution interrompue.");
                    btn_execute_enabled(true);
                    btn_clear_enabled(true);
                    return;
                case 'error':
                    $running_modal.modal('hide');
                    error_message("Erreur d'exécution : " + reply.error);
                    btn_execute_enabled(true);
                    btn_clear_enabled(true);
                    return;
                case 'running':
                    setTimeout(pollRunningStatus, 500);
                    break;
            }
        });
    }

    function setup_workspace() {
        var elt_toolbox = $("#toolbox")[0];

        workspace = Blockly.inject('blocklyDiv', {toolbox: elt_toolbox});
        workspace.addChangeListener(analyze_code);

        $.ajax({
            url: "/api/v1/workspace",
            dataType: "xml"
        }).done(function(data, status, jqXHR){
            var xml = Blockly.Xml.textToDom(jqXHR.responseText);
            Blockly.Xml.domToWorkspace(xml, workspace);
        });
    }

    $("#toolbox-wrapper").load("../static/xml/toolbox.xml", setup_workspace);

});
