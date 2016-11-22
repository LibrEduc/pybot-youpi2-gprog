% rebase("base.tpl", title="Youpi 2 - Programmation graphique", version=version)

<style>
    div.row {
        margin-top: 2em;
    }
</style>

<div class="page-header"><h1>Programmation du bras</h1></div>

%include("toc_prolog.tpl")

<div class="page-header">
    <h2>Programmer Youpi</h2>
</div>

<h3>Qu'est-ce que la programmation ?</h3>

<p>La programmation consiste à spécifier au système concerné (un ordinateur, un robot...) ce qu'il doit faire et
    dans quelles conditions. La plupart du temps cela se fait un détaillant de manière chronologique les étapes
    et actions élémentaires. C'est ce qu'on appelle la <b>programmation procédurale</b>, car on définir ce faisant
    la <b>procédure</b> à suivre.</p>
<p>On peut aussi programmer en spécifiant une collection de règles, définissant chacune ce qui doit être fait lorsque
    certaines conditions sont remplies, ainsi que la manière de sélectionner la règle à appliquer lorsque plusieurs
    peuvent convenir à un instant donné.</p>
<p>Pour exprimer un programme, on utilise la plupart du temps des <b>langages</b>, composés de <b>mots clés</b> et de
    constructions, dont la syntaxe cherche à simplifier le plus possible la tâche au programmeur en <i>collant</i> le
    plus possible à son domaine de travail habituel. Des outils traduisent ensuite cette formulation compréhensible
    par un humain (mais pas par un ordinateur) en une forme compréhensible par un ordinateur (mais pas
    par un humain). C'est ce qu'on appelle la <b>compilation</b>.</p>

%include("jump_to_top")

<h3>La programmation graphique</h3>
<p>Dans un souci de mise à la portée de non-informatiens, on a aussi recours à une représentation graphique de
    la logique du programme, traduite automatiquement par des outils en son équivalent compréhensible par
    l'ordinateur. Ces représentations peuvent être suffisamment simples pour être utilisées par des enfants.
    Parmi les plus couramment rencontrés, on peut citer l'environnement de programmation des robots LEGO Mindstorms
    ou le langage Scratch.</p>
<p>Le principe de ces outils est de représenter la logique complète d'un programme en assemblant des blocs représentant
    les actions élémentaires, et pouvant comporter des entrées en sorties pour échanger des informations entre eux ou
    avec l'extérieur.</p>
%include("jump_to_top")

<h3>Blockly</h3>
<p>Un autre outil de ce type est apparu récemment <b>Blockly</b>, développé et mis à disposition gratuitement
    par la société Google.</p>
<p>A la différence des exemples cités ci-dessus, Blockly peut être étendu à volonté pour proposer des blocs spécifiques
    au problème traité, l'adaptant ainsi à tout type de contexte. Le concepteur de ces blocs peut également définir
    la manière dont le code à exécuter par la machine va être produit.</p>
<p>C'est cette approche qui est utilisée ici, en complétant la collection de blocs fournis par défaut pour créer des
    logiques de décision, de répétition, des opérations arithmétiques, logiques ou sur des caractères... par des
    blocs représentant des actions spécifiques à Youpi, tel que bouger ses articulations, actionner sa pince, afficher
    des messages sur son écran...</p>
<p>Programmer avec Blockly consiste à sélectionner un bloc dans la boîte à outils située dans la marge gauche,
    et à le placer dans la zone d'édition du programme à sa position dans la logique dessinée. Les blocs s'assemblent
    à la manière des pièces d'un puzzle, sachant que le système vérifie en permanence qu'on peut connecter entre eux
    des blocs compatibles uniquement. Par exemple, si un bloc a besoin d'une donnée d'entrée qui est un nombre, on ne
    pourra pas y connecter un autre bloc qui produit une donnée qui est un texte. L'objectif est de garantir autant que
    faire se peut la cohérence de ce qui est exprimé.</p>

<img src="/static/img/program.png" class="center-block">
%include("jump_to_top")

<div class="page-header">
    <h2>Les blocs spécifiques à Youpi</h2>
</div>
<div class="row">
    <div class="col-md-3">
        <img src="/static/img/toolbox.png">
    </div>
    <div class="col-md-9">
        <p>Ils sont des plusieurs catégories:</p>
        <ul>
            <li>les actions sur le bras : définir une pose, bouger une articulation particulière, actionner la pince...</li>
            <li>les actions sur le panneau de contrôle : afficher un texte, allumer les LEDs...</li>
        </ul>
        <p>On les trouve dans l'entrée <b>Youpi</b> de la boîte à outils. Cette entrée se subdivise elle-même en
            plusieurs sous-catégories, selon la classification présentée ci-dessus. Les blocs disponibles sont détaillés
            ci-après.</p>
    </div>
</div>
%include("jump_to_top")

<h3>Contrôle du bras</h3>

<div id="set_pose" class="row">
    <div class="col-md-2">
        <img src="/static/img/blk_set_pose.png">
    </div>
    <div class="col-md-10">
        <p>Définit la nouvelle position du bras en indiquant les angles de ses articulations. Les articulations dont
            l'angle n'est pas spécifié conservent leur position actuelle.</p>
        <p>Les angles sont spécifiés par un nombre entier de degrés, 0 correspondant :</p>
        <ul>
            <li>à la direction face au panneau de contrôle pour la base,</li>
            <li>au prolongement avec le segment précédent pour le bras, l'avant-bras et le poignet,</li>
            <li>aux doigts de part et d'autre du bras pour la main.</li>
        </ul>
    </div>
