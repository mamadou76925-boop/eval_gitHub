# Réponses au TP Git & GitHub

## Partie 1

**Q1.** `--global` enregistre la configuration dans le fichier `~/.gitconfig` (dossier personnel de l'utilisateur) : elle vaut pour **tous** les dépôts de l'utilisateur. Sans `--global`, la configuration est écrite dans `.git/config` du dépôt courant et ne vaut que pour **ce dépôt** ; elle l'emporte sur la configuration globale en cas de conflit.

**Q2.** GitHub associe chaque commit à un compte grâce à l'email du commit. Si l'email ne correspond à aucun email du compte, les commits sont affichés sans lien avec le profil (pas d'avatar, pas de contribution comptée).

## Partie 2

**Q3.** Le dossier `.git` contient tout le dépôt : la base d'objets (commits, arbres, fichiers), les branches et tags (refs), `HEAD`, l'index et la configuration locale. En le supprimant on perd **tout l'historique** : il ne reste que les fichiers actuels du répertoire de travail, qui ne sont plus versionnés.

**Q4.** `git diff` compare le répertoire de travail à l'index (modifications **non indexées**). `git diff --staged` compare l'index au dernier commit (ce qui **partira au prochain commit**).

**Q5.** C'est le début (7 caractères) de l'identifiant SHA-1 du commit, un hachage unique qui identifie le commit. On l'utilise avec `git show`, `git revert`, `git reset`, etc.

## Partie 3

**Q6.** `Main.class` est un fichier **généré** par la compilation : il se reconstruit à partir de `Main.java`, dépend de la machine/version du JDK, alourdit le dépôt et crée des conflits inutiles. `.gitignore` liste les motifs à ignorer (`*.class`) : `git add .` n'ajoute alors plus ces fichiers par erreur et `git status` reste lisible.

**Q7.** `git revert <id>` crée un **nouveau commit** qui défait un commit ancien : l'historique est conservé. `git reset` **déplace la branche** vers un commit antérieur (et avec `--hard` efface aussi les modifications) : il **réécrit l'historique**. Sur une branche déjà partagée sur GitHub, on utilise `git revert`, car réécrire un historique déjà publié oblige les collègues à le réconcilier (push refusé, `--force` dangereux, conflits).

**Q8.** `HEAD~1` désigne le **parent du commit courant** (un commit avant `HEAD`) ; `HEAD~2` en remonte deux. « Detached HEAD » signifie que `HEAD` ne pointe plus sur une branche mais directement sur un commit : on peut regarder l'ancienne version, mais les nouveaux commits ne seraient rattachés à aucune branche (ils seraient perdus). `git switch main` permet de revenir au présent.

## Partie 4

**Q9.** Chaque branche pointe sur son propre commit et `git switch` remplace les fichiers du répertoire de travail par ceux du commit de la branche. Le fichier `Main.java` a le même nom, mais pas le même contenu dans les deux branches : la multiplication n'existe que dans les commits de `multiplication`, tant qu'elle n'est pas fusionnée.

**Q10.** Une fusion *fast-forward* a lieu quand la branche cible (`main`) n'a pas avancé depuis la création de l'autre branche : Git avance simplement le pointeur de `main`, sans nouveau commit. À l'étape 4.4, `main` **et** `titre` avaient chacune un commit propre (histoires divergentes) : Git doit les réunir par un **commit de fusion** à deux parents.

**Q11.** `<<<<<<< HEAD` ouvre la version de la branche courante (`main`), `=======` sépare les deux versions, `>>>>>>> titre` ferme la version de la branche fusionnée. Git ne peut pas fusionner seul quand **les deux branches modifient les mêmes lignes** d'un même fichier (ou qu'une branche modifie un fichier supprimé par l'autre) : il faut choisir ou combiner à la main.

## Partie 5

**Q12.** `origin` est le nom (alias) par défaut du dépôt distant, ici celui sur GitHub, enregistré par `git remote add` ou `git clone`. L'option `-u` (`--set-upstream`) mémorise le lien entre la branche locale `main` et `origin/main` : ensuite `git push` et `git pull` suffisent sans arguments.

**Q13.** `git fetch` télécharge les nouveaux commits du dépôt distant **sans toucher** à la copie de travail ni à la branche locale. `git pull` = `git fetch` **+ `git merge`** : il télécharge puis fusionne dans la branche courante.

**Q14.** Le push a été refusé (*rejected*) car le dépôt distant contenait un commit (la division, poussé depuis `poste2`) absent de l'historique local : Git refuse d'écraser ce travail. Il faut d'abord `git pull` (résoudre un éventuel conflit) puis `git push`. Bonne habitude : **faire `git pull` (ou `git fetch`) avant de pousser**, et pousser souvent.

## Partie 6

**Q15.** Un **fork** est une copie d'un dépôt GitHub dans *votre* compte (côté serveur). Un **clone** est une copie du dépôt distant sur *votre machine* (avec tout l'historique). Une **branche** est une ligne de développement à l'intérieur d'un même dépôt : un simple pointeur vers un commit.

**Q16.** Une branche dédiée isole la fonctionnalité, garde `main` propre et stable, permet de continuer à travailler/corriger la PR (les nouveaux commits poussés s'y ajoutent), évite des conflits avec `main` et permet plusieurs PR en parallèle. Une PR depuis `main` mélangerait tout et empêcherait de resynchroniser `main` avec le projet d'origine.

**Q17.** `origin` pointe vers **mon fork** (là où j'ai le droit de pousser). `upstream` pointe vers **le dépôt d'origine du propriétaire** : on s'en sert (`git fetch upstream`, `git merge upstream/main`) pour récupérer ses nouveautés et garder son fork à jour.

*Note : le TP a été réalisé seul : la PR est faite d'une branche vers `main` dans le même dépôt (PR #1 puissance, PR #2 modulo qui ferme l'issue #2).*

## Partie 7

**Q18.** *À compléter après avoir fait les niveaux sur https://learngitbranching.js.org/?locale=fr_FR*

| Niveau | Mes commandes | Mon score / optimal |
|---|---|---|
| … | … | … |
| … | … | … |
| … | … | … |
