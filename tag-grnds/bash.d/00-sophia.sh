export SOPHIA_DATABASE_URL=$(cat << EOF | gpg --dearmor
-----BEGIN PGP ARMORED FILE-----
Version: GnuPG v1

bXlzcWwyOi8vamVzc2UuZGhpbGxvbjo3R3F4OGl0TUdPaURmcFRAaHEtbXlzcWwu
YW5hbHl0aWNzLmdyYW5kcm91bmRzLmNvbTozMzA2L3NvcGhpYQo=
=b3LR
-----END PGP ARMORED FILE-----
EOF
)