</div>
%include("jump_to_top")

<div id="move_pose" class="row">
    <div class="col-md-2">
        <img src="/static/img/blk_move_pose.png">
    </div>
    <div class="col-md-10">
        <p>Modifie la position du bras par rapport aux angles actuels de ses articulations, en ajoutant ou retranchant
            un certain nombre de degrés à la valeur actuelle. Les articulations dont l'angle n'est pas spécifié conservent
            leur position actuelle.</p>
        <p>Les modifications sont spécifiées par un nombre entier de degrés, pouvant être négatif.</p>
    </div>
</div>
%include("jump_to_top")

<div id="set_joint" class="row">
    <div class="col-md-5">
        <img src="/static/img/blk_set_joint.png">
    </div>
    <div class="col-md-7">
        <p>Définit l'angle d'une articulation unique.</p>
        <p>Les angles sont spécifiés par un nombre entier de degrés, la référence étant identique à celle utilisée par le
        bloc <a href="#set_pose">Prendre la pose</a></p>
    </div>
</div>
%include("jump_to_top")

<div id="move_joint" class="row">
    <div class="col-md-4">
        <img src="/static/img/blk_move_joint.png">
    </div>
    <div class="col-md-8">
        <p>Modifie l'angle d'une articulation unique en ajoutant ou retranchant un certain nombre de degrés
            à la valeur actuelle.</p>
        <p>Les modifications sont spécifiées par un nombre entier de degrés, pouvant être négatif.</p>
    </div>
</div>
%include("jump_to_top")

<div id="move_at" class="row">
    <div class="col-md-3">
        <img src="/static/img/blk_move_at.png">
    </div>
    <div class="col-md-9">
        <p>Déplace l'extrémité de la pince à une position dans l'espace, exprimée par ses coordinnées (X, Y, Z). La position
            cible indique également l'orientation de la pince par rapport à l'horizontale.</p>
        <p>Les coordonnées sont exprimées en <b>millimètres</b>, et selon les références suivantes:</p>
        <dl>
            <dt>X</dt>
            <dd>selon l'axe principal du boitier, orienté vers l'avant et dont l'origine est la face avant,</dd>
            <dt>Y</dt>
            <dd>selon un axe horizontal perpandiculaire, orienté vers la droite en regardant le panneau de contrôle,</dd>
            <dt>Z</dt>
            <dd>selon un axe vertical orienté vers le haut, et dont l'origine est au niveau du plan sur lequel repose le
                boitier.</dd>
        </dl>
    </div>
</div>
%include("jump_to_top")

<div id="open_gripper" class="row">
    <div class="col-md-2">
        <img src="/static/img/blk_open_gripper.png">
    </div>
    <div class="col-md-10">
        <p>Ouvre intégralement la pince.</p>
    </div>
</div>
%include("jump_to_top")

<div id="close_gripper" class="row">
    <div class="col-md-2">
        <img src="/static/img/blk_close_gripper.png">
    </div>
    <div class="col-md-10">
        <p>Ferme la pince jusqu'à tenir un objet si présent, ou totalement si vide.</p>
    </div>
</div>
%include("jump_to_top")

<div id="go_home" class="row">
    <div class="col-md-2">
        <img src="/static/img/blk_go_home.png">
    </div>
    <div class="col-md-10">
        <p>Replace le bras à sa position d'origine, base centrée, bras, avant-bras et poignets déployés à la verticale,
            main en position transversale.</p>
    </div>
</div>
%include("jump_to_top")

<h3>Panneau de contrôle</h3>

<div id="pnl_write_at" class="row">
    <div class="col-md-6">
        <img src="/static/img/blk_pnl_write_at.png">
    </div>
    <div class="col-md-6">
        <p>Affiche un texte à une position donnée sur le LCD.</p>
        <p>Le LCD dispose de 4 lignes de 20 caractères. La numérotation part de 1, l'origine étant le coin supérieur gauche.</p>
        <p>Un texte plus long que le reste de la ligne <i>débordera</i> sur la ligne suivante, pouvant résulter en un affichage
        différent de celui souhaité.</p>
    </div>
</div>
%include("jump_to_top")

<div id="pnl_center_text" class="row">
    <div class="col-md-4">
        <img src="/static/img/blk_pnl_center_text.png">
    </div>
    <div class="col-md-8">
        <p>Affiche un texte sur le LCD, centré sur une ligne spécifique.</p>
    </div>
</div>
%include("jump_to_top")

<div id="pnl_clear" class="row">
    <div class="col-md-2">
        <img src="/static/img/blk_pnl_clear.png">
    </div>
    <div class="col-md-10">
        <p>Efface le contenu du LCD.</p>
    </div>
</div>
%include("jump_to_top")

<div id="leds_on" class="row">
    <div class="col-md-7">
        <img src="/static/img/blk_leds_on.png">
    </div>
    <div class="col-md-5">
        <p>Allume des LEDs du panneau de contrôle.</p>
        <p>L'état de chaque LED est indiqué par une valeur logique, "vrai" signifiant "allumée". Celles dont l'état n'est pas
        indiqué sont inchangées.</p>
    </div>
</div>
%include("jump_to_top")

<div id="leds_off" class="row">
    <div class="col-md-2">
        <img src="/static/img/blk_leds_off.png">
    </div>
    <div class="col-md-6">
        <p>Eteint toutes les LEDs du panneau de contrôle.</p>
    </div>
</div>

%include("toc_epilog.tpl")