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
  mvn -P release deploy -Drevision=${VERSION}
#fi
