# NXR 🏁💥

**NXR** (Naves Cross Racing) est le site officiel du club de motocross de Naves.
Il permet aux visiteurs et membres de :

- Voir les entraînements et les courses à venir
- S'inscrire aux événements
- Accéder à un dashboard membre
- Découvrir les actualités et galeries photos
- Pour les admins : publier des articles, gérer les événements et les inscriptions

---

## 🚀 Fonctionnalités principales (MVP)

- Authentification (Devise)
- Rôles (membre & admin)
- Pages publiques (courses, trainings, articles, galeries)
- Dashboard membre
- Dashboard admin (gestion des contenus)

---

## 💻 Stack technique

- **Ruby on Rails** (7.x)
- **PostgreSQL**
- **Devise** pour l'authentification
- **Bootstrap** pour le design et la responsivité
- Déploiement prévu : Heroku

---

## ⚙️ Installation

```bash
git clone git@github.com:ton-compte/nxr.git
cd nxr
bundle install
yarn install # si tu utilises jsbundling
rails db:create
rails db:migrate
rails s
