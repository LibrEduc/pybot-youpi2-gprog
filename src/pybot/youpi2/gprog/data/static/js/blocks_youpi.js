/**
 * Created by eric on 02/11/16.
 */
var joint_names = ['BASE', 'SHOULDER', 'ELBOW', 'WRIST', 'HAND'];
var joints_count = joint_names.length;

Blockly.Python.INDENT = '    ';

/**
 * Shared block initialisations
 * @param block the block to be initialized
 * @param title the block title
 * @param help_topic the path of the help page
 */
function initialize_block(block, title, help_topic) {
    block.appendDummyInput()
        .appendField(title);
    block.setColour(65);
    block.setPreviousStatement(true);
    block.setNextStatement(true);
    if (help_topic)
        block.setHelpUrl("/help/" + help_topic);
    block.data = 'youpi';
}

/**
 * Shared initializations for xxx_pose blocks
 * @param block the block to be initialized
 * @param title the block title
 * @param help_topic the path of the help page
 */
function initialize_pose_block(block, title, help_topic) {
    initialize_block(block, title, help_topic);

    block.appendValueInput('BASE')
        .setCheck('Number')
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("base");
    block.appendValueInput('SHOULDER')
        .setCheck('Number')
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("épaule");
    block.appendValueInput('ELBOW')
        .setCheck('Number')
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("coude");
    block.appendValueInput('WRIST')
        .setCheck('Number')
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("poignet");
    block.appendValueInput('HAND')
        .setCheck('Number')
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField("main");
}

/*
 * set_pose
 */
Blockly.Blocks['set_pose'] = {
    init: function () {
        initialize_pose_block(this, 'prendre la pose', 'set_pose');
    }
};

Blockly.Python['set_pose'] = function (block) {
    //console.log('generating set_pose');
    var settings = {};
    for (var i = 0; i < joints_count; i++) {
        var joint_name = joint_names[i];
        var angle = Blockly.Python.valueToCode(block, joint_name, Blockly.Python.ORDER_ATOMIC);
        if (angle != "") {
            settings[joint_name] = angle;
        }
    }

    var last_i = Object.keys(settings).length - 1;
    if (last_i >= 0) {
        var code = 'arm.goto({';
        var i = 0;
        for (var joint in settings) {
            code += joint_names.indexOf(joint) + ': ' + settings[joint];
            if (i < last_i) {
                code += ', ';
            }
            i++;
        }
        code += '})\n';
        return code;
    } else {
        return '';
    }
};

/**
 * move_pose
 */
Blockly.Blocks['move_pose'] = {
    init: function () {
        initialize_pose_block(this, 'modifier la pose', 'move_pose');
    }
};

Blockly.Python['move_pose'] = function (block) {
    //console.log('generating move_pose');
    var settings = {};
    for (var i = 0; i < joints_count; i++) {
        var joint_name = joint_names[i];
        var angle = Blockly.Python.valueToCode(block, joint_name, Blockly.Python.ORDER_ATOMIC);
        if (angle != "") {
            settings[joint_name] = angle;
        }
    }

    var last_i = Object.keys(settings).length - 1;
    if (last_i >= 0) {
        var code = 'arm.move({';
        var i = 0;
        for (var joint in settings) {
            code += joint_names.indexOf(joint) + ': ' + settings[joint];
            if (i < last_i) {
                code += ', ';
            }
            i++;
        }
        code += '})\n';
        return code;
    } else {
        return '';
    }
};

/**
 * Shared initializations for xxx_joint_position blocks
 * @param block the block to be initialized
 * @param title the block title
 * @param label the label between inputs
* @param help_topic the path of the help page
  */
function initialize_joint_position_block(block, title, label, help_topic){
    initialize_block(block, title, help_topic);

    block.appendDummyInput()
        .appendField(new Blockly.FieldDropdown([
            ["base", "BASE"],
            ["épaule", "SHOULDER"],
            ["coude", "ELBOW"],
            ["poignet", "WRIST"],
            ["main", "HAND"]
        ]),
        'JOINT'
    );
    block.appendValueInput('ANGLE')
        .setCheck('Number')
        .setAlign(Blockly.ALIGN_RIGHT)
        .appendField(label);
    block.appendDummyInput()
        .appendField('degrés');
    block.setInputsInline(true);
}

Blockly.Blocks['set_joint_position'] = {
    init: function () {
        initialize_joint_position_block(this, 'déplacer', 'à la position', 'set_joint_position');
    }
};

Blockly.Python['set_joint_position'] = function (block) {
    var joint_name = block.getFieldValue('JOINT');
    var angle = Blockly.Python.valueToCode(block, 'ANGLE', Blockly.Python.ORDER_ATOMIC);
    if (angle != "") {
        return 'arm.goto({' + joint_names.indexOf(joint_name) + ': ' + angle + '})\n';
    } else {
        return ''
    }
};


Blockly.Blocks['move_joint_position'] = {
    init: function () {
        initialize_joint_position_block(this, 'déplacer', 'de', 'move_joint_position');
    }
};

Blockly.Python['move_joint_position'] = function (block) {
    var joint_name = block.getFieldValue('JOINT');
    var angle = Blockly.Python.valueToCode(block, 'ANGLE', Blockly.Python.ORDER_ATOMIC);
    if (angle != "") {
        return 'arm.move({' + joint_names.indexOf(joint_name) + ': ' + angle + '})\n';
    } else {
        return ''
    }

};

Blockly.Blocks['open_gripper'] = {
    init: function () {
        initialize_block(this, 'ouvrir la pince', 'open_gripper');
    }
};

Blockly.Python['open_gripper'] = function (block) {
    return 'arm.open_gripper()\n'
};

Blockly.Blocks['close_gripper'] = {
    init: function () {
        initialize_block(this, 'fermer la pince', 'close_gripper');
    }
};

Blockly.Python['close_gripper'] = function (block) {
    return 'arm.close_gripper()\n'
};

Blockly.Blocks['go_home'] = {
    init: function () {
        initialize_block(this, 'retour origine', 'go_home');
    }
};

Blockly.Python['go_home'] = function (block) {
    return 'arm.go_home()\n'
};

Blockly.Blocks['move_at'] = {
    init: function () {
        initialize_block(this, 'déplacer la pince à', 'move_at');

        var coords = ['X', 'Y', 'Z'];
        for (var i = 0; i < coords.length; i++) {
            var coord = coords[i];
            this.appendValueInput(coord)
                .setCheck('Number')
                .setAlign(Blockly.ALIGN_RIGHT)
                .appendField(coord + ' (mm)');
        }
        this.appendValueInput('PITCH')
            .setCheck('Number')
            .setAlign(Blockly.ALIGN_RIGHT)
            .appendField('inclinaison (deg)')
            ;
    }
};

Blockly.Python['move_at'] = function (block) {
    var x = Blockly.Python.valueToCode(block, 'X', Blockly.Python.ORDER_ATOMIC);
    var y = Blockly.Python.valueToCode(block, 'Y', Blockly.Python.ORDER_ATOMIC);
    var z = Blockly.Python.valueToCode(block, 'Z', Blockly.Python.ORDER_ATOMIC);
    var pitch = Blockly.Python.valueToCode(block, 'PITCH', Blockly.Python.ORDER_ATOMIC);

    return 'arm.move_gripper_at(' +
        (x != '' ? x : '0') + ', ' +
        (y != '' ? y : '0') + ', ' +
        (z != '' ? z : '0') + ', ' +
        (pitch != '' ? pitch : '0') + ')\n';
};

