set -e
export GIT_EDITOR=true
rm -rf /tmp/work /tmp/remote /tmp/poste2 /tmp/web
mkdir -p /tmp/work /tmp/remote
cd /tmp/work

# ---------- Partie 1 ---
git config --global user.name "Prénom Nom"
git config --global user.email "email-de-votre-compte-github@exemple.com"
git config --global init.defaultBranch main
git config --global core.editor nano
git config --global pull.rebase false

mk() {
  { echo "// Le fichier doit s'appeler Main.java, comme la classe publique Main"
    echo "public class Main {"
    for op in "$@"; do case $op in
      addition) echo '    static int addition(int a, int b) { return a + b; }';;
      soustraction) echo '    static int soustraction(int a, int b) { return a - b; }';;
      multiplication) echo '    static int multiplication(int a, int b) { return a * b; }';;
      division) echo '    static int division(int a, int b) { return a / b; }';;
      puissance) echo '    static int puissance(int base, int exposant) { int r = 1; for (int i = 0; i < exposant; i++) r *= base; return r; }';;
      modulo) echo '    static int modulo(int a, int b) { return a % b; }';;
    esac; done
    echo "    public static void main(String[] args) {"
    for op in "$@"; do case $op in
      addition) echo '        System.out.println("2 + 3 = " + addition(2, 3));';;
      soustraction) echo '        System.out.println("5 - 2 = " + soustraction(5, 2));';;
      multiplication) echo '        System.out.println("4 * 3 = " + multiplication(4, 3));';;
      division) echo '        System.out.println("10 / 2 = " + division(10, 2));';;
      puissance) echo '        System.out.println("2 ^ 10 = " + puissance(2, 10));';;
      modulo) echo '        System.out.println("10 % 3 = " + modulo(10, 3));';;
    esac; done
    echo "    }"; echo "}"; } > Main.java
}
test_java() { javac Main.java && java Main; }

# ---------- Partie 2 ----------
git init
mk addition; test_java
echo "# Calculatrice" > README.md
git add Main.java README.md
git commit -m "Ajoute la méthode addition et le README"

mk addition soustraction; test_java
git diff --staged --quiet && echo "(rien d'indexé avant add)"
git add Main.java
git commit -m "Ajoute la méthode soustraction"

cat > REPONSES.md <<'EOF'
# Réponses au TP Git & GitHub

## Partie 1

