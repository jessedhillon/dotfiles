export TRACKER_TOKEN=$(cat << EOF | gpg --dearmor
-----BEGIN PGP ARMORED FILE-----
Version: GnuPG v1

ZmNjNmFiMGEwOGNjMzQ2NjUwMGNjZGZkNDRhMTU4MTYK
=YIF5
-----END PGP ARMORED FILE-----
EOF
)
