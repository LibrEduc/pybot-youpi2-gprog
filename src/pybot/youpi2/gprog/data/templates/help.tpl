% rebase("base.tpl", title="Youpi 2 - Programmation graphique", version=version)

<div class="page-header"><h1>Programmation du bras</h1></div>

%include("toc_prolog.tpl")
<h2>Programmer Youpi</h2>

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
%include("jump_to_top")

<h2>Les blocs spécifiques à Youpi</h2>
<p>Ils sont des plusieurs catégories:</p>
<ul>
    <li>les actions sur le bras : définir une pose, bouger une articulation particulière, actionner la pince...</li>
    <li>les actions sur le panneau de contrôle : afficher un texte, allumer les LEDs...</li>
</ul>
<p>On les trouve dans l'entrée <b>Youpi</b> de la boîte à outils. Cette entrée se subdivise elle-même en
    plusieurs sous-catégories, selon la classification présentée ci-dessus. Les blocs disponibles sont détaillés
    ci-après.</p>
%include("jump_to_top")

<h3>Contrôle du bras</h3>

<h4 id="set_pose">Prendre la pose</h4>
<p>Définit la nouvelle position du bras en indiquant les angles de ses articulations. Les articulations dont
    l'angle n'est pas spécifié conservent leur position actuelle.</p>
<p>Les angles sont spécifiés par un nombre entier de degrés, 0 correspondant :</p>
<ul>
    <li>à la direction face au panneau de contrôle pour la base,</li>
    <li>au prolongement avec le segment précédent pour le bras, l'avant-bras et le poignet,</li>
    <li>aux doigts de part et d'autre du bras pour la main.</li>
</ul>
%include("jump_to_top")

<h4 id="move_pose">Modifier la pose</h4>
<p>Modifie la position du bras par rapport aux angles actuels de ses articulations, en ajoutant ou retranchant
    un certain nombre de degrés à la valeur actuelle. Les articulations dont l'angle n'est pas spécifié conservent
    leur position actuelle.</p>
<p>Les modifications sont spécifiées par un nombre entier de degrés, pouvant être négatif.</p>
%include("jump_to_top")

<h4 id="set_joint">Déplacer &lt;articulation&gt; à la position</h4>
<p>Définit l'angle d'une articulation unique.</p>
<p>Les angles sont spécifiés par un nombre entier de degrés, la référence étant identique à celle utilisée par le
bloc <a href="#set_pose">Prendre la pose</a></p>
%include("jump_to_top")

<h4 id="move_joint">Déplacer &lt;articulation&gt; de...</h4>
<p>Modifie l'angle d'une articulation unique en ajoutant ou retranchant un certain nombre de degrés
    à la valeur actuelle.</p>
<p>Les modifications sont spécifiées par un nombre entier de degrés, pouvant être négatif.</p>
%include("jump_to_top")

<h4 id="move_at">déplacer la pince à...</h4>
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
%include("jump_to_top")

<h4 id="open_gripper">Ouvrir la pince</h4>
<p>Ouvre intégralement la pince.</p>
%include("jump_to_top")

<h4 id="close_gripper">Fermer la pince</h4>
<p>Ferme la pince jusqu'à tenir un objet si présent, ou totalement si vide.</p>
%include("jump_to_top")

<h4 id="go_home">Retour origine</h4>
<p>Replace le bras à sa position d'origine, base centrée, bras, avant-bras et poignets déployés à la verticale,
    main en position transversale.</p>
%include("jump_to_top")

<h3>Panneau de contrôle</h3>

<h4 id="pnl_write_at">Afficher</h4>
<p>Affiche un texte à une position donnée sur le LCD.</p>
<p>Le LCD dispose de 4 lignes de 20 caractères. La numérotation part de 1, l'origine étant le coin supérieur gauche.</p>
<p>Un texte plus long que le reste de la ligne <i>débordera</i> sur la ligne suivante, pouvant résulter en un affichage
différent de celui souhaité.</p>
%include("jump_to_top")

<h4 id="pnl_center_text">Center</h4>
<p>Affiche un texte sur le LCD, centré sur une ligne spécifique.</p>
%include("jump_to_top")

<h4 id="pnl_clear">Effacer affichage</h4>
<p>Efface le contenu du LCD.</p>
%include("jump_to_top")

<h4 id="leds_on">Allumer LEDs</h4>
<p>Allume des LEDs du panneau de contrôle.</p>
<p>L'état de chaque LED est indiqué par une valeur logique, "vrai" signifiant "allumée". Celles dont l'état n'est pas
indiqué sont inchangées.</p>
%include("jump_to_top")

<h4 id="leds_off">Eteindre les LEDs</h4>
<p>Eteint toutes les LEDs du panneau de contrôle.</p>
%include("jump_to_top")

%include("toc_epilog.tpl")