**Q1.** `--global` enregistre la configuration dans le fichier `~/.gitconfig` (dossier personnel de l'utilisateur) : elle vaut pour **tous** les dépôts de l'utilisateur. Sans `--global`, la configuration est écrite dans `.git/config` du dépôt courant et ne vaut que pour **ce dépôt** ; elle l'emporte sur la configuration globale en cas de conflit.

**Q2.** GitHub associe chaque commit à un compte grâce à l'email du commit. Si l'email ne correspond à aucun email du compte, les commits sont affichés sans lien avec le profil (pas d'avatar, pas de contribution comptée).
EOF
git add REPONSES.md
git commit -m "Ajoute REPONSES.md avec Q1 et Q2"

printf '\nCalculatrice en ligne de commande, écrite en Java.\n' >> README.md
git add README.md
git commit -m "Ajoute une description au README"
git log --oneline --graph

cat >> REPONSES.md <<'EOF'

## Partie 2

**Q3.** Le dossier `.git` contient tout le dépôt : la base d'objets (commits, arbres, fichiers), les branches et tags (refs), `HEAD`, l'index et la configuration locale. En le supprimant on perd **tout l'historique** : il ne reste que les fichiers actuels du répertoire de travail, qui ne sont plus versionnés.

**Q4.** `git diff` compare le répertoire de travail à l'index (modifications **non indexées**). `git diff --staged` compare l'index au dernier commit (ce qui **partira au prochain commit**).

**Q5.** C'est le début (7 caractères) de l'identifiant SHA-1 du commit, un hachage unique qui identifie le commit. On l'utilise avec `git show`, `git revert`, `git reset`, etc.
EOF
git add REPONSES.md
git commit -m "Répond aux questions Q3 à Q5"

# ---------- Partie 3 ----------
javac Main.java; java Main
git status --short
printf '*.class\n*~\n' > .gitignore
git status --short
git add .gitignore
git commit -m "Ajoute .gitignore (bytecode et fichiers temporaires)"

git add -f Main.class && git commit -m "Ajoute Main.class (erreur)"
git rm --cached Main.class
git commit -m "Retire Main.class du suivi"
ls Main.class
git commit --amend -m "Retire le bytecode Main.class du suivi"

echo "n'importe quoi" >> Main.java
git restore Main.java

echo "brouillon" >> README.md
git add README.md
git restore --staged README.md
git restore README.md

echo "Ligne inutile" >> README.md
git commit -am "Ajoute une ligne inutile au README"
git revert --no-edit HEAD
git log --oneline

echo "test" > test.txt
git add test.txt && git commit -m "Commit de test"
git reset --soft HEAD~1
git status --short
git commit -m "Commit de test"
git reset --hard HEAD~1
FIRST=$(git rev-list --max-parents=0 HEAD)
git switch --detach $FIRST 2>&1 | head -2
cat Main.java
git switch main

cat >> REPONSES.md <<'EOF'

## Partie 3

**Q6.** `Main.class` est un fichier **généré** par la compilation : il se reconstruit à partir de `Main.java`, dépend de la machine/version du JDK, alourdit le dépôt et crée des conflits inutiles. `.gitignore` liste les motifs à ignorer (`*.class`) : `git add .` n'ajoute alors plus ces fichiers par erreur et `git status` reste lisible.

**Q7.** `git revert <id>` crée un **nouveau commit** qui défait un commit ancien : l'historique est conservé. `git reset` **déplace la branche** vers un commit antérieur (et avec `--hard` efface aussi les modifications) : il **réécrit l'historique**. Sur une branche déjà partagée sur GitHub, on utilise `git revert`, car réécrire un historique déjà publié oblige les collègues à le réconcilier (push refusé, `--force` dangereux, conflits).

**Q8.** `HEAD~1` désigne le **parent du commit courant** (un commit avant `HEAD`) ; `HEAD~2` en remonte deux. « Detached HEAD » signifie que `HEAD` ne pointe plus sur une branche mais directement sur un commit : on peut regarder l'ancienne version, mais les nouveaux commits ne seraient rattachés à aucune branche (ils seraient perdus). `git switch main` permet de revenir au présent.
EOF
git add REPONSES.md
git commit -m "Répond aux questions Q6 à Q8"

# ---------- Partie 4 ----------
git switch -c multiplication
mk addition soustraction multiplication; test_java
git commit -am "Ajoute la méthode multiplication"
git switch main
grep -c multiplication Main.java || true
git log --oneline --graph --all
git merge multiplication   # Fast-forward
git log --oneline --graph --all

git switch -c titre
sed -i '1s/.*/# Calculatrice v2/' README.md
git commit -am "Change le titre en Calculatrice v2"
git switch main
sed -i '1s/.*/# Calculatrice en Java/' README.md
git commit -am "Change le titre en Calculatrice en Java"
git merge titre || true
cat README.md
sed -i '1,/^>>>>>>> titre$/c\# Calculatrice en Java v2' README.md
cat README.md
git add README.md
git commit -m "Fusionne la branche titre (résolution du conflit)"
git log --oneline --graph --all
git branch -d multiplication titre

cat >> REPONSES.md <<'EOF'

## Partie 4

**Q9.** Chaque branche pointe sur son propre commit et `git switch` remplace les fichiers du répertoire de travail par ceux du commit de la branche. Le fichier `Main.java` a le même nom, mais pas le même contenu dans les deux branches : la multiplication n'existe que dans les commits de `multiplication`, tant qu'elle n'est pas fusionnée.

**Q10.** Une fusion *fast-forward* a lieu quand la branche cible (`main`) n'a pas avancé depuis la création de l'autre branche : Git avance simplement le pointeur de `main`, sans nouveau commit. À l'étape 4.4, `main` **et** `titre` avaient chacune un commit propre (histoires divergentes) : Git doit les réunir par un **commit de fusion** à deux parents.

**Q11.** `<<<<<<< HEAD` ouvre la version de la branche courante (`main`), `=======` sépare les deux versions, `>>>>>>> titre` ferme la version de la branche fusionnée. Git ne peut pas fusionner seul quand **les deux branches modifient les mêmes lignes** d'un même fichier (ou qu'une branche modifie un fichier supprimé par l'autre) : il faut choisir ou combiner à la main.
EOF
git add REPONSES.md
git commit -m "Répond aux questions Q9 à Q11"

# ---------- Partie 5 (remote simulé : dépôt bare local) ----------
git init --bare -b main /tmp/remote/tp-git-nom.git
git remote add origin /tmp/remote/tp-git-nom.git
git remote -v
git push -u origin main

# 5.4 modification "en ligne"
git clone /tmp/remote/tp-git-nom.git /tmp/web
( cd /tmp/web && echo "Modifié en ligne sur GitHub." >> README.md && git commit -am "Update README.md" && git push )
git fetch
git status | head -3
git pull

# 5.5 deuxième poste
git clone /tmp/remote/tp-git-nom.git /tmp/poste2
( cd /tmp/poste2 && mk addition soustraction multiplication division && git commit -am "Ajoute la méthode division" && git push )
mk addition soustraction multiplication   # (pas de division en local, comme dans le TP)
cat >> REPONSES.md <<'EOF'

## Partie 5

**Q12.** `origin` est le nom (alias) par défaut du dépôt distant, ici celui sur GitHub, enregistré par `git remote add` ou `git clone`. L'option `-u` (`--set-upstream`) mémorise le lien entre la branche locale `main` et `origin/main` : ensuite `git push` et `git pull` suffisent sans arguments.

**Q13.** `git fetch` télécharge les nouveaux commits du dépôt distant **sans toucher** à la copie de travail ni à la branche locale. `git pull` = `git fetch` **+ `git merge`** : il télécharge puis fusionne dans la branche courante.

**Q14.** Le push a été refusé (*rejected*) car le dépôt distant contenait un commit (la division, poussé depuis `poste2`) absent de l'historique local : Git refuse d'écraser ce travail. Il faut d'abord `git pull` (résoudre un éventuel conflit) puis `git push`. Bonne habitude : **faire `git pull` (ou `git fetch`) avant de pousser**, et pousser souvent.
EOF
git commit -am "Répond aux questions Q12 à Q14"
git push || echo ">>> PUSH REJETÉ comme prévu"
git pull
git push
git log --oneline --graph --all | head -20

# ---------- Partie 6 (fork/PR simulés : branche -> main dans le même dépôt) ----------
git switch -c puissance
mk addition soustraction multiplication division puissance; test_java
git commit -am "Ajoute la méthode puissance"
git push -u origin puissance
git commit --allow-empty -m "Corrige selon la relecture : documente puissance" -q
git push
git switch main
git merge --no-ff puissance -m "Merge pull request #1 from puissance"
git push

git switch -c modulo
mk addition soustraction multiplication division puissance modulo; test_java
git commit -am "Ajoute le modulo (closes #2)"
git push -u origin modulo
git switch main
git merge --no-ff modulo -m "Merge pull request #2 from modulo"
git push
git push origin -d puissance modulo
git branch -d puissance modulo

cat >> REPONSES.md <<'EOF'

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
EOF
git add REPONSES.md
git commit -m "Répond aux questions Q15 à Q18"
git push
git log --oneline --graph --all
echo "NB commits: $(git rev-list --count HEAD)"
git status --short
