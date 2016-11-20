% rebase("base.tpl", title="Youpi 2 - Programmation graphique", version=version)

<div class="page-header"><h1>Programmation graphique</h1></div>

<div id="blocklyDiv" class="well"></div>

<div class="row text-center">
    <button id="btn_execute" class="btn btn-command btn-default disabled">Exécuter</button>
    <button id="btn_clear" class="btn btn-command btn-default disabled">Effacer</button>
</div>

<div id="toolbox-wrapper" style="display: none"></div>

<div class="modal fade" id="sequence_running_dlg" tabindex="-1" role="dialog"
     data-backdrop="static" data-keyboard="false" data-show="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Exécution en cours...</h2>
            </div>
            <div class="modal-body">
                <div class="progress">
                    <div class="progress-bar progress-bar-info progress-bar-striped active"
                         role="progressbar"
                         style="width: 100%;">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button id="sequence-abort" type="button btn-modal" class="btn btn-danger btn-modal">STOP</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="completion_dlg" tabindex="-1" role="dialog"
     data-backdrop="static" data-keyboard="false" data-show="false">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="completion_status"></h2>
            </div>
            <div class="modal-footer">
                <button id="completion_ok" type="button" class="btn btn-default btn-modal">OK</button>
            </div>
        </div>
    </div>
</div>
