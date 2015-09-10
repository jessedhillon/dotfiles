export SOPHIA_DATABASE_URL=$(cat << EOF | gpg --dearmor
-----BEGIN PGP ARMORED FILE-----
Version: GnuPG v1

bXlzcWwyOi8vamVzc2UuZGhpbGxvbjo3R3F4OGl0TUdPaURmcFRAc29waGlhZGIu
Y3RyZ2l0ZG1oM2puLnVzLWVhc3QtMS5yZHMuYW1hem9uYXdzLmNvbTozMzA2L3Nv
cGhpYQo=
=RiX/
-----END PGP ARMORED FILE-----
EOF
)
