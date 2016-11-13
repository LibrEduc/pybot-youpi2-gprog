/**
 * Created by eric on 02/11/16.
 */
var joint_names = ['BASE', 'SHOULDER', 'ELBOW', 'WRIST', 'HAND'];
var joints_count = joint_names.length;

Blockly.Python.INDENT = '    ';

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

Blockly.Python['set_joint_position'] = function (block) {
    var joint_name = block.getFieldValue('JOINT');
    var angle = Blockly.Python.valueToCode(block, 'ANGLE', Blockly.Python.ORDER_ATOMIC);
    if (angle != "") {
        return 'arm.goto({' + joint_names.indexOf(joint_name) + ': ' + angle + '})\n';
    } else {
        return ''
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

Blockly.Python['open_gripper'] = function (block) {
    return 'arm.open_gripper()\n'
};

Blockly.Python['close_gripper'] = function (block) {
    return 'arm.close_gripper()\n'
};

Blockly.Python['go_home'] = function (block) {
    return 'arm.go_home()\n'
};
