echo "Determining version number for publication"
echo "Looking for an existing release tag against this commit"

VERSION=$(git describe --tags --match release/* --exact-match 2>&1)
if [ $? -ne 0 ]
then
  LAST=$(git describe --tags --match release/* 2>&1)
  if [ $? -ne 0 ]
  then
    echo "No release tags found at all; bail out"
    exit 1
  fi

  echo "No matching tag found. Push a tag like release/1.0.1 against HEAD in order to release.  Most recent tag is: ${LAST}"
  exit 0
fi

VERSION=$(echo $VERSION | sed 's#release/##g')
echo "Publishing version: ${VERSION}"

#status=$(curl -s --head -w %{http_code} -o /dev/null https://TODO-somewhere-on-maven-central/com.github.dalet-oss/mongobee/${VERSION}/)
#if [ $status -eq 200 ]
#then
#  echo "Version already published - nothing to do here"
#else
  # Decrypt the gpg key used for signing, and add it to gpg
   openssl aes-256-cbc -K $encrypted_a559f7c88919_key -iv $encrypted_a559f7c88919_iv -in secret.gpg.enc -out secret.gpg -d
  export GPG_TTY=$(tty)
  gpg --import secret.gpg

  # Build, sign and publish the artifacts
  mvn -Prelease deploy -Drevision=${VERSION} -Dgpgkey.passphrase=${SONATYPE_GPGKEY_PASSPHRASE}
#fi
